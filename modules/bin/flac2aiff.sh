#!/bin/sh

set -o errexit
set -o nounset

if [ "$#" -ne 1 ]
then
  echo "Usage: $0 <directory>" 1>&2
  exit 1
fi

DIRECTORY="$1"
echo "Converting FLAC files in $DIRECTORY to AIFF in-place" 1>&2

find "$DIRECTORY" -type f -name '*.flac' -print0 | while IFS= read -r -d '' file
do
  DIRNAME="$(dirname "$file")"
  BASENAME="$(basename "$file" .flac)"
  echo "$file:" 1>&2
  echo "    --> $DIRNAME/$BASENAME.aiff" 1>&2
  ffmpeg -i "$file" -write_id3v2 1 -c:v copy "$DIRNAME/$BASENAME.aiff"
  rm "$file"
done
