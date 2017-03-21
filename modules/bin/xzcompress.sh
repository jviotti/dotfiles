#!/bin/sh

# Compress a directory as `.tar.xz`

set -u
set -e

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <file>" 1>&2
  exit 1
fi

tar cvJf "$1.tar.xz" "$1"
