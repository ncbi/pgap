#!/usr/bin/bash
set -euo pipefail

curl --silent "https://api.github.com/repos/ncbi/pgap/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")' > VERSION
VERSION=`cat VERSION`

wget https://github.com/ncbi/pgap/raw/master/scripts/run_pgap_standalone.sh

wget -nc https://s3.amazonaws.com/pgap-data/input-${VERSION}.tgz
echo -n "Unpacking test_genomes..."
tar xzf input-${VERSION}.tgz
echo "done!"

wget -nc https://s3.amazonaws.com/pgap-data/test_genomes.tgz
echo -n "Unpacking test_genomes..."
tar xzf test_genomes.tgz
echo "done!"

docker pull ncbi/pgap:${VERSION}
