#!/bin/sh

set -e

if [ -z "$1" ]; then
  echo "Usage: $0 <MAC>" >&2
  exit 1
fi

arp-scan --quiet --localnet --numeric | \
  grep "$1" | \
  cut -f 1
