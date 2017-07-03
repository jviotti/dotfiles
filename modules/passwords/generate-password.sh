#!/bin/sh

source "$HOME/.std.sh"

DEFAULT_PASSWORD_SIZE=30

# See https://github.com/drduh/macOS-Security-and-Privacy-Guide#passwords

if stdsh_has_command "openssl"; then
  openssl rand -base64 "$DEFAULT_PASSWORD_SIZE"
elif stdsh_has_command "gpg"; then
  gpg --gen-random -a 0 "$DEFAULT_PASSWORD_SIZE"
elif stdsh_has_command "base64"; then
  dd if=/dev/urandom bs=1 count="$DEFAULT_PASSWORD_SIZE" 2>/dev/null | base64
else
  stdsh_fail "Can't generate as password. Install openssl, gpg, or base64"
fi
