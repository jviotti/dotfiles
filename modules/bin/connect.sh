#!/bin/sh

MODE="$1"
HOST="$2"
PORT="$3"

set -e
set -u

. "$HOME/.std.sh"

if [ -z "$MODE" ] || [ -z "$HOST" ] || [ -z "$PORT" ]; then
  echo "Usage: $0 <mode=telnet|ssl> <host> <port>" >&2
  exit 1
fi

if [ "$MODE" == "ssl" ]; then
  stdsh_expect_command "openssl"
  openssl s_client -connect "$HOST":"$PORT"
elif [ "$MODE" == "telnet" ]; then
  stdsh_expect_command "telnet"
  telnet "$HOST" "$PORT"
else
  stdsh_fail "Unknown mode: $MODE"
fi
