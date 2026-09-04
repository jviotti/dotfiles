#!/bin/sh

set -o errexit
set -o nounset

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]
then
  echo "Usage: $0 <video> [output.mp3]" 1>&2
  exit 1
fi

INPUT="$1"

if [ ! -f "$INPUT" ]
then
  echo "$INPUT is not a file" 1>&2
  exit 1
fi

if [ "$#" -eq 2 ]
then
  OUTPUT="$2"
else
  DIRNAME="$(dirname "$INPUT")"
  BASENAME="$(basename "$INPUT")"
  OUTPUT="$DIRNAME/${BASENAME%.*}.mp3"
fi

if [ "$INPUT" = "$OUTPUT" ]
then
  echo "The input and output files must be different" 1>&2
  exit 1
fi

echo "Extracting the audio of $INPUT" 1>&2
echo "    --> $OUTPUT" 1>&2

ffmpeg -i "$INPUT" -vn -map_metadata 0 -c:a libmp3lame -q:a 2 "$OUTPUT"
