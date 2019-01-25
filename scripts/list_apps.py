#!/usr/bin/env python3
# cwltool --print-rdf wf_pgap_simple2.cwl | grep baseCommand | cut -d'"' -f2 | sort -u

import subprocess
import argparse

arg_overrides = {
    "sqlite3": "-version",
    "cat": "--help",
    "split": "--help",
    "xsltproc": "--version"
}

def check_binaries(binaries):
    for b in binaries:
        test_cmd = [b, "-help"]
        if b in arg_overrides:
            test_cmd = [b, arg_overrides[b]]
        if b[-3:] == ".py":
            # We should try to compile it
            # docker run ncbi/gpdev:2018-11-28.prod.build629 /bin/bash -c "python -m py_compile `whereis -b yaml2json.py | cut -d: -f2`"
            # cmd = ["docker", "run", "ncbi/gpdev:2018-11-28.prod.build629", "python", "-m", "py_compile", b]
            test_str = "python -m py_compile `whereis -b {} | cut -d: -f2`".format(b)
            test_cmd = ["/bin/bash", "-c", test_str]
        
        cmd = []
        cmd.extend(docker_prefix)
        cmd.extend(test_cmd)
        robj = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True)
        r = robj.returncode
        if r != 0:
            print(robj.stderr)
            print(robj.stdout)
        else:
            print(r, " ".join(test_cmd))

def main():
    parser = argparse.ArgumentParser(description='Test each PGAP binary to see if they can be executed simply.')
    parser.add_argument('--workflow', '-w', dest='workflow', default='wf_pgap_simple.cwl',
                        help='Workflow to garner app list from. (default: %(default)s)')
    parser.add_argument('--check', '-c', help='If set, check if programs are executable')
    parser.add_argument('--docker', '-d', dest='docker',
                        help='If check flag set, execute programs in a container based on this image (default: no container)')

    args = parser.parse_args()

    docker_prefix = []
    if args.docker:
        docker_prefix = ["docker", "run", args.docker]
        # where args.docker is image name like "ncbi/gpdev:2018-11-28.prod.build629"        

    workflow = args.workflow
    getcmdstr = "cwltool --print-rdf {} | grep baseCommand | cut -d'\"' -f2 | sort -u".format(workflow)
    robj = subprocess.run(getcmdstr, shell=True, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True)
    binaries = robj.stdout.split()
    print(binaries)
    if (args.check):
        check_binaries(binaries)


if __name__ == "__main__":
    main()
