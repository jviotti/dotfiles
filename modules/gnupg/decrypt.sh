#!/bin/sh

set -e
set -u

if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <gpg file>"
  exit 1
fi

if command -v gpg2 2>/dev/null 1>&2; then
  gpg2 -dq "$1"
else 
  gpg -d "$1"
fi

