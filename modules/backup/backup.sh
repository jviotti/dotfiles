#!/bin/sh

COMMAND="$1"
GPGKEY="$DGPG_KEY"

set -e
set -u

CLOUD_PATH_LOCAL="$HOME/Cloud"

# Make sure this exists!
CLOUD_PATH_REMOTE="dpbx:///Cloud"

. "$HOME/.std.sh"

if ! stdsh_has_command "duplicity"; then
  stdsh_fail "You must install duplicity to run this tool"
fi

if [ -z "$GPGKEY" ]; then
  stdsh_fail "DGPG_KEY is not set"
fi

if [ -z "$COMMAND" ]; then
  echo "Usage: $0 [COMMAND]"
  echo ""
  echo "Commands:"
  echo ""
  echo "  incremental  sync cloud directory with remote (incremental)"
  echo "  full         sync cloud directory with remote (full)"
  echo "  verify       verify current data against remote"
  echo "  restore      restore latest backup"
  echo "  ls           list contents of remote cloud directory"
  exit 1
fi

if [ "$COMMAND" = "incremental" ]; then
  duplicity \
    --progress \
    --use-agent \
    --allow-source-mismatch \
    --encrypt-sign-key "$GPGKEY" \
    incremental \
    "$CLOUD_PATH_LOCAL" \
    "$CLOUD_PATH_REMOTE"
elif [ "$COMMAND" = "full" ]; then
  duplicity \
    --progress \
    --use-agent \
    --allow-source-mismatch \
    --encrypt-sign-key "$GPGKEY" \
    full \
    "$CLOUD_PATH_LOCAL" \
    "$CLOUD_PATH_REMOTE"
elif [ "$COMMAND" = "verify" ]; then
  duplicity \
    verify \
    --use-agent \
    --compare-data \
    "$CLOUD_PATH_REMOTE" \
    "$CLOUD_PATH_LOCAL"
elif [ "$COMMAND" = "restore" ]; then
  duplicity \
    --progress \
    --force \
    --use-agent \
    restore \
    "$CLOUD_PATH_REMOTE" \
    "$CLOUD_PATH_LOCAL"
elif [ "$COMMAND" = "ls" ]; then
  duplicity list-current-files "$CLOUD_PATH_REMOTE"
else
  stdsh_fail "Unknown command: $COMMAND"
fi
