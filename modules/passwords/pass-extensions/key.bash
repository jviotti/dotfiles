#!/bin/bash

ARGV_ACCOUNT="$1"

set -e
set -u

if [ -z "$ARGV_ACCOUNT" ]; then
  echo "Please pass an account name" 1>&2
  exit 1
fi

pass show "$ARGV_ACCOUNT" | head -n 1
