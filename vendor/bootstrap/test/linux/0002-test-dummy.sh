#!/bin/sh

set -o errexit
set -o nounset

touch "$OUTPUT/DUMMY"
echo "PASS $0" 1>&2
