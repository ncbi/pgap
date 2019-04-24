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
import re
import shutil
import subprocess
import tarfile
import threading
import time

from io import open
from urllib.parse import urlparse, urlencode
from urllib.request import urlopen, urlretrieve, Request
from urllib.error import HTTPError

def is_venv():
    return (hasattr(sys, 'real_prefix') or
            (hasattr(sys, 'base_prefix') and sys.base_prefix != sys.prefix))

# def get_docker_image(version):
#     return 'ncbi/pgap:{}'.format(version)



class urlopen_progress:
    def __init__(self, url):
        self.remote_file = urlopen(url)
        total_size = 0
        try:
            total_size = self.remote_file.info().getheader('Content-Length').strip() # urllib2 method
        except AttributeError:
            total_size = self.remote_file.getheader('Content-Length', 0) # More modern method

        self.total_size = int(total_size)
        if self.total_size > 0:
            self.header = True
        else:
            self.header = False # a response doesn't always include the "Content-Length" header

        self.bytes_so_far = 0

    def read(self, n=10240):
        buffer = self.remote_file.read(n)
        if not buffer:
            sys.stdout.write('\n')
            return ''

        self.bytes_so_far += len(buffer)
        if self.header:
            percent = float(self.bytes_so_far) / self.total_size
            percent = round(percent*100, 2)
            sys.stderr.write("Downloaded %d of %d bytes (%0.2f%%)\r" % (self.bytes_so_far, self.total_size, percent))
        else:
            sys.stderr.write("Downloaded %d bytes\r" % (self.bytes_so_far))
        return buffer

def install_url(url, path):
    #with urlopen(url) as response:
    #with urlopen_progress(url) as response:
    response = urlopen_progress(url)
    with tarfile.open(mode='r|*', fileobj=response) as tar:
        tar.extractall(path=path)
#            while True:
#                item = tar.next()
#                if not item: break
#                print('- {}'.format(item.name))
#                tar.extract(item, set_attrs=False)


class Pipeline:

    def __init__(self, params, local_input, debug):
        self.params = params
        
        # Create a work directory.
        os.mkdir(self.params.outputdir)
        os.mkdir(self.params.outputdir + '/log')

        data_dir = os.path.abspath(self.params.data_path)
        input_dir = os.path.dirname(os.path.abspath(local_input))
        input_file = '/pgap/user_input/pgap_input.yaml'

        yaml = self.create_inputfile(local_input)
        
        output_dir = os.path.abspath(self.params.outputdir)

        log_dir = output_dir + '/log'
        # cwltool --timestamps --default-container ncbi/pgap-utils:2018-12-31.build3344
        # --tmpdir-prefix ./tmpdir/ --leave-tmpdir --tmp-outdir-prefix ./tmp-outdir/
        #--copy-outputs --outdir ./outdir pgap.cwl pgap_input.yaml 2>&1 | tee cwltool.log

        self.cmd = [params.dockercmd, 'run', '-i' ]
        if (platform.system() != "Windows"):
            self.cmd.extend(['--user', str(os.getuid()) + ":" + str(os.getgid())])
        self.cmd.extend([
            '--volume', '{}:/pgap/input:ro'.format(data_dir),
            '--volume', '{}:/pgap/user_input'.format(input_dir),
            '--volume', '{}:/pgap/user_input/pgap_input.yaml:ro'.format(yaml),
            '--volume', '{}:/pgap/output:rw'.format(output_dir),
            '--volume', '{}:/log/srv'.format(log_dir),
            self.params.docker_image,
            'cwltool',
            '--outdir', '/pgap/output'])
        if debug:
            self.cmd.extend([
                '--tmpdir-prefix', '/pgap/output/tmpdir/',
                '--leave-tmpdir',
                '--tmp-outdir-prefix', '/pgap/output/tmp-outdir/',
                '--copy-outputs'])
            self.record_runtime()

        self.cmd.extend(['pgap.cwl', input_file])

    def create_inputfile(self, local_input):        
        yaml = self.params.outputdir + '/pgap_input.yaml'
        with open(yaml, 'w') as f:
            with open(local_input) as i:
                shutil.copyfileobj(i, f)
                f.write(u'\n')
            f.write(u'supplemental_data: { class: Directory, location: /pgap/input }\n')
            if (self.params.report_usage != 'none'):
                f.write(u'report_usage: {}\n'.format(self.params.report_usage))
            f.flush()
        return yaml
        
    def record_runtime(self):
        def check_runtime_setting(settings, value, min):
            if settings[value] != 'unlimited' and settings[value] < min:
                print('WARNING: {} is less than the recommended value of {}'.format(value, min))

        cmd = [self.params.dockercmd, 'run', '-i', '-v', '{}:/cwd'.format(os.getcwd()), self.params.docker_image,
                'bash', '-c', 'df -k /cwd /tmp ; ulimit -a ; cat /proc/{meminfo,cpuinfo}']
        # output = subprocess.check_output(cmd)
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
        filename = self.params.outputdir + "/RUNTIME.json"
        with open(filename, 'w', encoding='utf-8') as f:
            #f.write(u'{}\n'.format(settings))
            f.write(json.dumps(settings, sort_keys=True, indent=4))
        
        
    def launch(self):
        def output_reader(proc):
            for line in iter(proc.stdout.readline, b''):
                print('got line: {0}'.format(line.decode('utf-8')), end='')

        # Run the actual workflow.
        #subprocess.run(self.cmd)
        proc = subprocess.Popen(self.cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        t = threading.Thread(target=output_reader, args=(proc,))
        t.start()

        try:
            time.sleep(self.params.timeout)
        finally:
            proc.terminate()
            try:
                proc.wait(timeout=0.2)
                print('== subprocess exited with rc =', proc.returncode)
            except subprocess.TimeoutExpired:
                print('subprocess did not terminate in time')
        t.join()

class Setup:

    def __init__(self, args):
        self.args = args
        self.branch          = self.get_branch()
        self.repo            = self.get_repo()
        self.rundir          = self.get_dir()
        self.local_version   = self.get_local_version()
        self.remote_versions = self.get_remote_versions()
        self.report_usage    = self.get_report_usage()
        self.timeout         = self.get_timeout()
        self.check_status()
        if (args.list):
            self.list_remote_versions()
            return
        self.use_version = self.get_use_version()
        self.docker_image = "ncbi/{}:{}".format(self.repo, self.use_version)
        self.data_path = '{}/input-{}'.format(self.rundir, self.use_version)
        self.outputdir = self.get_output_dir()
        self.dockercmd = self.get_docker_cmd()
        if self.local_version != self.use_version:
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
        # Old system, where we checked github releases
        #response = urlopen('https://api.github.com/repos/ncbi/pgap/releases/latest')
        #latest = json.load(response)['tag_name']

        # Check docker hub
        url = 'https://registry.hub.docker.com/v1/repositories/ncbi/{}/tags'.format(self.repo)
        response = urlopen(url)
        json_resp = json.loads(response.read().decode())
        versions = []
        for i in reversed(json_resp):
            versions.append(i['name'])
        return versions

    def check_status(self):
        if self.local_version == None:
            print("The latest version of PGAP is {}, you have nothing installed locally.".format(self.get_latest_version()))
            return
        if self.local_version == self.get_latest_version():
            print("PGAP {} is up to date.".format(self.local_version))
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
            return self.args.output
        alldirs = glob.glob(self.args.output + ".*")
        if not alldirs:
            return self.args.output + ".1" 
        count = max( numbers( alldirs ) )
        count += 1
        outputdir = "{}.{}".format(self.args.output, str(count))
        return os.path.abspath(outputdir)
        
    def get_docker_cmd(self):
        return shutil.which(self.args.docker)

    def get_report_usage(self):
        if (self.args.report_usage_true):
            return 'true'
        if (self.args.report_usage_false):
            return 'false'
        return 'none'

    def get_timeout(self):
        def str2sec(s):
            return sum(x * int(t) for x, t in
                    zip(
                        [1, 60, 3600, 86400],
                        reversed(s.split(":"))
                        ))
        return str2sec(self.args.timeout)

    def update(self):
        self.install_docker()
        self.install_data()
        self.install_test_genomes()
        self.write_version()

    def install_docker(self):
        print('Downloading (as needed) Docker image {}'.format(self.docker_image))
        subprocess.check_call([self.dockercmd, 'pull', self.docker_image])

    def install_data(self):
        if not os.path.exists(self.data_path):
            print('Downloading PGAP reference data version {}'.format(self.use_version))
            suffix = ""
            if self.branch != "":
                suffix = self.branch + "."
            remote_path = 'https://s3.amazonaws.com/pgap/input-{}.{}tgz'.format(self.use_version, suffix)
            install_url(remote_path, self.rundir)

    def install_test_genomes(self):
        def get_suffix(branch):
            if branch == "":
                return ""
            return "."+self.branch

        local_path = "{}/test_genomes".format(self.rundir)
        if not os.path.exists(local_path):
            print('Downloading PGAP test genomes')
            install_url('https://s3.amazonaws.com/pgap-data/test_genomes{}.tgz'.format(get_suffix(self.branch)), self.rundir)

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
    version_group.add_argument('--dev',  action='store_true', help="Set development mode")
    version_group.add_argument('--test', action='store_true', help="Set test mode")
    version_group.add_argument('--prod', action='store_true', help="Set production mode")

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

    parser.add_argument('-D', '--docker', metavar='path', default='docker',
                        help='Docker executable, which may include a full path like /usr/bin/docker')
    parser.add_argument('-o', '--output', metavar='path', default='output',
                        help='Output directory to be created, which may include a full path')
    parser.add_argument('-T', '--test-genome', dest='test_genome', action='store_true',
                        help='Run a test genome')
    parser.add_argument('-t', '--timeout', default='24:00:00',
                        help='Set a maximum time for pipeline to run, format is D:H:M:S, H:M:S, or M:S, or S (default: %(default)s)')
    parser.add_argument('-d', '--debug', action='store_true',
                        help='Debug mode')
    args = parser.parse_args()

    params = Setup(args)

    if args.test_genome:
        input_file = params.rundir + '/test_genomes/MG37/input.yaml'
    else:
        input_file = args.input


    if input_file:
        p = Pipeline(params, input_file, args.debug)
        p.launch()
        
if __name__== "__main__":
    main()
