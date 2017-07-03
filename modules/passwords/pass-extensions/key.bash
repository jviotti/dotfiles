#!/bin/bash

source "$HOME/.std.sh"

ARGV_ACCOUNT="$1"

if stdsh_is_undefined "$ARGV_ACCOUNT"; then
  stdsh_fail "Please pass an account name"
fi

pass show "$ARGV_ACCOUNT" | stdsh_filter_get_first_line
