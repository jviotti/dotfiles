#!/bin/sh

COMMAND="$1"
shift
RESOURCES="$*"
GPGKEY="$DGPG_KEY"

set -e
set -u

# Otherwise duplicity fails on macOS
if [ "$(uname)" = "Darwin" ]; then
  ulimit -n 1024
fi

. "$HOME/.std.sh"

stdsh_expect_command "duplicity"

if [ -z "$GPGKEY" ]; then
  stdsh_fail "DGPG_KEY is not set"
fi

# Default directories
if [ "$RESOURCES" == "all" ]; then
  RESOURCES="Audios Backups Docs Library Pass Pictures Videos"
fi

if [ -z "$COMMAND" ] || [ -z "$RESOURCES" ]; then
  echo "Usage: $0 <command> <resource...>"
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

for RESOURCE in $RESOURCES; do

  RESOURCE_PATH_LOCAL="$HOME/SpiderOak Hive/$RESOURCE"

  # Make sure this exists!
  RESOURCE_PATH_REMOTE="dpbx:///Cloud/$RESOURCE"

  echo "========================================"
  echo "Processing: $RESOURCE"
  echo "Command: $COMMAND"
  echo "Local Path: $RESOURCE_PATH_LOCAL"
  echo "Remote Path: $RESOURCE_PATH_REMOTE"
  echo "========================================"

  if [ "$COMMAND" = "incremental" ]; then
    stdsh_expect_directory "$RESOURCE_PATH_LOCAL"

    duplicity \
      --progress \
      --use-agent \
      --allow-source-mismatch \
      --encrypt-sign-key "$GPGKEY" \
      incremental \
      "$RESOURCE_PATH_LOCAL" \
      "$RESOURCE_PATH_REMOTE"
  elif [ "$COMMAND" = "full" ]; then
    stdsh_expect_directory "$RESOURCE_PATH_LOCAL"

    duplicity \
      --progress \
      --use-agent \
      --allow-source-mismatch \
      --encrypt-sign-key "$GPGKEY" \
      full \
      "$RESOURCE_PATH_LOCAL" \
      "$RESOURCE_PATH_REMOTE"
  elif [ "$COMMAND" = "verify" ]; then
    stdsh_expect_directory "$RESOURCE_PATH_LOCAL"

    # We could use `--compare-data` to make laser focused
    # verification, however it obviously needs to check
    # all the data, which means the whole remote needs to
    # be downloaded
    duplicity \
      verify \
      --use-agent \
      "$RESOURCE_PATH_REMOTE" \
      "$RESOURCE_PATH_LOCAL"
  elif [ "$COMMAND" = "restore" ]; then
    stdsh_ensure_directory "$RESOURCE_PATH_LOCAL"

    duplicity \
      --progress \
      --force \
      --use-agent \
      restore \
      "$RESOURCE_PATH_LOCAL" \
      "$RESOURCE_PATH_REMOTE"
  elif [ "$COMMAND" = "ls" ]; then
    duplicity list-current-files "$RESOURCE_PATH_REMOTE"
  else
    stdsh_fail "Unknown command: $COMMAND"
  fi
done
