#!/bin/bash

ARGV_ACCOUNT="$1"

set -e
set -u

if [ -z "$ARGV_ACCOUNT" ]; then
  echo "Please pass an account name" 1>&2
  exit 1
fi

function get_value() {
  cut -f 3- -d ' '
}

CONTENT="$(pass show "$ARGV_ACCOUNT")"

# grep exits with code 1 if no match
USERNAME="$(echo "$CONTENT" | grep '^username' || true)"
EMAIL="$(echo "$CONTENT" | grep '^email' || true)"

if [ -z "$USERNAME" ]; then
  echo "$EMAIL" | get_value
else
  echo "$USERNAME" | get_value
fi
