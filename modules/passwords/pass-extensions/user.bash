#!/bin/bash

source "$HOME/.std.sh"

ARGV_ACCOUNT="$1"

if stdsh_is_undefined "$ARGV_ACCOUNT"; then
  stdsh_fail "Please pass an account name" 1>&2
fi

function get_value() {
  cut -f 3- -d ' '
}

CONTENT="$(pass show "$ARGV_ACCOUNT")"

# grep exits with code 1 if no match
USERNAME="$(echo "$CONTENT" | grep '^username' || true)"
EMAIL="$(echo "$CONTENT" | grep '^email' || true)"

if stdsh_is_undefined "$USERNAME"; then
  echo "$EMAIL" | get_value
else
  echo "$USERNAME" | get_value
fi
