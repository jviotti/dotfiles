#!/bin/sh

set -e

DRIVE=$1

OS=`uname`
if [[ "$OS" != "Darwin" ]]; then
  echo "This script is only meant to be run in OS X" 1>&2
  exit 1
fi

if [ -z $DRIVE ]; then
  echo "Usage: $0 <drive>" 1>&2
  exit 1
fi

diskutil eraseVolume FAT32 UNTITLED $DRIVE
