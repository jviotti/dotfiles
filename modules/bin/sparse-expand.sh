#!/bin/sh

# Expand an sparse file

set -u
set -e

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <file>" 1>&2
  exit 1
fi

dd if=$1 of=$1 conv=notrunc bs=1M
