#!/bin/sh

# From https://gssparks.github.io/post/a-simple-command-line-youtube-music-player/

SEARCH=$*
echo "Playing Music based on the search: $SEARCH" 1>&2
mpv --shuffle --no-video ytdl://ytsearch10:"$SEARCH" --ytdl-format=bestaudio
