#!/bin/bash

# From http://matt.might.net/articles/shell-scripts-for-passive-voice-weasel-words-duplicates/

weasels="many|various|very|fairly|several|extremely\
|exceedingly|quite|remarkably|few|surprisingly\
|mostly|largely|huge|tiny|((are|is) a number)\
|excellent|interestingly|significantly\
|substantially|clearly|vast|relatively|completely"

if [ -z "$1" ]; then
  echo "Usage: $(basename $0) <file> ..."
  exit 1
fi

egrep -i -n --color "\\b($weasels)\\b" $*
exit $?
