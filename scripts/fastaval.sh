#!/bin/bash
#
#   temporary wrapper around 'fastaval' until fastaval will allow -ignore_all_errors
#
set -euxo pipefail
POSITIONAL=()
while [[ $# -gt 0 ]]; do
    key="$1"
    ignore_all_errors=false
    case "$key" in
        -ignore_all_errors)
        ignore_all_errors=true
        ;;
        *)    # unknown option
        POSITIONAL+=("$key") # save it in an array for later
        ;;
    esac
    shift # past argument
done
set -- "${POSITIONAL[@]}" # restore positional parameters    
set +e
fastaval "$@"    
result="$?"
set -e

if $ignore_all_errors; then
    exit 0;
else 
    exit "$result";
fi

