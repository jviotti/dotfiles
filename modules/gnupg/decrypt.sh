#!/bin/sh

source "$HOME/.std.sh"

if [ "$#" -lt 1 ]; then
  stdsh_fail "Usage: $0 <gpg file>"
fi

if stdsh_has_command "gpg2"; then
  gpg2 -dq "$1"
else 
  gpg -d "$1"
fi

