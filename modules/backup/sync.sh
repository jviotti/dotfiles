#!/bin/bash

set -e
COMMAND="$1"
ENCRYPT_KEY="$GPGKEY_ENCRYPT"
SIGN_KEY="$GPGKEY_SIGN"
set -u

function usage() {
  echo "Usage: $0 <command> <options>" >&2
  echo "" >&2
  echo "Options" >&2
  echo "" >&2
  echo "    -l <local directory>" >&2
  exit 1
}

if [ -z "$COMMAND" ]
then
  usage
fi

ARGV_LOCAL_DIRECTORY=""

shift

while getopts ":l:" option; do
  case $option in
    l) ARGV_LOCAL_DIRECTORY=$OPTARG ;;
    *) usage ;;
  esac
done

if [ -z "$ARGV_LOCAL_DIRECTORY" ]
then
  usage
fi

REMOTE_NAMESPACE="dpbx:///Cloud"
REMOTE_DIRECTORY="$REMOTE_NAMESPACE/$(basename "$ARGV_LOCAL_DIRECTORY")"

# Otherwise duplicity fails on macOS with:
# Max open files of 256 is too low, should be >= 1024.
# Use 'ulimit -n 1024' or higher to correct.
if [ "$(uname)" = "Darwin" ]; then
  ulimit -n 1024
fi

echo "Cleaning $REMOTE_DIRECTORY"

duplicity \
  cleanup \
  --progress \
  --use-agent \
  --encrypt-key "$ENCRYPT_KEY" \
  --sign-key "$SIGN_KEY" \
  --force \
  "$REMOTE_DIRECTORY"

if [ "$COMMAND" = "push" ]; then
  echo "$ARGV_LOCAL_DIRECTORY -> $REMOTE_DIRECTORY"
  duplicity \
    --progress \
    --use-agent \
    --full-if-older-than 1M \
    --allow-source-mismatch \
    --encrypt-key "$ENCRYPT_KEY" \
    --sign-key "$SIGN_KEY" \
    "$ARGV_LOCAL_DIRECTORY" \
    "$REMOTE_DIRECTORY"
  duplicity \
    remove-all-but-n-full 2 \
    --use-agent \
    --encrypt-key "$ENCRYPT_KEY" \
    --sign-key "$SIGN_KEY" \
    "$REMOTE_DIRECTORY"
elif [ "$COMMAND" = "pull" ]; then
  echo "$REMOTE_DIRECTORY -> $ARGV_LOCAL_DIRECTORY"
  mkdir -p "$ARGV_LOCAL_DIRECTORY"
  duplicity \
    --force \
    --progress \
    --use-agent \
    --sign-key "$SIGN_KEY" \
    "$REMOTE_DIRECTORY" \
    "$ARGV_LOCAL_DIRECTORY"
elif [ "$COMMAND" = "check" ]; then
  echo "$REMOTE_DIRECTORY = $ARGV_LOCAL_DIRECTORY"
  duplicity \
    verify \
    --compare-data \
    --progress \
    --use-agent \
    --sign-key "$SIGN_KEY" \
    "$REMOTE_DIRECTORY" \
    "$ARGV_LOCAL_DIRECTORY"
else
  usage
fi
