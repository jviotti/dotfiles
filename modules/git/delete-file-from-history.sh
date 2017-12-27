#!/bin/sh

FILE="$1"

set -e
set -u

if [ -z "$FILE" ]; then
  echo "Usage: $0 [FILE]" 1>&2
  exit 1
fi

# See https://stackoverflow.com/a/2158271/1641422
git filter-branch -f --prune-empty --index-filter \
  "git rm --cached -f --ignore-unmatch $FILE" \
  --tag-name-filter cat -- --all
