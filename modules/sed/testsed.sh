#!/bin/bash

ARGV_SCRIPT=$1 
ARGV_FILE=$2 

set -u
set -e

if [ -z "$ARGV_SCRIPT" ] || [ -z "$ARGV_FILE" ]; then
  echo "Usage: $0 <script> <file>"
  exit 1
fi

TEMPORARY_RESULTS=$(mktemp)

function cleanup {
  rm "$TEMPORARY_RESULTS"
}

trap "cleanup" ERR
trap "cleanup" EXIT

sed -f "$ARGV_SCRIPT" "$ARGV_FILE" > "$TEMPORARY_RESULTS"
colordiff "$ARGV_FILE" "$TEMPORARY_RESULTS"
