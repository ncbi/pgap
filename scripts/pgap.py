#!/usr/bin/env python

from __future__ import print_function
from io import open
import argparse, atexit, json, os, re, shutil, subprocess, sys, tarfile, platform

try:
    from urllib.parse import urlparse, urlencode
    from urllib.request import urlopen, urlretrieve, Request
    from urllib.error import HTTPError
except ImportError:
    from urlparse import urlparse
    from urllib import urlretrieve, urlencode
    from urllib2 import urlopen, Request, HTTPError

verbose = False
docker = 'docker'

def is_venv():
    return (hasattr(sys, 'real_prefix') or
            (hasattr(sys, 'base_prefix') and sys.base_prefix != sys.prefix))

def install(packages):
    try:
        from pip._internal import main
    except ImportError:
        from pip import main
    main(['install'] + packages)

def get_docker_image(version):
    return 'ncbi/pgap:{}'.format(version)

def check_runtime_setting(settings, value, min):
    if settings[value] != 'unlimited' and settings[value] < min:
        print('WARNING: {} is less than the recommended value of {}'.format(value, min))

def check_runtime(version):
    image = get_docker_image(version)
    output = subprocess.check_output(
        [docker, 'run', '-i',
            '-v', '{}:/cwd'.format(os.getcwd()), image,
            'bash', '-c', 'df -k /cwd /tmp ; ulimit -a ; cat /proc/{meminfo,cpuinfo}'])
    output = output.decode('utf-8')
    settings = {'Docker image':image}
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
    if verbose: print('Note: Essential runtime settings = {}'.format(settings))

def check_cwl_runner():
    try:
        subprocess.check_call(['cwl-runner', '--version'])
        return
    except PermissionError:
        try:
            import cwltool
        except ImportError:
            if not is_venv():
                print('ERROR: cwltool is not installed, and you are not currently using a Python virtualenv, as is recommended.')
                exit(1)
            install(['cwltool[deps]', 'PyYAML', 'cwlref-runner'])
            subprocess.check_call(['cwl-runner', '--version'])
            return
    print('ERROR: Failed to run cwl-runner.')
    exit(1)

def install_docker(version):
    print('Downloading (as needed) PGAP Docker image version {}'.format(version))
    subprocess.check_call([docker, 'pull', get_docker_image(version)])


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

def install_url(url):
    #with urlopen(url) as response:
    #with urlopen_progress(url) as response:
    response = urlopen_progress(url)
    with tarfile.open(mode='r|*', fileobj=response) as tar:
        tar.extractall()
#            while True:
#                item = tar.next()
#                if not item: break
#                print('- {}'.format(item.name))
#                tar.extract(item, set_attrs=False)

def install_cwl(version):
    if not os.path.exists('pgap-{}'.format(version)):
        print('Downloading PGAP Common Workflow Language (CWL) version {}'.format(version))
        install_url('https://github.com/ncbi/pgap/archive/{}.tar.gz'.format(version))

def install_data(version):
    if not os.path.exists('input-{}'.format(version)):
        print('Downloading PGAP reference data version {}'.format(version))
        install_url('https://s3.amazonaws.com/pgap-data/input-{}.tgz'.format(version))

def install_test_genomes(version):
    if not os.path.exists('test_genomes'):
        print('Downloading PGAP test genomes')
        install_url('https://s3.amazonaws.com/pgap-data/test_genomes.tgz')

def get_remote_version():
    # Old system, where we checked github releases
    #response = urlopen('https://api.github.com/repos/ncbi/pgap/releases/latest')
    #latest = json.load(response)['tag_name']

    # Check docker hub
    response = urlopen('https://registry.hub.docker.com/v1/repositories/ncbi/pgap/tags')
    json_response = json.loads(response.read().decode())
    return json_response[-1]['name']

def get_version():
    if os.path.isfile('VERSION'):
        with open('VERSION', encoding='utf-8') as f:
            return f.read().strip()
    return None

def setup(update, local_runner):
    '''Determine version of PGAP.'''
    version = get_version()
    if update or not version:
        latest = get_remote_version()
        if version != latest:
            print('Updating PGAP to version {} (previous version was {})'.format(latest, version))
            if local_runner: install_cwl(latest)
            install_docker(latest)
            install_data(latest)
            install_test_genomes(version)
        with open('VERSION', 'w', encoding='utf-8') as f:
            f.write(u'{}\n'.format(latest))
        version = latest
    if not version:
        raise RuntimeError('Failed to identify PGAP version')
    return version

def run(version, input, output, debug, report):
    image = get_docker_image(version)

    # Create a work directory.
    os.mkdir(output)
    os.mkdir(output + '/log')

    # Run the actual workflow.
    data_dir = os.path.abspath('input-{}'.format(version))
    input_dir = os.path.dirname(os.path.abspath(input))
    input_file = '/pgap/user_input/pgap_input.yaml'

    with open(output +'/pgap_input.yaml', 'w') as f:
        with open(input) as i:
            shutil.copyfileobj(i, f)
        f.write(u'\n')
        f.write(u'supplemental_data: { class: Directory, location: /pgap/input }\n')
        if (report != 'none'):
            f.write(u'report_usage: {}\n'.format(report))
        f.flush()

    output_dir = os.path.abspath(output)
    yaml = output_dir + '/pgap_input.yaml'
    log_dir = output_dir + '/log'
    # cwltool --timestamps --default-container ncbi/pgap-utils:2018-12-31.build3344
    # --tmpdir-prefix ./tmpdir/ --leave-tmpdir --tmp-outdir-prefix ./tmp-outdir/
    #--copy-outputs --outdir ./outdir pgap.cwl pgap_input.yaml 2>&1 | tee cwltool.log

    cmd = [docker, 'run', '-i' ]
    if (platform.system() != "Windows"):
        cmd.extend(['--user', str(os.getuid()) + ":" + str(os.getgid())])
    cmd.extend(['--volume', '{}:/pgap/input:ro'.format(data_dir),
                '--volume', '{}:/pgap/user_input'.format(input_dir),
                '--volume', '{}:/pgap/user_input/pgap_input.yaml:ro'.format(yaml),
                '--volume', '{}:/pgap/output:rw'.format(output_dir),
                '--volume', '{}:/log/srv'.format(log_dir),
                image,
                'cwltool',
                '--outdir', '/pgap/output'])
    if debug:
        cmd.extend(['--tmpdir-prefix', '/pgap/output/tmpdir/',
                    '--leave-tmpdir',
                    '--tmp-outdir-prefix', '/pgap/output/tmp-outdir/',
                    '--copy-outputs'])
    cmd.extend(['pgap.cwl', input_file])
    subprocess.check_call(cmd)

def main():
    parser = argparse.ArgumentParser(description='Run PGAP.')
    parser.add_argument('input', nargs='?',
                        help='Input YAML file to process.')
    parser.add_argument('--version', action='store_true',
                        help='Print currently set up PGAP version')
    parser.add_argument('-v', '--verbose', action='store_true',
                        help='Verbose mode')
    parser.add_argument('-u', '--update', dest='update', action='store_true',
                        help='Update to the latest PGAP version, including reference data')
    parser.add_argument('-l', '--local-runner', dest='local_runner', action='store_true',
                        help='Use a local CWL runner instead of the bundled cwltool')
    parser.add_argument('-r', '--report-usage-true', dest='report_usage_true', action='store_true',
                        help='Set the report_usage flag in the YAML to true.')
    parser.add_argument('-n', '--report-usage-false', dest='report_usage_false', action='store_true',
                        help='Set the report_usage flag in the YAML to false.')
    parser.add_argument('-d', '--docker', metavar='path', default='docker',
                        help='Docker executable, which may include a full path like /usr/bin/docker')
    parser.add_argument('-o', '--output', metavar='path', default='output',
                        help='Output directory to be created, which may include a full path')
    parser.add_argument('-t', '--test-genome', dest='test_genome', action='store_true',
                        help='Run a test genome')
    parser.add_argument('-D', '--debug', action='store_true',
                        help='Debug mode')
    args = parser.parse_args()
    verbose = args.verbose
    docker = args.docker
    debug = args.debug

    if (args.version):
        version = get_version()
        if version:
            print('PGAP version {}'.format())
        else:
            print('PGAP not installed; use --update to install the latest version.')
            exit(0)

    version = setup(args.update, args.local_runner)
    #check_runtime(version)
    #if args.local_runner:
    #    check_cwl_runner()

    if args.test_genome:
        input = 'test_genomes/MG37/input.yaml'
    else:
        input = args.input

    report='none'
    if (args.report_usage_true):
        report = 'true'
    if (args.report_usage_false):
        report = 'false'
        
    if input:
        run(version, input, args.output, debug, report)

if __name__== "__main__":
    main()
