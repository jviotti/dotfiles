#!/bin/sh

set -e 
set -u

if [ $# -lt 1 ]; then
  echo "Usage: $0 <email>" >&2
  exit 1
fi

ARGV_EMAIL="$1"

gpg --output "$ARGV_EMAIL.pub.asc" --armor --export "$ARGV_EMAIL" 
gpg --output "$ARGV_EMAIL.key.asc" --export-secret-key --armor "$ARGV_EMAIL"
