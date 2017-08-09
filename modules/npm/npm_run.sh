#!/bin/zsh

# Utility to quickly switch between difference NPM
# accounts using auth tokens.
# 
# This utility requires that you define environment
# variables based on the following rules:
#
# - `NPM_AUTH_TOKEN_<profile>`=<auth token>
#
# where profile is your desired profile name.
#
# This script will set `NPM_AUTH_TOKEN` with the
# resulting token. Make sure your `.npmrc` file
# is configured to read from it.

set -u
set -e

if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <profile> <command...>" 1>&2
  exit 1
fi

# Transform to uppercase
# See http://stackoverflow.com/a/11392235/1641422
ARGV_PROFILE=$(echo "$1" | tr '[:lower:]' '[:upper:]') 

TOKEN_ENVIRONMENT_VARIABLE="NPM_AUTH_TOKEN_$ARGV_PROFILE"

# We need to check the variable exists before attempting
# to blindly expand it afterwards to avoid shell errors
if ! set | grep --text "^$TOKEN_ENVIRONMENT_VARIABLE" >/dev/null; then
  echo "Unknown profile: $ARGV_PROFILE"
  exit 1
fi

echo "Loading profile $ARGV_PROFILE..."

# Dynamically expand variable
# See http://unix.stackexchange.com/a/251896/43448
export NPM_AUTH_TOKEN=$(print -rl -- ${(P)TOKEN_ENVIRONMENT_VARIABLE})

echo "Logged in as $(npm whoami)"
npm ${@:2}
