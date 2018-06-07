#!/bin/sh

set -e
set -u

if ! type "task" > /dev/null; then
  echo "TaskWarrior is not installed" 1>&2
  exit 1
fi

DATA_DIRECTORY="$(task _show | grep data.location | cut -d '=' -f 2)"
# Expand ~ to $HOME, otherwise -d tests fail
DATA_DIRECTORY="${DATA_DIRECTORY/'~'/$HOME}"

GIT_DIRECTORY="$DATA_DIRECTORY/.git"
GIT="git --work-tree="$DATA_DIRECTORY" --git-dir="$GIT_DIRECTORY""

if [ ! -d "$DATA_DIRECTORY" ]; then
  echo "The data directory $DATA_DIRECTORY doesn't exist" 1>&2
  exit 1
fi

if [ ! -d "$GIT_DIRECTORY" ]; then
  echo "No git directory in $DATA_DIRECTORY" 1>&2
  exit 1
fi

COMMAND="$@"

if [ "$COMMAND" = "sync" ]; then
  $GIT pull
  $GIT push
  exit 0
fi

task $COMMAND

GIT_STATUS="$(command $GIT status --porcelain 2> /dev/null | tail -n1)"

if [ -n "$GIT_STATUS" ]; then
  $GIT add "$DATA_DIRECTORY/*.data"

  MESSAGE="sync:"
  if [ -z "$COMMAND" ]; then
    MESSAGE="$MESSAGE no command"
  else
    MESSAGE="$MESSAGE $COMMAND"
  fi

  $GIT commit -m "$MESSAGE"
fi
