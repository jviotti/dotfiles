#!/bin/sh

source "$HOME/.std.sh"

if [ $# -lt 1 ]; then
  stdsh_fail "Usage: $0 <email>"
fi

ARGV_EMAIL="$1"

gpg --output "$ARGV_EMAIL.pub.asc" --armor --export "$ARGV_EMAIL" 
gpg --output "$ARGV_EMAIL.key.asc" --export-secret-key --armor "$ARGV_EMAIL"
