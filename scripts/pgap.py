#!/usr/bin/env python3
from __future__ import print_function
import sys
min_python = (3,5)
try:
    assert(sys.version_info >= min_python)
except:
    from platform import python_version
    print("Python version", python_version(), "is too old.")
    print("Please use Python", ".".join(map(str,min_python)), "or later.")
    sys.exit()

import argparse
import atexit
import glob
import json
import os
import platform
import queue
import re
import shutil
import subprocess
import tarfile
import threading
import time
import tempfile
import contextlib

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

    def read(self, n=131072):
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

def install_url(url, path, quiet, teamcity):
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

def quiet_remove(filename):
    with contextlib.suppress(FileNotFoundError):
        os.remove(filename)

def find_failed_step(filename):
    r = "^\[(?P<time>[^\]]+)\] (?P<level>[^ ]+) \[(?P<source>[^ ]*) (?P<name>[^\]]*)\] (?P<status>.*)"
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

        
class Pipeline:

    def __init__(self, params, local_input, pipeline):
        self.params = params
        self.cwlfile = f"{pipeline}.cwl"
        self.pipename = pipeline.upper()
        
        self.data_dir = os.path.abspath(self.params.data_path)
        self.input_dir = os.path.dirname(os.path.abspath(local_input))
        self.input_file = '/pgap/user_input/pgap_input.yaml'

        self.yaml = self.create_inputfile(local_input)
        
        if (self.params.docker_type == 'singularity'):
            self.make_singularity_cmd()
        elif (self.params.docker_type == 'podman'):
            self.make_podman_cmd()
        else:
            self.make_docker_cmd()
        
        self.cmd.extend(['cwltool',
                        '--timestamps',
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
        if self.params.docker_user_remap:
            self.cmd.extend(['--user', str(os.getuid()) + ":" + str(os.getgid())])
        self.cmd.extend([
            '--volume', '{}:/pgap/input:ro,z'.format(self.data_dir),
            '--volume', '{}:/pgap/user_input:z'.format(self.input_dir),
            '--volume', '{}:{}:ro,z'.format(self.yaml, self.input_file ),
            '--volume', '{}:/pgap/output:rw,z'.format(self.params.outputdir)])

        if (self.params.args.cpus):
            if (platform.system() != "Windows"):
                self.cmd.extend(['--cpus', self.params.args.cpus])
            else:
                self.cmd.extend(['--cpu-count', self.params.args.cpus])
        if (self.params.args.memory):
            self.cmd.extend(['--memory', self.params.args.memory])
            
        # Debug mount for docker image
        if self.params.args.debug:
            log_dir = self.params.outputdir + '/debug/log'
            os.makedirs(log_dir)
            self.cmd.extend(['--volume', '{}:/log/srv:z'.format(log_dir)])
        self.cmd.append(self.params.docker_image)


    def make_podman_cmd(self):
        self.cmd = [self.params.docker_cmd, 'run', '-i', '--rm' ]

        self.cmd.extend([
            '--volume', '{}:/pgap/input:ro'.format(self.data_dir),
            '--volume', '{}:/pgap/user_input'.format(self.input_dir),
            '--volume', '{}:{}:ro'.format(self.yaml, self.input_file ),
            '--volume', '{}:/pgap/output:rw'.format(self.params.outputdir)])

        if (self.params.args.cpus):
            if (platform.system() != "Windows"):
                self.cmd.extend(['--cpus', self.params.args.cpus])
            else:
                self.cmd.extend(['--cpu-count', self.params.args.cpus])
        if (self.params.args.memory):
            self.cmd.extend(['--memory', self.params.args.memory])
            
        # Debug mount for docker image
        if self.params.args.debug:
            log_dir = self.params.outputdir + '/debug/log'
            os.makedirs(log_dir)
            self.cmd.extend(['--volume', '{}:/log/srv'.format(log_dir)])
        self.cmd.append(self.params.docker_image)

    def make_singularity_cmd(self):
        self.cmd = [self.params.docker_cmd, 'exec' ]
        
        self.cmd.extend([
            '--bind', '{}:/pgap/input:ro'.format(self.data_dir),
            '--bind', '{}:/pgap/user_input'.format(self.input_dir),
            '--bind', '{}:{}:ro'.format(self.yaml, self.input_file ),
            '--bind', '{}:/pgap/output:rw'.format(self.params.outputdir)])

        # Debug mount for docker image
        if self.params.args.debug:
            log_dir = self.params.outputdir + '/debug/log'
            os.makedirs(log_dir)
            self.cmd.extend(['--bind', '{}:/log/srv'.format(log_dir)])
        self.cmd.extend(["--pwd", "/pgap", "docker://" + self.params.docker_image])

        
    def create_inputfile(self, local_input):
        with tempfile.NamedTemporaryFile(mode='w',
                                         suffix=".yaml",
                                         prefix="pgap_input_",
                                         dir=self.input_dir,
                                         delete=False) as fOut:
            yaml = fOut.name
            with open(local_input, 'r') as fIn:
                for line in fIn:
                    if line: # skip empty lines
                        fOut.write(line.rstrip())
                        fOut.write(u'\n')
            fOut.write(u'supplemental_data: { class: Directory, location: /pgap/input }\n')
            if (self.params.report_usage != 'none'):
                fOut.write(u'report_usage: {}\n'.format(self.params.report_usage))
            if (self.params.ignore_all_errors == 'true'):
                fOut.write(u'ignore_all_errors: {}\n'.format(self.params.ignore_all_errors))
            if (self.params.no_internet == 'true'):
                fOut.write(u'no_internet: {}\n'.format(self.params.no_internet))
            fOut.flush()
        return yaml
        
    def record_runtime(self, f):
        def check_runtime_setting(settings, value, min):
            if settings[value] != 'unlimited' and settings[value] < min:
                print('WARNING: {} is less than the recommended value of {}'.format(value, min))

        if (self.params.docker_type == 'singularity'):
            cmd = [self.params.docker_cmd, 'exec', '--bind', '{}:/cwd:ro'.format(os.getcwd()), "docker://"+self.params.docker_image,
                   'bash', '-c', 'df -k /cwd /tmp ; ulimit -a ; cat /proc/{meminfo,cpuinfo}']
        else:
            cmd = [self.params.docker_cmd, 'run', '-i', '-v', '{}:/cwd'.format(os.getcwd()), self.params.docker_image,
                   'bash', '-c', 'df -k /cwd /tmp ; ulimit -a ; cat /proc/{meminfo,cpuinfo}']

        result = subprocess.run(cmd, check=True, stdout=subprocess.PIPE)
        if result.returncode != 0:
            return
        output = result.stdout.decode('utf-8')
        settings = {'Docker image':self.params.docker_image}
        for match in re.finditer(r'^(open files|max user processes|virtual memory) .* (\S+)\n', output, re.MULTILINE):
            value = match.group(2)
            if value != "unlimited":
                value = int(value)
            settings[match.group(1)] = value
        match = re.search(r'^Filesystem.*\n\S+ +\d+ +\d+ +(\d+) +\S+ +/\S*\n\S+ +\d+ +\d+ +(\d+) +\S+ +/\S*\n', output, re.MULTILINE)
        settings['work disk space (GiB)'] = round(int(match.group(1))/1024/1024, 1)
        settings['tmp disk space (GiB)'] = round(int(match.group(2))/1024/1024, 1)
        match = re.search(r'^MemTotal:\s+(\d+) kB', output, re.MULTILINE)
        settings['memory (GiB)'] = round(int(match.group(1))/1024/1024, 1)
        cpus = 0
        for match in re.finditer(r'^model name\s+:\s+(.*)\n', output, re.MULTILINE):
            cpus += 1
            settings['cpu model'] = match.group(1)
        settings['CPU cores'] = cpus
        settings['memory per CPU core (GiB)'] = round(settings['memory (GiB)']/cpus, 1)
        check_runtime_setting(settings, 'open files', 8000)
        check_runtime_setting(settings, 'max user processes', 100)
        check_runtime_setting(settings, 'work disk space (GiB)', 80)
        check_runtime_setting(settings, 'tmp disk space (GiB)', 10)
        check_runtime_setting(settings, 'memory (GiB)', 8)
        check_runtime_setting(settings, 'memory per CPU core (GiB)', 2)
        filename = self.params.outputdir + "/debug/RUNTIME.json"
        #with open(filename, 'w', encoding='utf-8') as f:
            #f.write(u'{}\n'.format(settings))
        f.write(json.dumps(settings, sort_keys=True, indent=4))
        
        
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
            # Show runtime parameters in the log
            f.write("--- Start Runtime Report ---\n")            
            self.record_runtime(f)
            f.write("\n--- End Runtime Report ---\n\n")            
            f.flush()
            try:
                proc = subprocess.Popen(self.cmd, stdout=f, stderr=subprocess.STDOUT)
                proc.wait()
            finally:
                if proc.returncode == None:
                    print('\nAbnormal termination, stopping all processes.')
                    proc.terminate()
                elif proc.returncode == 0:
                    print(f'{self.pipename} completed successfully.')
                else:
                    print(f'{self.pipename} failed, docker exited with rc =', proc.returncode)
                    find_failed_step(cwllog)
        return proc.returncode

class Setup:

    def __init__(self, args):
        self.args = args
        self.branch          = self.get_branch()
        self.repo            = self.get_repo()
        self.rundir          = self.get_dir()
        self.local_version   = self.get_local_version()
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
        self.docker_image = "ncbi/{}:{}".format(self.repo, self.use_version)
        self.data_path = '{}/input-{}'.format(self.rundir, self.use_version)
        self.test_genomes_path = '{}/test_genomes-{}'.format(self.rundir, self.use_version)
        self.outputdir = self.get_output_dir()
        #self.docker_cmd, self.docker_user_remap = self.get_docker_info()
        self.get_docker_info()
        if self.local_version != self.use_version:
            self.update()

        # Create a work directory.
        if args.input:
            print("Output will be placed in:", self.outputdir)
            os.mkdir(self.outputdir)
        

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

    def get_dir(self):
        if self.branch == "":
            return "."
        return "./"+self.branch

    def get_local_version(self):
        filename = self.rundir + "/VERSION"
        if os.path.isfile(filename):
            with open(filename, encoding='utf-8') as f:
                return f.read().strip()
        return None


    def get_remote_versions(self):
        versions = []
        if (self.get_branch()):
            #print("Checking docker hub for latest version.")
            url = 'https://registry.hub.docker.com/v1/repositories/ncbi/{}/tags'.format(self.repo)
            response = urlopen(url)
            json_resp = json.loads(response.read().decode())
            for i in reversed(json_resp):
                versions.append(i['name'])
        else:
            #print("Checking github releases for latest version.")
            response = urlopen('https://api.github.com/repos/ncbi/pgap/releases/latest')
            latest = json.loads(response.read().decode())['tag_name']
            versions.append(latest)
        return versions

    def check_status(self):
        if self.local_version == None:
            print("The latest version of PGAP is {}, you have nothing installed locally.".format(self.get_latest_version()))
            return
        if self.local_version == self.get_latest_version():
            if self.branch == "":
                print("PGAP version {} is up to date.".format(self.local_version))
            else:
                print("PGAP from {} branch, version {} is up to date.".format(self.branch, self.local_version))
            return
        print("The latest version of PGAP is {}, you are using version {}, please update.".format(self.get_latest_version(), self.local_version))

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
        def numbers( dirs ):
            for dirname in dirs:
                name, ext = os.path.splitext(dirname)
                yield int(ext[1:])
        if not os.path.exists(self.args.output):
            return os.path.abspath(self.args.output)
        alldirs = glob.glob(self.args.output + ".*")
        if not alldirs:
            return os.path.abspath(self.args.output + ".1")
        count = max( numbers( alldirs ) )
        count += 1
        outputdir = "{}.{}".format(self.args.output, str(count))
        return os.path.abspath(outputdir)
        
    def get_docker_info(self):
        self.docker_cmd = shutil.which(self.args.docker)
        if self.docker_cmd == None:
            sys.exit("Docker not found.")
        result = subprocess.run([self.docker_cmd, '--version'], check=True, stdout=subprocess.PIPE)
        docker_alternative = result.stdout.decode('utf-8').split(maxsplit=1)[0]
        if docker_alternative == 'Docker':
            self.docker_user_remap = platform.system() != "Windows"
            self.docker_type = 'docker'
        elif docker_alternative == 'podman':
            self.docker_user_remap = False
            self.docker_type = 'podman'
        elif docker_alternative == 'singularity':
            self.docker_user_remap = False
            self.docker_type = 'singularity'
        else:
            self.docker_user_remap = False
            self.docker_type = 'docker'
            print('WARNING: {} support as Docker alternative has not been tested'.format(docker_alternative))
        #return (docker_cmd, docker_user_remap)

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
        self.update_self()
        self.install_docker()
        self.install_data()
        self.install_test_genomes()
        self.write_version()

    def install_docker(self):
        print('Downloading (as needed) Docker image {}'.format(self.docker_image))
        try:
            r = subprocess.run([self.docker_cmd, 'pull', self.docker_image], check=True)
            #print(r)
        except CalledProcessError:
            print(r)


    def install_data(self):
        suffix = ""
        if self.branch != "":
            suffix = self.branch + "."

        if self.use_version > "2019-11-25.build4172":
            
            for package in ['all', 'ani', 'pgap']:
                guard_file = f"{self.rundir}/input-{self.use_version}/.{package}_complete"
                remote_path = 'https://s3.amazonaws.com/pgap/input-{}.{}{}.tgz'.format(self.use_version, suffix, package)
                if not os.path.isfile(guard_file):
                    install_url(remote_path, self.rundir, self.args.quiet, self.args.teamcity)
                    open(guard_file, 'a').close()
                else:
                    print(f"Skipping already installed tarball: {remote_path}")
        else:
            if not os.path.exists(self.data_path):
                quiet_remove("input")
                print('Installing PGAP reference data version {}'.format(self.use_version))
                remote_path = 'https://s3.amazonaws.com/pgap/input-{}.{}tgz'.format(self.use_version, suffix)
                install_url(remote_path, self.rundir, self.args.quiet, self.args.teamcity)
                
    def install_test_genomes(self):
        def get_suffix(branch):
            if branch == "":
                return ""
            return "."+self.branch

        if not os.path.exists(self.test_genomes_path):
            quiet_remove("test_genomes")
            URL = 'https://s3.amazonaws.com/pgap-data/test_genomes-{}{}.tgz'.format(self.use_version,get_suffix(self.branch))
            print('Installing PGAP test genomes')
            print(self.test_genomes_path)
            print(URL)
            install_url(URL, self.rundir, self.args.quiet, self.args.teamcity)

    def update_self(self):
        if self.args.teamcity:
            print("Not trying to update self, because the --teamcity flag is enabled.")
            # Never update self when running teamcity
            # Also useful when locally editing and testing this file.
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
        filename = self.rundir + "/VERSION"
        with open(filename, 'w', encoding='utf-8') as f:
            f.write(u'{}\n'.format(self.use_version))


        
def main():
    parser = argparse.ArgumentParser(description='Run PGAP.')
    parser.add_argument('input', nargs='?',
                        help='Input YAML file to process.')
    parser.add_argument('-V', '--version', action='store_true',
                        help='Print currently set up PGAP version')
    parser.add_argument('-v', '--verbose', action='store_true',
                        help='Verbose mode')

    version_group = parser.add_mutually_exclusive_group()
    version_group.add_argument('--dev',  action='store_true', help=argparse.SUPPRESS) # help="Set development mode")
    version_group.add_argument('--test', action='store_true', help=argparse.SUPPRESS) # help="Set test mode")
    version_group.add_argument('--prod', action='store_true', help="Use a production candidate version. For internal testing.")

    ani_group = parser.add_mutually_exclusive_group()
    ani_group.add_argument('--tax-check',  action='store_true', help="Also calculate the Average Nucleotide Identity")
    ani_group.add_argument('--tax-check-only', action='store_true', help="Only calculate the Average Nucleotide Identity, do not run PGAP")
    action_group = parser.add_mutually_exclusive_group()
    action_group.add_argument('-l', '--list', action='store_true', help='List available versions.')
    action_group.add_argument('-u', '--update', dest='update', action='store_true',
                              help='Update to the latest PGAP version, including reference data.')
    action_group.add_argument('--use-version', dest='use_version', help=argparse.SUPPRESS)

    report_group = parser.add_mutually_exclusive_group()
    report_group.add_argument('-r', '--report-usage-true', dest='report_usage_true', action='store_true',
                        help='Set the report_usage flag in the YAML to true.')
    report_group.add_argument('-n', '--report-usage-false', dest='report_usage_false', action='store_true',
                        help='Set the report_usage flag in the YAML to false.')

    parser.add_argument("--ignore-all-errors", 
                        dest='ignore_all_errors', 
                        action='store_true',
                        help='Ignore errors from quality control analysis, in order to obtain a draft annotation.')
    parser.add_argument("--no-internet", 
                        dest='no_internet', 
                        action='store_true',
                        help=argparse.SUPPRESS)
    parser.add_argument('-D', '--docker', metavar='path', default='docker',
                        help='Docker-compatible executable (e.g. docker, podman, singularity), which may include a full path like /usr/bin/docker')
    parser.add_argument('-o', '--output', metavar='path', default='output',
                        help='Output directory to be created, which may include a full path')
    parser.add_argument('-t', '--timeout', default='24:00:00', help=argparse.SUPPRESS)
                        #help='Set a maximum time for pipeline to run, format is D:H:M:S, H:M:S, or M:S, or S (default: %(default)s)')
    parser.add_argument('-q', '--quiet', action='store_true',
                        help='Quiet mode, for scripts')
    parser.add_argument('-c', '--cpus',
                        help='Limit the number of CPUs available for execution by the container')
    parser.add_argument('-m', '--memory',
                        help='Memory limit; may add an optional suffix which can be one of b, k, m, or g')
    parser.add_argument('--teamcity', action='store_true', help=argparse.SUPPRESS)
    parser.add_argument('-d', '--debug', action='store_true',
                        help='Debug mode')
    args = parser.parse_args()

    retcode = 0
    try:
        params = Setup(args)
        if args.input:
            if args.ani or args.ani_only:
                p = Pipeline(params, args.input, "ani")
                retcode = p.launch()
            if not args.ani_only:
                p = Pipeline(params, args.input, "pgap")
                retcode = p.launch()
    except (Exception, KeyboardInterrupt) as exc:
        if args.debug:
            raise
        retcode = 1
        print(exc)

    sys.exit(retcode)
        
if __name__== "__main__":
    main()
