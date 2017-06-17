#!/bin/sh

set -e
set -u

DEFAULT_PASSWORD_SIZE=30

# See https://github.com/drduh/macOS-Security-and-Privacy-Guide#passwords

if command -v openssl 2>/dev/null 1>&2; then
  openssl rand -base64 "$DEFAULT_PASSWORD_SIZE"
elif command -v gpg 2>/dev/null 1>&2; then
  gpg --gen-random -a 0 "$DEFAULT_PASSWORD_SIZE"
elif command -v base64 2>/dev/null 1>&2; then
  dd if=/dev/urandom bs=1 count="$DEFAULT_PASSWORD_SIZE" 2>/dev/null | base64
else
  echo "Can't generate as password. Install openssl, gpg, or base64" 1>&2
  exit 1
fi
