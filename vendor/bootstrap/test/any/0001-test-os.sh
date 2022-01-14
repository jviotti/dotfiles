#!/bin/sh

set -o errexit
set -o nounset

touch "$OUTPUT/ANY"
echo "PASS $0" 1>&2
