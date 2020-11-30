#!/bin/bash

set -euxo pipefail
cwltool --validate test.cwl;

cwltool \
    '--timestamps' \
    '--disable-color' \
    '--preserve-entire-environment' \
    '--outdir'  'output' \
    '--tmpdir-prefix'  'tmpdir/' \
    '--leave-tmpdir' \
    '--tmp-outdir-prefix'  'tmp-outdir/' \
    '--copy-outputs'    \
     --default-container ncbi/pgap-dev:2020-11-24.build2776 \
    test.cwl \
    input.yaml
    
