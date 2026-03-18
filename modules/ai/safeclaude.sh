#!/bin/sh

set -o errexit
set -o nounset

PROFILE="$HOME/.claude/sandbox-exec.profile"
WORKDIR="$(pwd -P)"

TMPPROFILE="$(mktemp /tmp/claude-sandbox.XXXXXX)"
trap 'rm -f "$TMPPROFILE"' EXIT

# Inject HOME_DIR before the profile so the home-* macros resolve correctly
echo "(define HOME_DIR \"$HOME\")" > "$TMPPROFILE"
cat "$PROFILE" >> "$TMPPROFILE"

# Emit ancestor directory traversal literals so that getcwd() and cd work
# for any subprocess spawned inside the sandbox. Without these, /bin/sh
# cannot resolve the working directory and fails with "Not a directory".
{
  echo ""
  echo ";; Workdir grants (injected at launch for: $WORKDIR)"
  echo ";; Ancestor traversal literals for getcwd() resolution"
  ANCESTOR="$WORKDIR"
  while [ "$ANCESTOR" != "/" ]; do
    ANCESTOR="$(dirname "$ANCESTOR")"
    echo "(allow file-read-metadata (literal \"$ANCESTOR\"))"
  done
  echo "(allow file-read* file-write* (subpath \"$WORKDIR\"))"
  echo "(allow process-exec (subpath \"$WORKDIR\"))"
} >> "$TMPPROFILE"

exec /usr/bin/sandbox-exec -f "$TMPPROFILE" claude --dangerously-skip-permissions "$@"
