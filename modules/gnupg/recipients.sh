#!/bin/sh

source "$HOME/.std.sh"

if [ "$#" -lt 1 ]; then
  stdsh_fail "Usage: $0 <gpg file>"
fi

if stdsh_has_command "gpg2"; then
  COMMAND="gpg2"
else
  COMMAND="gpg"
fi

"$COMMAND" --list-only --verbose --decrypt "$1"
