#!/bin/sh

set -o errexit
set -o nounset

usage() {
  echo "Usage $0 <program> [arguments...]" 1>&2
  exit 1
}

if [ "$#" -lt 1 ]
then
  usage
fi

PROGRAM="$1"
shift

OUTPUT="/tmp/cpu_profile_$(whoami)_$(basename "$PROGRAM").trace"
echo "Profiling $PROGRAM into $OUTPUT" 1>&2
# Delete potential previous traces
rm -rf "$OUTPUT"
xctrace record \
  --template 'CPU Profiler' \
  --no-prompt \
  --output "$OUTPUT" \
  --target-stdout - \
  --launch -- "$PROGRAM" "$@"
open "$OUTPUT"
