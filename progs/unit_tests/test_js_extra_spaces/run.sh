#!/bin/bash

set -euxo pipefail
cwltool --validate test.cwl;
rm -rf tmp*

# cwltool \
    # --debug --js-console \
    # '--timestamps' \
    # '--disable-color' \
    # '--preserve-entire-environment' \
    # '--outdir'  'output' \
    # '--tmpdir-prefix'  'tmpdir/' \
    # '--leave-tmpdir' \
    # '--tmp-outdir-prefix'  'tmp-outdir/' \
    # '--copy-outputs'    \
     # --default-container ncbi/pgap-dev:2020-11-24.build2776 \
    # test.cwl \
    # input.yaml
    
docker run -i \
    --volume=/panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/dev/automated_builds/workspaces/teamcity/PgapUtilsDockerBuild/dev/1438/input-2020-11-25.build2777/uniColl_path/:/panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/dev/automated_builds/workspaces/teamcity/PgapUtilsDockerBuild/dev/1438/input-2020-11-25.build2777/uniColl_path/:ro \
    --volume=/home/badrazat/gpipe/github/repos/pgap-dev:/mypgap:rw \
    -w /mypgap/progs/unit_tests/test_js_extra_spaces \
    --user $(id -u):$(id -g) \
    ncbi/pgap-dev:2020-11-24.build2776 \
    cwltool \
        --debug --js-console \
        '--timestamps' \
        '--disable-color' \
        '--preserve-entire-environment' \
        '--outdir'  'output' \
        '--tmpdir-prefix'  'tmpdir/' \
        '--leave-tmpdir' \
        '--tmp-outdir-prefix'  'tmp-outdir/' \
        '--copy-outputs'    \
        test.cwl \
        input.yaml
    
    
