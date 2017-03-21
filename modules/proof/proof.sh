#!/bin/bash

set -u

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ARGV_FILES="$*"

if [ -z "$ARGV_FILES" ]; then
  echo "Usage: $(basename $0) <file> ..."
  exit 1
fi

echo "============="
echo "Weasel words:"
echo "============="

echo ""
"$HERE/check-weasels.sh" $ARGV_FILES
echo ""

echo "=============="
echo "Passive voice:"
echo "=============="

echo ""
"$HERE/check-passive-voice.sh" $ARGV_FILES
echo ""

echo "==========="
echo "Duplicates:"
echo "==========="

echo ""
"$HERE/check-duplicated.pl" $ARGV_FILES
