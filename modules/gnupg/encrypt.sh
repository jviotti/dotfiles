#!/bin/sh

set -e
set -u
set -x

if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <file> <recipients...>"
  exit 1
fi

ARGV_FILE="$1"
ARGV_RECIPIENTS="${@:2}"

echo "$ARGV_FILE"

RECIPIENTS_OPTS=""
for recipient in $ARGV_RECIPIENTS; do
  RECIPIENTS_OPTS="$RECIPIENTS_OPTS --recipient $recipient"
done

gpg $RECIPIENTS_OPTS --encrypt "$ARGV_FILE"
