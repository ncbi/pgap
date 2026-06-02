#!/bin/bash
set -euo pipefail

VERSION=`grep dockerPull wf_pgap.cwl | cut -d: -f3`
wget -qO- https://ncbi-pgap.s3.amazonaws.com/input_data/input-${VERSION}.tgz | tar xvz
