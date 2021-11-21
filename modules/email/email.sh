#!/bin/sh

set -o errexit
set -o nounset

# mbsync often fails with EOF from Mailfence's IMAP. Retrying enough times seem
# to make it work, so it might be a race condition that can be circunvented by
# just retrying various times until it works.

RETRIES=10
EXIT_CODE=1
while [ "$RETRIES" -gt 0 ] && [ "$EXIT_CODE" != "0" ]
do
  mbsync --all && EXIT_CODE="$?" || EXIT_CODE="$?"
  RETRIES="$((RETRIES-1))"
done
exit "$EXIT_CODE"
