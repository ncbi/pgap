#!/bin/bash
set -uexo pipefail

imageid=$1

sed -i "s|dockerPull: .*$|dockerPull: ${imageid}|g" wf_*.cwl
