#!/bin/sh

# From https://gssparks.github.io/post/a-simple-command-line-youtube-music-player/

if [ "$#" -lt 1 ]
then
  echo "Usage: $0 <query>" 1>&2
  exit 1
fi

SEARCH=$*
echo "Playing Music based on the search: $SEARCH" 1>&2
mpv --shuffle --no-video ytdl://ytsearch10:"$SEARCH" --ytdl-format=bestaudio
