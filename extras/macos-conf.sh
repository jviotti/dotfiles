#!/bin/sh

# Disable Spotlight indexing
# See http://www.iclarified.com/49187/how-to-disable-and-reenable-spotlight-indexing-on-your-mac
launchctl unload -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist
