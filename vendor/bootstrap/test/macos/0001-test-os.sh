#!/bin/sh

set -o errexit
set -o nounset

UNAME="$(uname)"
test "$UNAME" = "Darwin" || \
  (echo "This script should not run for $UNAME" 1>&2 && exit 1)
touch "$OUTPUT/OS-TEST-PASSED"
echo "PASS $0" 1>&2
