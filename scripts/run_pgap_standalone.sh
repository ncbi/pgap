#!/usr/bin/bash
set -euxo pipefail
if [ "$#" -ne 1 ]; then
    echo "Usage: ${0} <input yaml>"
    exit
fi

VERSION=`cat VERSION`
image="ncbi/pgap:${VERSION}"
inDir=`cd $(dirname $1) && pwd -P`
inFile=`basename $1`


# Create the input file
cat $1 <(docker run -i ${image} cat /pgap/input.yaml) > $inDir/pgap_input.yaml

# Ensure needed files are setup
mkdir -p $inDir/input
mkdir -p output
ln -s /pgap/input_template $inDir/input_template

# Run the actual workflow
docker run -i \
       --volume $inDir:/pgap/user_input:ro \
       --volume $(pwd -P)/input-${VERSION}:/pgap/user_input/input:ro \
       --volume $(pwd -P)/output:/pgap/output:rw \
       ncbi/pgap:2018-11-07.build3190 \
       cwltool \
       --outdir ./output \
       wf_pgap_simple.cwl \
       user_input/pgap_input.yaml

# Cleanup
rmdir $inDir/input
rm $inDir/input_template
