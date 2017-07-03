#!/bin/sh

source "$HOME/.std.sh"

DRIVE=$1

if stdsh_is_undefined "$DRIVE"; then
  stdsh_fail "Usage: $0 <drive>"
fi

mkdir -p /Volumes/NTFS
diskutil unmountDisk $DRIVE
/usr/local/bin/ntfs-3g $DRIVE /Volumes/NTFS -olocal -oallow_other
