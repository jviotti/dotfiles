#!/bin/sh

if [ "$#" -lt 1 ]
then
  echo "Usage: $0 <module>" 1>&2
  exit 1
fi

./vendor/vendorpull/upgrade "$1"
./vendor/vendorpull/pull "$1" "../$1"
