#!/bin/sh

# Compress a directory as `.tar.xz`

source "$HOME/.std.sh"

if [ "$#" -ne 1 ]; then
  stdsh_fail "Usage: $0 <file>"
fi

tar cvf - "$1" | xz -9e -c - > "$1.tar.xz"
