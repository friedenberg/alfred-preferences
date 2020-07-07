#! /bin/bash

DIR_SELF="$(dirname "$0")"
# shellcheck source=/dev/null
. "$DIR_SELF/../bootstrap.bash"

# shellcheck disable=SC2154
cd "$alfred_preferences/workflows/" || fail "Unable to cd into $alfred_preferences/workflows/"

run-command() {
  TITLE="$1"
  shift

  COMMAND=("$@")
  COMMAND_STRING="${COMMAND[*]}"

  post-notification "Starting: $TITLE" "$COMMAND_STRING"

  if ! ERROR=$("$@" 2>&1); then
    fail "Failed: $TITLE" "$ERROR"
  fi

  post-notification "Succeeded: $TITLE" "$COMMAND_STRING"
}

post-notification "Updating Alfred workflows" ""

STAT_COMMAND=(stat -f '%m' "$0")
MODTIME="$(${STAT_COMMAND[*]})"

run-command \
  "Pull Alfred Preferences" \
  git -c 'url.https://github.com/.insteadOf=git@github.com:' pull

if [[ "$MODTIME" -ne "$(${STAT_COMMAND[*]})" ]]; then
  "./$0"
  exit $?
fi

run-command \
  "Install Python Modules" \
  python3 -m pip install --user -r requirements.txt

run-command \
  "Install Brew Formulae" \
  brew bundle install

post-notification "Successfully updated Alfred workflows." ""
