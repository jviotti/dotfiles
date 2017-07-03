#!/bin/sh

source "$HOME/.std.sh"

if [ $# -lt 1 ]; then
  stdsh_fail "Usage: $0 <file...>"
fi

ARGV_FILES="$*"
SHRED_ARGS="-xu"

if stdsh_has_command "shred"; then
  shred "$SHRED_ARGS" "$ARGV_FILES"
elif stdsh_has_command "gshred"; then
  gshred "$SHRED_ARGS" "$ARGV_FILES"
else 
  stdsh_fail "You have to install shred"
fi
