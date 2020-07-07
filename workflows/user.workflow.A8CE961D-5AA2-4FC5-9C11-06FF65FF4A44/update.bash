#! /bin/bash

DIR_SELF="$(dirname "$0")"
# shellcheck source=/dev/null
. "$DIR_SELF/../bootstrap.bash"

cd "$DIR_SELF" || fail "Unable to cd into $DIR_SELF"

# shellcheck disable=SC2154
cd "$alfred_preferences/workflows/" || exit

if ! ERROR=$(git -c 'url.https://github.com/.insteadOf=git@github.com:' pull 2>&1); then
  fail "Failed to pull Alfred preferences." "$ERROR"
fi

if ! ERROR=$(pip3 install --user -r requirements.txt 2>&1); then
  fail "Failed to install Python modules." "$ERROR"
fi

if ! ERROR=$(brew bundle install); then
  fail "Failed to install Brew formulae." "$ERROR"
fi

output-item "Successfully updated Alfred workflows." ""
