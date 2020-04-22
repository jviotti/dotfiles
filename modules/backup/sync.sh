#!/bin/bash

set -e
COMMAND="$1"
ARGV_LOCAL_DIRECTORY="$2"
ENCRYPT_KEY="$GPGKEY_ENCRYPT"
SIGN_KEY="$GPGKEY_SIGN"

if [ -z "$DPBX_ACCESS_TOKEN" ]; then
  echo "Please set DPBX_ACCESS_TOKEN" >&2
  exit 1
fi
set -u

function usage() {
  echo "Usage: $0 <command> <directory>" >&2
  exit 1
}

if [ -z "$COMMAND" ] || [ -z "$ARGV_LOCAL_DIRECTORY" ]
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
  --encrypt-key "0xBC5EB4A7A76C6BD3!" \
  --encrypt-key "0x3325A768B99243CA!" \
  --encrypt-key "0x37505437EA6B4630!" \
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
    --encrypt-key "0xBC5EB4A7A76C6BD3!" \
    --encrypt-key "0x3325A768B99243CA!" \
    --encrypt-key "0x37505437EA6B4630!" \
    --sign-key "$SIGN_KEY" \
    "$ARGV_LOCAL_DIRECTORY" \
    "$REMOTE_DIRECTORY"
  echo "Attempting to remove old full backups"
  duplicity \
    remove-all-but-n-full 2 \
    --force \
    --use-agent \
    --encrypt-key "0xBC5EB4A7A76C6BD3!" \
    --encrypt-key "0x3325A768B99243CA!" \
    --encrypt-key "0x37505437EA6B4630!" \
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
