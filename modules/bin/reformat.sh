#!/bin/sh

source "$HOME/.std.sh"

DRIVE=$1

OS=`uname`
if [[ "$OS" != "Darwin" ]]; then
  stdsh_fail "This script is only meant to be run in OS X"
fi

if stdsh_is_undefined "$DRIVE"; then
  stdsh_fail "Usage: $0 <drive>"
fi

diskutil eraseVolume FAT32 UNTITLED "$DRIVE"
