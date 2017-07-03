#!/bin/sh

source "$HOME/.std.sh"

if [ "$#" -lt 2 ]; then
  stdsh_fail "Usage: $0 <file> <recipients...>"
fi

ARGV_FILE="$1"
ARGV_RECIPIENTS="${@:2}"

echo "$ARGV_FILE"

RECIPIENTS_OPTS=""
for recipient in $ARGV_RECIPIENTS; do
  RECIPIENTS_OPTS="$RECIPIENTS_OPTS --recipient $recipient"
done

gpg $RECIPIENTS_OPTS --encrypt "$ARGV_FILE"
