#!/bin/sh

set -o errexit
set -o nounset

if [ "$#" -ne 2 ]
then
  echo "Usage: $0 <file.aiff> <cover.jpg>" 1>&2
  exit 1
fi

AIFF="$1"
COVER="$2"

echo "Setting $COVER as the cover of $AIFF" 1>&2

# brew install kid3
# See https://apple.stackexchange.com/a/259841
kid3-cli -c "select \"$AIFF\"" -c "set picture:\"$COVER\" \"Picture Description\"" -c 'save'
