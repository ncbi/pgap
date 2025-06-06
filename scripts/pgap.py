#!/usr/bin/env python3
from __future__ import print_function
import sys

min_python = (3,6)
try:
    assert(sys.version_info >= min_python)
except:
    from platform import python_version
    print("Python version", python_version(), "is too old.")
    print("Please use Python", ".".join(map(str,min_python)), "or later.")
    sys.exit()

import argparse
import atexit
import contextlib
import glob
import json
import multiprocessing as mp
import os
import platform
import queue
import re
import shutil
import subprocess
import tarfile
import time
import tempfile
import xml
import xml.dom.minidom


from io import open
from urllib.parse import urlparse, urlencode
from urllib.request import urlopen, urlretrieve, Request
from urllib.error import HTTPError

def is_venv():
    return (hasattr(sys, 'real_prefix') or
            (hasattr(sys, 'base_prefix') and sys.base_prefix != sys.prefix))

class urlopen_progress:
    timeout = 60
    retries = 10

    def __init__(self, url, quiet, teamcity):
        self.url = url
        self.bytes_so_far = 0
        self.urlopen()

        self.quiet = quiet
        self.teamcity = teamcity
        if teamcity:
            self.EOL = '\n'
        else:
            self.EOL = '\r'
        self.cur_row = -1
        total_size = 0
        total_size = self.remote_file.getheader('Content-Length', 0) # More modern method

        self.total_size = int(total_size)

    def urlopen(self):
        headers = dict()
        if self.bytes_so_far > 0:
            headers['Range'] = 'bytes={}-'.format(self.bytes_so_far)
        request = Request(self.url, headers=headers)
        self.remote_file = urlopen(request, timeout=self.timeout)

    def read(self, n=8388608):
        delay = 1
        for attempt in range(self.retries):
            try:
                if self.remote_file is None:
                    self.urlopen()
                buffer = self.remote_file.read(n)
                if not buffer:
                    if not self.quiet:
                        sys.stdout.write('\n')
                    return ''
                break
            except Exception as ex:
                self.remote_file = None
                time.sleep(delay)
                delay += delay

        self.bytes_so_far += len(buffer)
        percent = float(self.bytes_so_far) / self.total_size
        percent = round(percent*100, 2)

        do_print = True
        if self.teamcity:
            do_print = False
            row = int(percent)
            if row > self.cur_row:
                self.cur_row = row
                do_print = True

        if do_print and not self.quiet:
            sys.stderr.write("Downloaded %d of %d bytes (%0.2f%%)%s" % (self.bytes_so_far, self.total_size, percent, self.EOL))

        return buffer

def install_url(url, path, quiet, teamcity, guard_file):
    basename = os.path.basename(urlparse(url).path)
    try:
        local_file =  os.path.join(path, basename)
        if os.path.exists(local_file):
            if not quiet:
                print('Extracting local tarball: {}'.format(local_file))
            fileobj = open(local_file, 'rb')
        else:
            if not quiet:
                print('Downloading and extracting tarball: {}'.format(url))
            fileobj = urlopen_progress(url, quiet, teamcity)
        with tarfile.open(mode='r|*', fileobj=fileobj) as tar:
            tar.extractall(path=path)
    except:
        sys.stderr.write('''
ERROR: Failed to extract tarball; to install manually, try something like:
    curl -OLC - {}
    tar xvf {}
'''.format(url, basename))
        raise
    if guard_file != None:
        open(guard_file, 'a').close()

def quiet_remove(filename):
    with contextlib.suppress(FileNotFoundError):
        os.remove(filename)

def find_failed_step(filename):
    r = r"^\[(?P<time>[^\]]+)\] (?P<level>[^ ]+) \[(?P<source>[^ ]*) (?P<name>[^\]]*)\] (?P<status>.*)"
    search = re.compile(r)
    lines = open(filename, "r").readlines()
    nameStarts = {}
    start = -1
    for num, line in enumerate(lines):
        r = search.match(line)
        if r:
            name = r.group("name")
            if name not in nameStarts:
                nameStarts[name] = num

            if r.group("status") == "completed permanentFail":
                start = nameStarts[name]
                break
    if start > -1:
        print("Printing log starting from failed job:\n")
        for i in range(start, len(lines)):
            print(lines[i], end="")
    else:
        print("Unable to find error in log file.")

def get_cpus(self):
    if 'SLURM_CPUS_PER_TASK' in os.environ:
        return int(os.environ['SLURM_CPUS_PER_TASK'])
    elif 'NSLOTS' in os.environ:
        return int(os.environ['NSLOTS'])
    elif self.params.args.cpus:
        return self.params.args.cpus 
    else:
        return 0 
       
class Pipeline:

    def cleanup(self):
        for file in [self.yaml, self.submol]:
            if file != None:
                base =  os.path.basename(file)
                fullpath  = os.path.join(self.params.outputdir, base)
                if os.path.exists(fullpath):
                    os.remove(fullpath)
            
    def __init__(self, params, local_input, pipeline):
        self.params = params
        self.cwlfile = f"pgap/{pipeline}.cwl"
        self.pipename = pipeline.upper()
        self.pipeline = pipeline
        
        self.data_dir = os.path.abspath(self.params.data_path)
        self.input_dir = os.path.dirname(os.path.abspath(local_input))
        
        # input file location inside docker instance:
        self.input_file = '/pgap/output/pgap_input.yaml'
        submol =  self.get_submol(local_input)
        if ( submol != None ):
            self.submol = self.create_submolfile(submol, params.ani_output, params.ani_hr_output, params.args.auto_correct_tax)
        else:
            self.submol = None
        
        add_std_validation_exemptions = False
        args = self.params.args
        if (args.genome and args.organism) or args.asn1_input:
            add_std_validation_exemptions = True
        self.yaml = self.create_inputfile(local_input, add_std_validation_exemptions)
        if self.params.docker_type in ['singularity', 'apptainer']:
            self.make_singularity_cmd()
        elif self.params.docker_type == 'podman':
            self.make_podman_cmd()
        else:
            self.make_docker_cmd()

        self.cmd.extend(['cwltool',
                        '--timestamps',
                        '--debug',
                        '--disable-color',
                        '--preserve-entire-environment',
                        '--outdir', '/pgap/output'
                        ])

        # Debug flags for cwltool
        if self.params.args.debug:
            self.cmd.extend([
                '--tmpdir-prefix', '/pgap/output/debug/tmpdir/',
                '--leave-tmpdir',
                '--tmp-outdir-prefix', '/pgap/output/debug/tmp-outdir/',
                '--copy-outputs'])

        self.cmd.extend([self.cwlfile, self.input_file])

    def make_docker_cmd(self):
        self.cmd = [self.params.docker_cmd, 'run', '-i', '--rm' ]
        self.cmd.extend(['--platform', 'linux/amd64'])

        cpusEnv = get_cpus(self)
        if (cpusEnv):
            self.cmd.extend(['--cpus', str(get_cpus(self))])

        if self.params.args.no_internet:
            self.cmd.extend(['--network=none'])

        if (self.params.args.memory):
            self.cmd.extend(['--memory', self.params.args.memory])

        if self.params.docker_user_remap:
            self.cmd.extend(['--user', str(os.getuid()) + ":" + str(os.getgid())])
        self.cmd.extend([
            '--volume', '{}:/pgap/input:ro,z'.format(self.data_dir),
            '--volume', '{}:/pgap/user_input:z'.format(self.input_dir),
            '--volume', '{}:/pgap/output:rw,z'.format(self.params.outputdir),
            '--volume', '{}:{}:ro,z'.format(self.yaml, self.input_file ),
            '--volume', '{}:/tmp:rw,z'.format(os.getenv("TMPDIR", "/tmp"))])

        # Debug mount for docker image
        if self.params.args.debug:
            log_dir = self.params.outputdir + '/debug/log'
            os.makedirs(log_dir, exist_ok=True)
            self.cmd.extend(['--volume', '{}:/log/srv:z'.format(log_dir)])
        if self.params.args.container_name:
            self.cmd.extend(['--name', self.params.args.container_name])
        self.cmd.append(self.params.docker_image)


    def make_podman_cmd(self):
        self.cmd = [self.params.docker_cmd]
        if self.params.args.debug:
            self.cmd.extend(['--log-level',  'debug'])
        self.cmd.extend(['run', '-i', '--rm', '--privileged' ])

        cpusEnv = get_cpus(self)
        if (cpusEnv):
            self.cmd.extend(['--cpus', str(get_cpus(self))])

        if self.params.args.no_internet:
            self.cmd.extend(['--network=none'])

        if (self.params.args.memory):
            self.cmd.extend(['--memory', self.params.args.memory])

        self.cmd.extend([
            '--volume', '{}:/pgap/input:ro,Z'.format(self.data_dir),
            '--volume', '{}:/pgap/user_input:Z'.format(self.input_dir),
            '--volume', '{}:/pgap/output:rw,Z'.format(self.params.outputdir),
            '--volume', '{}:{}:ro,Z'.format(self.yaml, self.input_file ),
            '--volume', '{}:/tmp:rw'.format(os.getenv("TMPDIR", "/tmp"))])

        # Debug mount for docker image
        if self.params.args.debug:
            log_dir = self.params.outputdir + '/debug/log'
            os.makedirs(log_dir, exist_ok=True)
            self.cmd.extend(['--volume', '{}:/log/srv'.format(log_dir)])
        if self.params.args.container_name:
            self.cmd.extend(['--name', self.params.args.container_name])
        self.cmd.append(self.params.docker_image)

    def make_singularity_cmd(self):
        self.cmd = [self.params.docker_cmd, 'exec' ]

        cpusEnv = get_cpus(self)
        if (cpusEnv):
            self.cmd.extend(['--cpus', str(get_cpus(self))])

        if self.params.args.no_internet:
            self.cmd.extend(['--network=none'])
        
        if (self.params.args.memory):
            self.cmd.extend(['--memory', self.params.args.memory])

        self.cmd.extend([
            '--bind', '{}:/pgap/input:ro'.format(self.data_dir),
            '--bind', '{}:/pgap/user_input'.format(self.input_dir),
            '--bind', '{}:/pgap/output:rw'.format(self.params.outputdir),
            '--bind', '{}:{}:ro'.format(self.yaml, self.input_file ),
            '--bind', '{}:/tmp:rw'.format(os.getenv("TMPDIR", "/tmp"))])

        # Debug mount for docker image
        if self.params.args.debug:
            log_dir = self.params.outputdir + '/debug/log'
            os.makedirs(log_dir, exist_ok=True)
            self.cmd.extend(['--bind', '{}:/log/srv'.format(log_dir)])

        if self.params.args.container_path:
            self.cmd.extend(["--pwd", "/pgap", self.params.docker_image])
        else:
            self.cmd.extend(["--pwd", "/pgap", "docker://" + self.params.docker_image])
        
    def get_submol(self, local_input):
        with open(local_input, 'r') as fIn:
            processing_submol = False
            for line in fIn:
                if line: # skip empty lines
                    if 'submol:' in line: # we need to replace submol/location with new file
                        processing_submol = True
                    if 'location:' in line and processing_submol == True:
                        line = line.replace('location: ','')
                        submol_file=line
                        submol_file=submol_file.strip()
                        return os.path.join(os.path.dirname(local_input), submol_file)
        return None
        
    def regexp_file(self, filename, field):
        
        with open(filename, 'r') as fIn:
            for line in fIn:
                if(re.search(field,line)):
                    return True
        return False
    def get_genus_species(self, xml_file):
        genus_species = None
        try:
            doc = xml.dom.minidom.parse(xml_file)
            predicted_taxid = doc.getElementsByTagName('predicted-taxid')[0]
            if predicted_taxid.getAttribute('confidence')=='HIGH':
                genus_species = predicted_taxid.getAttribute('org-name')
        except:
            genus_species = None
        return genus_species

    def create_submolfile(self, local_submol, ani_output, ani_hr_output, auto_correct_tax):
        has_authors = self.regexp_file(local_submol, '^authors:')
        has_contact_info = self.regexp_file(local_submol, '^contact_info:')
        genus_species = None
        if auto_correct_tax:
            if ani_output != None: 
                genus_species = self.get_genus_species(ani_output)
                if genus_species != None:
                    print('ANI analysis detected species "{}", and we will use it for PGAP'.format(genus_species))
                else:
                    if ani_hr_output != None:
                        chosen_ani_output_type = ani_hr_output
                    else:
                        chosen_ani_output_type = ani_output
                    print('ERROR: taxcheck failed to assign a species with high confidence, thus PGAP will not execute. See {}'.format(chosen_ani_output_type))
                        
                    sys.exit(1)
        with tempfile.NamedTemporaryFile(mode='w',
                                         suffix=".yaml",
                                         prefix="pgap_submol_",
                                         dir=self.params.outputdir,
                                         delete=False) as fOut:
            yaml = os.path.basename(fOut.name)
            with open(local_submol, 'r') as fIn:
                for line in fIn:
                    if line: # skip empty lines
                        if auto_correct_tax and genus_species != None and re.match(r'\s+genus_species:', line):
                            print('replacing organism in line: {}'.format(line.rstrip()))
                            line = re.sub(r'genus_species:.*', "genus_species: '{}'".format(genus_species), line)
                            print('with organism: {}'.format(genus_species))
                        fOut.write(line.rstrip())
                        fOut.write(u'\n')
            if  has_authors == False:
                fOut.write(u'authors:\n')
                fOut.write(u'    - author:\n')
                #
                # note: do not change these defaults, they are coded now 
                # in standard diagnostics asnvalidate tool, that's how GenBank detects that users did not provide correct names
                #
                fOut.write(u"        first_name: 'Firstname'\n")
                fOut.write(u"        last_name: 'Lastname'\n")
            if  has_contact_info == False:
                fOut.write(u'contact_info:\n')
                fOut.write(u"        first_name: 'Firstname'\n")
                fOut.write(u"        last_name: 'Lastname'\n")
                fOut.write(u"        email: 'Email@address.net'\n")
                fOut.write(u"        organization: 'Organization'\n")
                fOut.write(u"        department: 'Department'\n")
                fOut.write(u"        phone: '301-555-0245'\n")
                fOut.write(u"        street: '100 Street St'\n")
                fOut.write(u"        city: 'City'\n")
                fOut.write(u"        postal_code: '12345'\n")
                fOut.write(u"        country: 'Country'\n")
            fOut.flush()
        return yaml
            
        
    def create_inputfile(self, local_input, add_std_validation_exemptions):
        with tempfile.NamedTemporaryFile(mode='w',
                                         suffix=".yaml",
                                         prefix="pgap_input_",
                                         dir=self.params.outputdir,
                                         delete=False) as fOut:
            yaml = fOut.name
            with open(local_input, 'r') as fIn:
                processing_submol = False
                processing_fasta = False
                processing_entries = False
                processing_submol_json = False
                for line in fIn:
                    if line: # skip empty lines
                        if 'submol:' in line: # we need to replace submol/location with new file
                            processing_submol = True
                            processing_fasta = False
                            processing_entries = False
                            processing_submol_json = False
                        if 'location:' in line and processing_submol:
                            processing_submol = False
                            processing_entries = False
                            processing_submol_json = False
                            pos = line.index('location: ')
                            line = ' ' * pos + u'location: '+self.submol + '\n'
                        if 'fasta:' in line: # we need to copy fasta input to output_dir
                            processing_submol = False
                            processing_fasta = True
                            processing_entries = False
                            processing_submol_json = False
                        if 'entries:' in line: # we need to copy entries input to output_dir
                            processing_submol = False
                            processing_fasta = False
                            processing_submol_json = False
                            processing_entries = True
                        if 'submol_block_json:' in line: 
                            processing_submol = False
                            processing_fasta = False
                            processing_submol_json = True
                            processing_entries = False
                        if 'location:' in line:
                            local_input_dir = os.path.dirname(os.path.abspath(local_input))
                            if processing_fasta:
                                processing_fasta = False
                                input_fasta_location = None
                                if self.params.args.genome:
                                    input_fasta_location = self.params.args.genome
                                else: 
                                    match = re.search(r'location:\s+(\S+)', line)
                                    input_fasta_location = os.path.join(local_input_dir, match.group(1))
                                copy_genome_to_workspace(input_fasta_location, self.params.outputdir)
                            elif processing_entries:
                                processing_entries = False
                                match = re.search(r'location:\s+(\S+)', line)
                                input_entries_location = os.path.join(local_input_dir, match.group(1))
                                copy_genome_to_workspace(input_entries_location, self.params.outputdir)
                            elif processing_submol_json:
                                processing_submol_json = False
                                match = re.search(r'location:\s+(\S+)', line)
                                input_submol_json_location = os.path.join(local_input_dir, match.group(1))
                                copy_genome_to_workspace(input_submol_json_location, self.params.outputdir)
                        
                        fOut.write(line.rstrip())
                        fOut.write(u'\n')
            fOut.write(u'supplemental_data: { class: Directory, location: /pgap/input }\n')
            if (self.params.report_usage != 'none'):
                fOut.write(u'report_usage: {}\n'.format(self.params.report_usage))
            if (self.params.ignore_all_errors == 'true'):
                fOut.write(u'ignore_all_errors: {}\n'.format(self.params.ignore_all_errors))
            if (self.params.no_internet == 'true'):
                fOut.write(u'no_internet: {}\n'.format(self.params.no_internet))
            uuidfile = self.params.outputdir + "/uuid.txt"
            if os.path.exists(uuidfile) and os.stat(uuidfile).st_size != 0:
                fOut.write(u'make_uuid: false\n')
                fOut.write(u'uuid_in: { class: File, location: /pgap/output/uuid.txt }\n')
            if add_std_validation_exemptions:
                if self.pipeline == 'wf_common':
                    fOut.write(f"""
xpath_fail_initial_asndisc: >
    //*[@severity="FATAL"
         and not(contains(@name, "CITSUBAFFIL_CONFLICT"))
    ]
xpath_fail_initial_asnvalidate: >
        //*[
            ( @severity="ERROR" or @severity="REJECT" )
            and not(contains(@code, "SEQ_DESCR_BadOrgMod")) 
            and not(contains(@code, "SEQ_PKG_NucProtProblem")) 
            and not(contains(@code, "SEQ_DESCR_BacteriaMissingSourceQualifier"))
        ]
xpath_fail_final_asnvalidate: >
        //*[( @severity="ERROR" or @severity="REJECT" )
            and not(contains(@code, "GENERIC_MissingPubRequirement"))
            and not(contains(@code, "SEQ_DESCR_BadOrgMod")) 
            and not(contains(@code, "SEQ_DESCR_BacteriaMissingSourceQualifier"))
            and not(contains(@code, "SEQ_DESCR_Chromosomepath"))
            and not(contains(@code, "SEQ_DESCR_MissingLineage"))
            and not(contains(@code, "SEQ_DESCR_NoTaxonID"))
            and not(contains(@code, "SEQ_DESCR_UnwantedCompleteFlag"))
            and not(contains(@code, "SEQ_FEAT_ShortIntron"))
            and not(contains(@code, "SEQ_INST_InternalNsInSeqRaw"))
            and not(contains(@code, "SEQ_INST_ProteinsHaveGeneralID"))
            and not(contains(@code, "SEQ_PKG_ComponentMissingTitle"))
            and not(contains(@code, "SEQ_PKG_NucProtProblem")) 
        ]
contact_as_author_possible: false
""")
                else:
                    fOut.write(f"""
xpath_fail_initial_asnvalidate: >
        //*[
            ( @severity="ERROR" or @severity="REJECT" )
            and not(contains(@code, "GENERIC_MissingPubRequirement")) 
            and not(contains(@code, "GENERIC_BadSubmissionAuthorName")) 
            and not(contains(@code, "SEQ_DESCR_ChromosomeLocation")) 
            and not(contains(@code, "SEQ_DESCR_MissingLineage")) 
            and not(contains(@code, "SEQ_DESCR_NoTaxonID")) 
            and not(contains(@code, "SEQ_DESCR_OrganismIsUndefinedSpecies"))
            and not(contains(@code, "SEQ_DESCR_StrainWithEnvironSample"))
            and not(contains(@code, "SEQ_DESCR_BacteriaMissingSourceQualifier"))
            and not(contains(@code, "SEQ_DESCR_UnwantedCompleteFlag")) 
            and not(contains(@code, "SEQ_FEAT_BadCharInAuthorLastName")) 
            and not(contains(@code, "SEQ_FEAT_ShortIntron")) 
            and not(contains(@code, "SEQ_INST_InternalNsInSeqRaw")) 
            and not(contains(@code, "SEQ_INST_ProteinsHaveGeneralID")) 
            and not(contains(@code, "SEQ_PKG_NucProtProblem")) 
            and not(contains(@code, "SEQ_PKG_ComponentMissingTitle")) 
        ]
xpath_fail_final_asnvalidate: >
        //*[( @severity="ERROR" or @severity="REJECT" )
            and not(contains(@code, "GENERIC_MissingPubRequirement")) 
            and not(contains(@code, "GENERIC_BadSubmissionAuthorName")) 
            and not(contains(@code, "SEQ_DESCR_ChromosomeLocation")) 
            and not(contains(@code, "SEQ_DESCR_MissingLineage")) 
            and not(contains(@code, "SEQ_DESCR_NoTaxonID")) 
            and not(contains(@code, "SEQ_DESCR_OrganismIsUndefinedSpecies"))
            and not(contains(@code, "SEQ_DESCR_StrainWithEnvironSample"))
            and not(contains(@code, "SEQ_DESCR_BacteriaMissingSourceQualifier"))
            and not(contains(@code, "SEQ_DESCR_UnwantedCompleteFlag")) 
            and not(contains(@code, "SEQ_FEAT_BadCharInAuthorLastName")) 
            and not(contains(@code, "SEQ_FEAT_ShortIntron")) 
            and not(contains(@code, "SEQ_INST_InternalNsInSeqRaw")) 
            and not(contains(@code, "SEQ_INST_ProteinsHaveGeneralID")) 
            and not(contains(@code, "SEQ_PKG_ComponentMissingTitle")) 
            and not(contains(@code, "SEQ_PKG_NucProtProblem")) 
        ]
""")
            fOut.flush()
        return yaml
        
    def report_output_files(self, output, output_files):
        # output_files = [
        # {"file": "", "remove": True},
        # ]
        for output_pair in output_files:
            fullname = os.path.join(output, output_pair["file"])
            if os.path.exists(fullname) and os.path.getsize(fullname) > 0:
                print(f'FILE: {output_pair["file"]}')
                with open(fullname, 'r') as f:
                    print(f.read())
                if output_pair["remove"]:
                    os.remove(fullname)
        

    def launch(self):
        cwllog = self.params.outputdir + '/cwltool.log'
        with open(cwllog, 'a', encoding="utf-8") as f:
            # Show original command line in log
            cmdline = "Original command: " + " ".join(sys.argv)
            f.write(cmdline)
            f.write("\n\n")
            # Show docker command line in log
            cmdline = "Docker command: " + " ".join(self.cmd)
            f.write(cmdline)
            f.write("\n\n")
            # Show YAML file in the log
            f.write("--- Start YAML Input ---\n")            
            with open(self.yaml, 'r') as fIn:
                for line in fIn:
                    f.write(line)
            f.write("--- End YAML Input ---\n\n")

            try:
                proc = subprocess.Popen(self.cmd, stdout=f, stderr=subprocess.STDOUT)
                proc.wait()
            finally:
                if proc.returncode == None:
                    print('\nAbnormal termination, stopping all processes.')
                    proc.terminate()
                elif proc.returncode == 0:
                    if self.pipename != "WF_COMMON":
                        print(f'{self.pipename} completed successfully.')
                else:
                    print(f'{self.pipename} failed, docker exited with rc =', proc.returncode)
                    find_failed_step(cwllog)
                output_files = [
                        {"file": "final_asndisc_diag.xml", "remove": True},
                        {"file": "final_asnval_diag.xml", "remove": True},
                        {"file": "initial_asndisc_diag.xml", "remove": True},
                        {"file": "initial_asnval_diag.xml", "remove": True}
                    ]
                self.report_output_files(self.params.outputdir, output_files)
        return proc.returncode

class Setup:

    def __init__(self, args):
        self.args = args
        self.ani_output = None
        # human readable ANI output file
        self.ani_hr_output = None
        self.branch          = self.get_branch()
        self.repo            = self.get_repo()
        self.registry_docker_hub_version = "v2"

        if platform.system() == 'Windows':
            self.install_dir     = os.environ.get('PGAP_INPUT_DIR',os.environ['USERPROFILE']+'/.pgap')
        else:
            self.install_dir     = os.environ.get('PGAP_INPUT_DIR',os.environ['HOME']+'/.pgap')

        self.local_version   = self.get_local_version()
        if self.args.no_internet or self.args.no_self_up:
            self.remote_versions = [self.local_version]
        else:
            self.remote_versions = self.get_remote_versions()
        self.report_usage    = self.get_report_usage()
        self.ignore_all_errors    = self.get_ignore_all_errors()
        self.no_internet     = self.get_no_internet()
        self.timeout         = self.get_timeout()
        self.check_status()
        if args.version:
            sys.exit(0)
        if (args.list):
            self.list_remote_versions()
            return
        self.use_version = self.get_use_version()
        if self.args.container_path:
            self.docker_image = self.args.container_path
        else:
            self.docker_image = "ncbi/{}:{}".format(self.repo, self.use_version)
        self.data_path = '{}/input-{}'.format(self.install_dir, self.use_version)
        self.test_genomes_path = '{}/test_genomes-{}'.format(self.install_dir, self.use_version)
        self.outputdir = self.get_output_dir()
        self.get_docker_info()
        if self.docker_type == 'podman':
            # see PGAPX-1073
            self.docker_image = "docker.io/ncbi/{}:{}".format(self.repo, self.use_version)
        
        self.update_self()
        if (self.local_version != self.use_version) or not self.check_install_data():
            self.update()

        

    def get_branch(self):
        if (self.args.dev):
            return "dev"
        if (self.args.test):
            return "test"
        if (self.args.prod):
            return "prod"
        return ""

    def get_repo(self):
        if self.branch == "":
            return "pgap"
        return "pgap-"+self.branch

    def get_local_version(self):
        filename = self.install_dir + "/VERSION"
        if os.path.isfile(filename):
            with open(filename, encoding='utf-8') as f:
                return f.read().strip()
        return None


    def get_remote_versions(self):
        versions = []
        if (self.get_branch()):
            #print("Checking docker hub for latest version.")
            url = f'https://registry.hub.docker.com/{self.registry_docker_hub_version}/repositories/ncbi/{self.repo}/tags'
            response = urlopen(url)
            json_resp = json.loads(response.read().decode())
            if self.registry_docker_hub_version == 'v2':
                # looks like these are already sorted in right order in this version 
                for result in json_resp['results']:
                    versions.append(result['name'])
            elif self.registry_docker_hub_version == 'v1':
                for i in reversed(json_resp):
                     versions.append(i['name'])
            else:
                raise Exception(f'INTERNAL ERROR: chosen docker hub  registry version {self.registry_docker_hub_version} is not supporter.')
        else:
            #print("Checking github releases for latest version.")
            response = urlopen('https://api.github.com/repos/ncbi/pgap/releases/latest')
            latest = json.loads(response.read().decode())['tag_name']
            versions.append(latest)
        return versions

    def check_status(self):
        if self.local_version == None:
            print("The latest version of PGAP is {}, you have nothing installed locally.".format(self.get_latest_version()))
            return False
        if self.args.no_internet:
            print("--no-internet flag enabled, not checking remote versions.")
            return True
        if self.args.no_self_up:
            print("--no-self-update flag enabled, not checking remote versions.")
            return True
        if self.local_version == self.get_latest_version():
            if self.branch == "":
                print("PGAP version {} is up to date.".format(self.local_version))
            else:
                print("PGAP from {} branch, version {} is up to date.".format(self.branch, self.local_version))
            return True
        print("The latest version of PGAP is {}, you are using version {}, please update.".format(self.get_latest_version(), self.local_version))
        return True

    def list_remote_versions(self):
        print("Available versions:")
        for i in self.remote_versions:
            print("\t", i)

    def get_latest_version(self):
        return self.remote_versions[0]

    def get_use_version(self):
        if self.args.use_version:
            return self.args.use_version
        if (self.local_version == None) or self.args.update:
            return self.get_latest_version()
        return self.local_version

    def get_output_dir(self):
        return os.path.abspath(self.args.output)

    def get_docker_info(self):
        docker_type_alternatives = ['docker', 'podman', 'singularity', 'apptainer']
        if self.args.docker:
            self.docker_cmd = shutil.which(self.args.docker)
        else:
            for docker in docker_type_alternatives:
                self.docker_cmd = shutil.which(docker)
                if self.docker_cmd != None:
                    break
        if self.docker_cmd == None:
            sys.exit("Docker not found.")

        version = subprocess.run([self.docker_cmd, '--version'], check=True, stdout=subprocess.PIPE, stdin=subprocess.DEVNULL).stdout.decode('utf-8')
        self.docker_type = version.split(maxsplit=1)[0].lower()
        if self.docker_type not in docker_type_alternatives:
            self.docker_type = os.path.basename(os.path.realpath(self.docker_cmd)).lower()
            if self.docker_type not in docker_type_alternatives:
                self.docker_type = 'docker'
                print('WARNING: {} ({}) support as Docker alternative has not been tested'.format(version, self.docker_cmd))
        self.docker_user_remap = (self.docker_type == 'docker' and platform.system() != "Windows")

    def get_report_usage(self):
        if (self.args.report_usage_true):
            return 'true'
        if (self.args.report_usage_false):
            return 'false'
        return 'none'
        
    def get_ignore_all_errors(self):
        if (self.args.ignore_all_errors):
            return 'true'
        else:
            return 'false'

    def get_no_internet(self):
        if (self.args.no_internet):
            return 'true'
        else:
            return 'false'
            
    def get_timeout(self):
        def str2sec(s):
            return sum(x * int(t) for x, t in
                    zip(
                        [1, 60, 3600, 86400],
                        reversed(s.split(":"))
                        ))
        return str2sec(self.args.timeout)

    def update(self):
        print(f"installation directory: {self.install_dir}")
        subprocess.run(["/bin/df", "-k", self.install_dir], stdin=subprocess.DEVNULL)
        self.update_self()
        threads = list()
        docker_thread = mp.Process(target = self.install_docker, name='docker image pull')
        docker_thread.start()
        threads.append(docker_thread)
        # precreate the directory where the tarfile will be unloaded.
        os.makedirs(f"{self.install_dir}/input-{self.use_version}/uniColl_path", exist_ok=True)
        self.install_data(threads)
        genomes_thread = mp.Process(target = self.install_test_genomes, name='test genomes installation')
        genomes_thread.start()
        threads.append(genomes_thread)
        global_exit_value = 0
        for thread in threads:
            thread.join()
            if thread.exitcode != 0:
                print(f"Error: thread '{thread.name}' failed with exit code {thread.exitcode}", file=sys.stderr)
                global_exit_value = thread.exitcode
        if global_exit_value != 0:
            raise Exception(f'installation of some or all of components failed. Please remove {self.data_path}, {self.install_dir}/test_genomes, {self.test_genomes_path} directories and try again.')
        self.write_version()

    def install_docker(self):
        if self.docker_type in ['singularity', 'apptainer']:
            sif = self.docker_image.replace("ncbi/pgap:", "pgap_") + ".sif"
            try:
                subprocess.run([self.docker_cmd, 'sif', 'list', sif],
                               check=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, stdin=subprocess.DEVNULL)
                print("Singularity sif files exists, not updating.")
                return
            except subprocess.CalledProcessError:
                pass
            docker_url = "docker://" + self.docker_image
        else:
            docker_url = self.docker_image
        print('Downloading (as needed) Docker image {}'.format(docker_url))
        r=None;
        try:
            r = subprocess.run([self.docker_cmd, 'pull', docker_url], check=True, stdin=subprocess.DEVNULL)
            #print(r)
        except subprocess.CalledProcessError:
            print(r)
            sys.exit(1)

    # This and install data should probably be refactored
    def check_install_data(self):
        if self.use_version > "2019-11-25.build4172":
            if self.args.ani:
                packages = ['ani', 'pgap']
            elif self.args.ani_only:
                packages = ['ani']
            else:
                packages = ['pgap']
            for package in packages:
                guard_file = f"{self.install_dir}/input-{self.use_version}/.{package}_complete"
                if not os.path.isfile(guard_file):
                    return False
        return True

    def install_data(self, threads):
        suffix = ""
        if self.branch != "":
            suffix = self.branch + "."

        if self.args.ani:
            packages = ['ani', 'pgap']
        elif self.args.ani_only:
            packages = ['ani']
        else:
            packages = ['pgap']
        for package in packages:
            guard_file = f"{self.install_dir}/input-{self.use_version}/.{package}_complete"
            if package == "pgap":
                remote_path = f"https://s3.amazonaws.com/pgap/input-{self.use_version}.{suffix}tgz"
            else:
                remote_path = f"https://s3.amazonaws.com/pgap/input-{self.use_version}.{suffix}{package}.tgz"
            if not os.path.isfile(guard_file):
                url_thread = mp.Process(target = install_url, name='{package} installation',args=(remote_path, self.install_dir, self.args.quiet, self.args.teamcity, guard_file, ))
                url_thread.start()
                threads.append(url_thread)
            else:
                print(f"Skipping already installed tarball: {remote_path}")
                
    def install_test_genomes(self):
        def get_suffix(branch):
            if branch == "":
                return ""
            return "."+self.branch

        guard_file = f"{self.test_genomes_path}/.complete"
        if not os.path.isfile(guard_file):
            quiet_remove("test_genomes")
            URL = 'https://s3.amazonaws.com/pgap-data/test_genomes-{}{}.tgz'.format(self.use_version,get_suffix(self.branch))
            print('Installing PGAP test genomes')
            print(self.test_genomes_path)
            print(URL)
            install_url(URL, self.install_dir, self.args.quiet, self.args.teamcity, guard_file = None)
            open(guard_file, 'a').close()

    def update_self(self):
        if self.args.teamcity:
            print("Not trying to update self, because the --teamcity flag is enabled.")
            # Never update self when running teamcity
            return

        if self.args.no_self_up:
            print("Not trying to update self, because the --no-self-update flag is enabled.")
            # Useful when locally editing and testing this file.
            return

        cur_file = sys.argv[0]
        if self.branch == "":
            #ver = self.use_version
            ver = "prod"
        else:
            ver = self.branch
        url = f"https://github.com/ncbi/pgap/raw/{ver}/scripts/pgap.py"
        request = Request(url)

        try:
            with urlopen(request, timeout=self.timeout) as response:
                new_pgap = response.read()
            with open(cur_file, "rb") as f:
                old_pgap = f.read()

            if new_pgap != old_pgap:
                print(f"Attempting to update <{cur_file}> ...", end='')
                with open(cur_file, "wb") as f:
                    f.write(new_pgap)
                print("updated successfully.")
                print("Please restart update.")
                sys.exit()
                
        except Exception as exc:
            print(exc)
            print(f"Failed to update {cur_file}, ignoring")
            print(f"Something has gone wrong, please manually download: {url}")
            sys.exit()

    def write_version(self):
        filename = self.install_dir + "/VERSION"
        with open(filename, 'w', encoding='utf-8') as f:
            f.write(u'{}\n'.format(self.use_version))


def remove_empty_files(rootdir):
    for f in os.listdir(rootdir):
        fullname = os.path.join(rootdir, f)
        if os.path.isfile(fullname) and os.path.getsize(fullname) == 0:
            quiet_remove(fullname)

def copy_genome_to_workspace(genome, original_workspace):
    os.makedirs(original_workspace, exist_ok=True)    

    # Check if the input file actually exists
    if not os.path.exists(genome):
        print(f"Error: The input genome file:{genome} does not exist.")
        sys.exit(1)  # Exit the script with an error code
    
    filename = os.path.basename(genome)
    new_genome_path = os.path.join(original_workspace, filename)
    
    # Check if the file with the same name already exists in the workspace
    if os.path.exists(new_genome_path):
        return filename
    
    try:
        # Attempt to copy the file
        shutil.copy2(genome, new_genome_path)
    except FileNotFoundError:
        print(f"Error: The genome file {genome} does not exist. Can't copy it to {new_genome_path}")
        sys.exit(1)  # Exit the script with an error code
    
    return filename

def create_simple_yaml_files(fasta_location, genus_species, output_dir):
    # Note: The args are not validated here, as they are validated when the generated YAML files are ingested in the pipeline.
    output_submol_yaml_filename=os.path.join(output_dir, 'submol.yaml')
    with open(output_submol_yaml_filename, 'w') as f:
        f.write(f'''\
organism:
    genus_species: "{genus_species}"
'''
        )
    output_input_yaml_filename=os.path.join(output_dir, 'input.yaml')
    with open(output_input_yaml_filename, 'w') as f:
        f.write(f'''\
fasta:
    class: File
    location: {fasta_location}
submol:
    class: File
    location: submol.yaml
'''
        )

    return os.path.abspath(output_input_yaml_filename)

def validate_prefix(prefix):

    """
    Validates the given prefix to ensure it can be used in a filename on Linux, macOS, and Windows.
    
    Exits the program with an error message if the prefix is not valid.
    
    Valid Prefix:
    - Contains only alphanumeric characters, underscores, or hyphens.
    e.g., "my_prefix", "prefix123", "123_prefix", "prefix-123"
    
    Invalid Prefix:
    - Contains any characters other than alphanumeric characters, underscores, or hyphens.
    e.g., "my prefix", "prefix#", "prefix@", "prefix!"
    
    Note: This function is compatible with Linux, macOS, and Windows filenames.
    """
    if not re.match(r"^[a-zA-Z0-9_\-]+$", prefix):
        sys.exit(f"The provided prefix '{prefix}' is invalid. A valid prefix should only contain alphanumeric characters, underscores, and hyphens.")
    return True

def apply_prefix_to_output_dir(output_dir, prefix):
    """
    Removes the default prefix "annot" and adds the given prefix to each file in the specified directory.

    Parameters:
    - output_dir (str): The path of the directory containing the files to rename.
    - prefix (str): The prefix to add to each file name.

    Returns:
    - None
    """
    if not os.path.exists(output_dir):
        print(f"The directory {output_dir} does not exist.")
        return

    for filename in os.listdir(output_dir):
        file_path = os.path.join(output_dir, filename)
        if os.path.isfile(file_path):
            # Remove existing 'annot' prefix if present
            new_filename = filename
            if filename.startswith("annot"):
                new_filename = filename[5:]

            # Add the new prefix
            new_file_path = os.path.join(output_dir, prefix + new_filename)
            
            # Rename the file
            os.rename(file_path, new_file_path)

def main():

    parser = argparse.ArgumentParser(description="Input must be provided as:\n"
                                                 " 1. a fasta/organism pair, e.g.\n"
                                                 "    pgap.py ... -g input.fasta -s 'Escherichia coli'\n"
                                                 "or\n"
                                                 " 2. a YAML configuration file, e.g.\n"
                                                 "    pgap.py ... input.yaml\n"
                                                 , formatter_class=argparse.RawTextHelpFormatter)

    parser.add_argument('-g', '--genome', type=str, help='Path to genomic fasta')

    parser.add_argument('-s', '--organism', type=str, help='Organism name: genus, genus species, or more specific and known to NCBI Taxonomy, see https://github.com/ncbi/pgap/wiki/Input-Files#taxonomy-information for more information')
    parser.add_argument('input', nargs='?', help=argparse.SUPPRESS)
                        

    parser.add_argument('-V', '--version', action='store_true',
                        help='Print currently set up PGAP version')
    parser.add_argument('-v', '--verbose', action='store_true',
                        help='Verbose mode')

    parser.add_argument('--dev',  action='store_true', help=argparse.SUPPRESS) # help="Set development mode")
    parser.add_argument('--test', action='store_true', help=argparse.SUPPRESS) # help="Set test mode")
    parser.add_argument('--prod', action='store_true', help=argparse.SUPPRESS) # help="Use a production candidate version. For internal testing."

    ani_group = parser.add_mutually_exclusive_group()
    ani_group.add_argument('--taxcheck', dest='ani',  action='store_true', help="Also calculate the Average Nucleotide Identity")
    ani_group.add_argument('--taxcheck-only', dest='ani_only', action='store_true', help="Only calculate the Average Nucleotide Identity, do not run PGAP")
    ani_group.add_argument('--asn1-input', dest='asn1_input', action='store_true', help=argparse.SUPPRESS) # help="For internal usage by PD group, ASN.1 input file, calling wf_common.cwl"
    
    parser.add_argument("--auto-correct-tax", 
                        dest='auto_correct_tax', 
                        action='store_true',
                        help='Use the ANI predicted organism instead of the user-provided organism; requires --taxcheck.')
    action_group = parser.add_mutually_exclusive_group()
    action_group.add_argument('-l', '--list', action='store_true', help='List available versions.')
    action_group.add_argument('-u', '--update', dest='update', action='store_true',
                              help='Update to the latest PGAP version, including reference data.')
    action_group.add_argument('--use-version', dest='use_version', help=argparse.SUPPRESS)

    report_group = parser.add_mutually_exclusive_group()
    report_group.add_argument('-r', '--report-usage-true', dest='report_usage_true', action='store_true',
                        help='Report anonymized usage metadata to NCBI.')
    report_group.add_argument('-n', '--report-usage-false', dest='report_usage_false', action='store_true',
                        help='Do not report anonymized usage metadata to NCBI.')
    parser.add_argument("--container-name", 
                        dest='container_name', 
                        help='Specify a container name that will be used instead of automatically generated.')
    parser.add_argument("--container-path", 
                        dest='container_path', 
                        help='Override path to image.')
    parser.add_argument("--ignore-all-errors", 
                        dest='ignore_all_errors', 
                        action='store_true',
                        help='Ignore errors from quality control analysis, in order to obtain a draft annotation.')
    parser.add_argument("--no-internet", 
                        dest='no_internet', 
                        action='store_true',
                        help='Disable internet access for all programs in pipeline.')
    parser.add_argument('-D', '--docker', metavar='path',
                        help='Docker-compatible executable (e.g. docker, podman, apptainer), which may include a full path like /usr/bin/docker')
    parser.add_argument('-o', '--output', metavar='path', default='output',
                        help='Output directory to be created, which may include a full path')
    parser.add_argument('-t', '--timeout', default='24:00:00', help=argparse.SUPPRESS)
                        #help='Set a maximum time for pipeline to run, format is D:H:M:S, H:M:S, or M:S, or S (default: %(default)s)')
    parser.add_argument('-q', '--quiet', action='store_true',
                        help='Quiet mode, for scripts')
    parser.add_argument('--prefix', type=str,
                        help='Set the prefix for output files (default: "annot")')
    parser.add_argument('--no-self-update', action='store_true',
                        dest='no_self_up',
                        help='Do not attempt to update this script')
    parser.add_argument('-c', '--cpus', type=int,
                        help='Limit the number of CPUs available for execution by the container')
    parser.add_argument('-m', '--memory',
                        help='Memory limit (Docker and PodMan only, ignored on Singularity); may add an optional suffix which can be one of b, k, m, or g')
    parser.add_argument('--teamcity', action='store_true', help=argparse.SUPPRESS)
    parser.add_argument('-d', '--debug', action='store_true',
                        help='Debug mode')
                        
    args = parser.parse_args()
    if args.input  or args.genome: # not installation
        outputdir = os.path.abspath(args.output)
        if os.path.exists(outputdir):
            sys.exit(f"Output directory {outputdir} exists, exiting.")
        # Create a work directory.
        print(f"Output will be placed in: {outputdir}")
        os.mkdir(outputdir)
    

    # Ensure that user provided prefix is valid.
    if args.prefix:
        validate_prefix(args.prefix) 

    if ( (args.input or args.genome) and (not args.report_usage_true) and (not args.report_usage_false) ):
        parser.error("One of -n/--report-usage-false or -r/--report-usage-true must be provided.")

    # Check for the different no_yaml_group arguments scenarios.
    if (args.genome and not args.organism) or (not args.genome and args.organism):
        parser.error(r"Invalid Command Line Argument Error: Both arguments -s\--organism and -g\--genome must be provided if no YAML file is provided.")
    elif not args.input and args.genome and args.organism:
        base_genome = copy_genome_to_workspace(args.genome, args.output)
        args.input = create_simple_yaml_files(base_genome, args.organism, args.output)
        # do we need this? I do not like it
        # args.genome = base_genome
        
    elif args.input and args.genome and args.organism:
        parser.error("Invalid Command Line Argument Error: A YAML file argument cannot be used "
            "in combination with either the -s/--organism or -g/--genome arguments. "
            "The -s/--organism and the -g/--genome arguments replace the YAML file argument input.")

    retcode = 0
    try:
        params = Setup(args)
        if args.input:
            if args.asn1_input:
                # this is special PD path
                # make sure that we cancel all other ways
                args.ani = args.ani_only = False
            if args.ani or args.ani_only:
                p = Pipeline(params, args.input, "taxcheck")
                retcode = p.launch()
                p.cleanup()

                # args.output for some reason not always available 
                time.sleep(1) 

                # analyze ani output here
                outputdir = args.output # this does not work
                outputdir = params.outputdir
                if not os.path.exists(outputdir):
                    print("INTERNAL(SYSTEM)PROBLEM: abort: output directory does not exist: {}".format(outputdir))
                    if  args.ignore_all_errors == False:
                        sys.exit(1)
                    else:
                        print("Ignoring")
                params.ani_output = os.path.join(outputdir, "ani-tax-report.xml")
                params.ani_hr_output = os.path.join(outputdir, "ani-tax-report.txt")
                if os.path.exists(params.ani_output) and os.path.getsize(params.ani_output) > 0:
                    True
                else:
                    params.ani_output = None 
                if os.path.exists(params.ani_hr_output) and os.path.getsize(params.ani_hr_output) > 0:
                    True
                else:
                    params.ani_hr_output = None 
                
                errors_xml_fn = os.path.join(outputdir, "errors.xml")
                # if there are errors
                # and we do not want to recover them when it is recoverable
                #  then bail
                if os.path.exists(errors_xml_fn) and os.path.getsize(errors_xml_fn) > 0 and not ( args.auto_correct_tax and  params.ani_output != None ) :
                    error_file = None
                    if params.ani_hr_output != None:
                        error_file = params.ani_hr_output
                    elif params.ani_output != None:
                        error_file = params.ani_output
                    else: 
                        error_file = errors_xml_fn
                    print("ERROR: taxcheck calls the genome misassigned or contaminated. See {}".format(error_file))
                    if  args.ignore_all_errors == False:
                        print("thus PGAP will not execute")
                        sys.exit(1)
                    else:
                        print("Ignoring")
                    
            if not args.ani_only and not args.asn1_input:
                p = Pipeline(params, args.input, "pgap")
                retcode = p.launch()
                p.cleanup()
                outputdir = p.params.outputdir 
            if args.asn1_input:
                p = Pipeline(params, args.input, "wf_common")
                retcode = p.launch()
                p.cleanup()
                outputdir = p.params.outputdir 
            if retcode == 0:
                for errors_xml_fn in glob.glob(os.path.join(p.params.outputdir, "errors.xml")):
                    if os.path.exists(errors_xml_fn):
                        os.remove(errors_xml_fn)
                #
                # although we had an intention of exporting input submol.yaml file
                # inside pgap.cwl, on the higher level we decided not to do that
                # see doubling down on it in previously exited def cleanup() method:
                # 
                list_to_delete = [args.input, 'input.yaml', 'pgap_input.yaml', 'submol.yaml']
                for file in list_to_delete:
                    if file != None:
                        base =  os.path.basename(file)
                        fullpath  = os.path.join(p.params.outputdir, base)
                        if os.path.exists(fullpath):
                            os.remove(fullpath)
            remove_empty_files(p.params.outputdir)

            if args.prefix:
                apply_prefix_to_output_dir(p.params.outputdir, args.prefix)

    except (Exception, KeyboardInterrupt) as exc:
        if args.debug:
            raise
        retcode = 1
        import traceback
        traceback.print_exc()

    sys.exit(retcode)
        
if __name__== "__main__":
    main()
