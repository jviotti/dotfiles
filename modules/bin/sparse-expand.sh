#!/bin/sh

# Expand an sparse file

source "$HOME/.std.sh"

if [ "$#" -ne 1 ]; then
  stdsh_fail "Usage: $0 <file>"
fi

dd if=$1 of=$1 conv=notrunc bs=1M
