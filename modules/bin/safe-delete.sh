#!/bin/sh

set -e 
set -u

if [ $# -lt 1 ]; then
  echo "Usage: $0 <file...>" >&2
  exit 1
fi

ARGV_FILES="$*"
SHRED_ARGS="-xu"

if command -v shred 2>/dev/null 1>&2; then
  shred "$SHRED_ARGS" "$ARGV_FILES"
elif command -v gshred 2>/dev/null 1>&2; then
  gshred "$SHRED_ARGS" "$ARGV_FILES"
else 
  echo "You have to install shred" 1>&2
  exit 1
fi
