#!/bin/bash
set -euo pipefail

VERSION=`grep dockerPull wf_pgap.cwl | cut -d: -f3`
wget -qO- https://s3.amazonaws.com/pgap-data/$VERSION.tgz | tar xvz
