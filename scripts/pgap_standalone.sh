#!/bin/bash
set -euo pipefail

case "${1:---help}" in
-u|--update)
    shift

    # Use curl (preferred) or wget as fallback.
    if which curl 2>/dev/null
    then
        fetch-stdout() {
            curl -Ls "$1"
        }
        fetch-file() {
            echo "- Fetching $1: $2"
            curl -LC - "$2" -O
        }
    elif which wget 2>/dev/null
    then
        fetch-stdout() {
            wget -O - "$1"
        }
        fetch-file() {
            echo "- Fetching $1: $2"
            wget -c "$2"
        }
    else
        echo >&2 "ERROR: Cannot find 'curl' or 'wget' in PATH."
        exit 1
    fi

    VERSION=`fetch-stdout https://api.github.com/repos/ncbi/pgap/releases/latest | sed -n 's/^.*"tag_name": "\([^"]*\)".*/\1/p'`
    if test `cat VERSION 2>/dev/null` = "$VERSION"
    then
        echo "The NCBI Prokaryotic Genome Annotation Pipeline (PGAP) version $VERSION is up to date."
    else
        echo "Updating the NCBI Prokaryotic Genome Annotation Pipeline (PGAP) to version $VERSION..."
        echo "- Fetching Docker image"
        docker pull ncbi/pgap:"$VERSION"
        fetch-file "reference data" https://s3.amazonaws.com/pgap-data/input-"$VERSION".tgz
        fetch-file "test genomes" https://s3.amazonaws.com/pgap-data/test_genomes.tgz
        echo "- Extracting reference data and test genomes"
        tar xzvf input-"$VERSION".tgz
        tar xzvf test_genomes.tgz
        echo "- Done."
        echo "$VERSION" > VERSION
    fi
    ;;

-h|--help)
    echo "NCBI Prokaryotic Genome Annotation Pipeline (PGAP)"
    echo "Usage: $0 <input-YAML>"
    exit ;;

-*)
    echo "Invalid option $1; try: $0 --help"
    exit 1 ;;
esac

if test "$#" -ne 1
then
    echo "Require exactly one input YAML file; try: $0 --help"
    exit 1
fi

# Run PGAP.
VERSION=`<VERSION`
image="ncbi/pgap:$VERSION"
inDir=`cd $(dirname $1) && pwd -P`
inFile=`basename $1`

# Create the input file
cat $1 <(docker run -i "$image" cat /pgap/input.yaml) > $inDir/pgap_input.yaml

# Ensure needed files are setup
mkdir -p $inDir/input
mkdir -p output
ln -s /pgap/input_template $inDir/input_template

# Run the actual workflow
docker run -i \
       --volume $inDir:/pgap/user_input:ro \
       --volume $(pwd -P)/input-$VERSION:/pgap/user_input/input:ro \
       --volume $(pwd -P)/output:/pgap/output:rw \
       "$image" \
       cwltool \
       --outdir ./outdir \
       wf_pgap_simple.cwl \
       user_input/pgap_input.yaml

# Cleanup
rmdir $inDir/input
rm $inDir/input_template
