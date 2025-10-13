#!/bin/sh

set -o errexit
set -o nounset

# Run a Docker container with the current directory mounted as the working directory

if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <docker-image> [command...]" 1>&2
  exit 1
fi

DOCKER_IMAGE="$1"
shift

CURRENT_DIRECTORY="$(pwd)"
WORKDIR="/workspace"

if [ "$#" -eq 0 ]; then
  # Interactive mode: open a shell
  exec docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$CURRENT_DIRECTORY:$WORKDIR" \
    --workdir "$WORKDIR" \
    "$DOCKER_IMAGE" \
    /bin/sh
else
  # Non-interactive mode: execute the command and exit
  docker run \
    --rm \
    --volume "$CURRENT_DIRECTORY:$WORKDIR" \
    --workdir "$WORKDIR" \
    "$DOCKER_IMAGE" \
    "$@"
  exit "$?"
fi
