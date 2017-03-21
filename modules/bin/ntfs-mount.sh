#!/bin/sh

DRIVE=$1

if [ -z $DRIVE ]; then
  echo "Usage: $0 <drive>"
  exit 1
fi

mkdir -p /Volumes/NTFS
diskutil unmountDisk $DRIVE
/usr/local/bin/ntfs-3g $DRIVE /Volumes/NTFS -olocal -oallow_other
