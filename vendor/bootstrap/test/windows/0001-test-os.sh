#!/bin/sh

set -o errexit
set -o nounset

UNAME="$(uname -o)"

if [ "$UNAME" != "Msys" ] && [ "$UNAME" != "Cygwin" ]
then
  echo "This script should not run for $UNAME" 1>&2 
  exit 1
fi

touch "$OUTPUT/OS-TEST-PASSED"
echo "PASS $0" 1>&2
