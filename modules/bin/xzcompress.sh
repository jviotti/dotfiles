#!/bin/sh

# Compress a directory as `.tar.xz`

source "$HOME/.std.sh"

if [ "$#" -ne 1 ]; then
  stdsh_fail "Usage: $0 <file>"
fi

tar cvJf "$1.tar.xz" "$1"
