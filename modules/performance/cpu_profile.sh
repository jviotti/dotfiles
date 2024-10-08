#!/bin/sh

set -o errexit
set -o nounset

# If you need memory tracing too, check `full_profile`. We don't enable
# Allocations by default here, as it can lead to more data than Instruments
# can collect for certain recordings. For example:
#
# *** Terminating app due to uncaught exception 'NSRangeException',
# reason: '*** -[XRSharingArchiver encodeDataObject:]:
# data length (14378608134) makes data too large to fit in non-keyed archive'

usage() {
  echo "Usage $0 <program> [arguments...]" 1>&2
  exit 1
}

if [ "$#" -lt 1 ]
then
  usage
fi

PROGRAM="$(realpath "$1")"
shift

OUTPUT="/tmp/cpu_profile_$(whoami)_$(basename "$PROGRAM").trace"
echo "Profiling $PROGRAM into $OUTPUT" 1>&2
# Delete potential previous traces
rm -rf "$OUTPUT"
xcrun xctrace record \
  --template 'CPU Profiler' \
  --no-prompt \
  --output "$OUTPUT" \
  --target-stdout - \
  --launch -- "$PROGRAM" "$@"
open "$OUTPUT"
