#!/bin/sh

# Copyright (c) 2017, Juan Cruz Viotti
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of the <organization> nor the
#       names of its contributors may be used to endorse or promote products
#     # derived from this software without specific prior written permission.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

ARGV_COMMAND="$1"
ARGV_NOTE="$2"

set -e
set -u

source "$HOME/.std.sh"

# -------------------------------------------------
# Settings
# -------------------------------------------------

NOTES_GIT_REPOSITORY="$HOME/.notes"
NOTES_GIT_DIRECTORY="$NOTES_GIT_REPOSITORY/.git"
GIT="git --work-tree=$NOTES_GIT_REPOSITORY --git-dir=$NOTES_GIT_DIRECTORY"
EXTENSION="markdown"

# -------------------------------------------------
# Initialization
# -------------------------------------------------

stdsh_ensure_directory "$NOTES_GIT_REPOSITORY"

if [ ! -d "$NOTES_GIT_DIRECTORY" ]; then
  echo "Notes directory is not a git repository. Initializing..." 1>&2
  $GIT init
fi

# -------------------------------------------------
# Functions
# -------------------------------------------------

notes_get_title () (
  path="$1"
  grep "." "$path" \
    | head -n 1 \
    | tr '[:upper:]' '[:lower:]' \
    | awk '{$1=$1;print}' \
    | sed 's,[ /&\+^%!#@$*()_={}:;<>?.,|],-,g' \
    | sed 's/-\{2,\}/-/g' \
    | sed 's/^-//g'
)

notes_file_is_modified () (
  path="$1"
  $GIT status --porcelain | grep "^ M $path" > /dev/null
)

notes_stage () (
  path="$1"
  $GIT add "$path"
)

notes_commit () (
  message="$1"
  $GIT commit -m "notes: $message"
)

notes_resolve_filename () (
  name="$1"

  if stdsh_is_undefined "$name"; then
    stdsh_fail "Missing note name"
  fi

  # TODO: Allow auto-completion
  FILENAME="$NOTES_GIT_REPOSITORY/$name.$EXTENSION"
  if [ ! -f "$FILENAME" ]; then
    stdsh_fail "Invalid note name: $name"
  fi

  echo "$name.$EXTENSION"
)

# -------------------------------------------------
# Commands
# -------------------------------------------------

notes_command_add () (
  tempfile="$(mktemp -t "notes").$EXTENSION"
  "$EDITOR" "$tempfile"
  if [ ! -f "$tempfile" ]; then
    stdsh_fail "Nothing was written"
  fi

  title="$(notes_get_title "$tempfile")"
  if stdsh_is_undefined "$title"; then
    rm "$tempfile"
    stdsh_fail "This note has no title"
  fi

  filename="$title.$EXTENSION"
  # TODO: Make sure this doesn't replace an
  # existing note with the same title.
  mv "$tempfile" "$NOTES_GIT_REPOSITORY/$filename"
  notes_stage "$filename"
  notes_commit "add note $title using $EDITOR"
)

notes_command_ls () (
  find "$NOTES_GIT_REPOSITORY" \
    -type f \
    -name "*.$EXTENSION" \
    -exec basename -s ".$EXTENSION" {} \;
)

notes_command_cat () (
  note="$1"
  filename="$(notes_resolve_filename "$note")"
  cat "$NOTES_GIT_REPOSITORY/$filename"
)

notes_command_edit () (
  note="$1"
  filename="$(notes_resolve_filename "$note")"
  "$EDITOR" "$NOTES_GIT_REPOSITORY/$filename"

  if notes_file_is_modified "$filename"; then
    notes_stage "$filename"
    notes_commit "change note $filename using $EDITOR"
  fi

  newtitle="$(notes_get_title "$NOTES_GIT_REPOSITORY/$filename")"
  if [ "$newtitle" != "$note" ]; then
    newfilename="$newtitle.$EXTENSION"
    mv "$NOTES_GIT_REPOSITORY/$filename" "$NOTES_GIT_REPOSITORY/$newfilename"
    notes_stage "$filename"
    notes_stage "$newfilename"
    notes_commit "move note $filename to $newfilename"
  fi
)

notes_command_rm () (
  note="$1"
  filename="$(notes_resolve_filename "$note")"
  rm "$NOTES_GIT_REPOSITORY/$filename"
  notes_stage "$filename"
  notes_commit "remove note $filename"
)

notes_command_sync () (
  if stdsh_is_undefined "$($GIT remote -v)"; then
    stdsh_fail "There are no configured remotes for $NOTES_GIT_REPOSITORY"
  fi

  $GIT pull
  $GIT push
)

# -------------------------------------------------
# CLI
# -------------------------------------------------

if [ -z "$ARGV_COMMAND" ]; then
  echo "Usage $0 <COMMAND> [NOTE]" 1>&2
  echo "" 1>&2
  echo "Commands:" 1>&2
  echo "" 1>&2
  echo "  add          create a new note" 1>&2
  echo "  ls           list all notes" 1>&2
  echo "  sync         sync notes repository" 1>&2
  echo "  cat <note>   print a note" 1>&2
  echo "  edit <note>  edit a note" 1>&2
  echo "  rm <note>    remove a note" 1>&2
  exit 1
fi

case "$ARGV_COMMAND" in
  add) notes_command_add ;;
  ls) notes_command_ls ;;
  cat) notes_command_cat "$ARGV_NOTE" ;;
  edit) notes_command_edit "$ARGV_NOTE" ;;
  rm) notes_command_rm "$ARGV_NOTE" ;;
  sync) notes_command_sync ;;
  *) stdsh_fail "Unknown command: $ARGV_COMMAND" ;;
esac

exit 0
