#!/bin/sh

set -eu

PULL_REQUESTS="$(hub pr list --state open --format "%au %I %t %n")"
DELIMITER=' '

# Save any current work
git add .
git stash

# Update master
git checkout master
git pull

printf "%s" "$PULL_REQUESTS" | while IFS= read -r line
do
	COLUMN_USER="$(echo "$line" | cut -f 1 -d "$DELIMITER")"
	COLUMN_NUMBER="$(echo "$line" | cut -f 2 -d "$DELIMITER")"
	COLUMN_TITLE="$(echo "$line" | cut -f 3- -d "$DELIMITER")"

	# Only process my PRs
	if [ "$COLUMN_USER" != "$(whoami)" ];
	then
		continue
	fi

  if [[ "$COLUMN_TITLE" =~ WIP ]]; then
    echo ">>>> Ignoring WIP pull request: [$COLUMN_NUMBER] - $COLUMN_TITLE"
    continue
  fi

	echo ">>>> Processing: [$COLUMN_NUMBER] - $COLUMN_TITLE"
  hub ci-status --verbose --format "%S %t %n" | grep -v "^success"
	hub pr checkout "$COLUMN_NUMBER"
  echo ">>>> Rebasing pull request branch"
	git rebase master
  echo ">>>> Pushing branch"
	git push -f
done
