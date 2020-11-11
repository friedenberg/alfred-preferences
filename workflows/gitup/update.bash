#! /bin/bash -e

DIR_SELF="$(dirname "$0")"
# shellcheck source=/dev/null
. "$alfred_preferences/workflows/bootstrap.bash"

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

if [[ -z "$UPDATED" ]]; then
  post-notification "Updating Alfred workflows" ""

  run-command \
    "Force Brewfile.lock.json to be unchanged" \
    git update-index --assume-unchanged Brewfile.lock.json

  run-command \
    "Pull Alfred Preferences" \
    git -c 'url.https://github.com/.insteadOf=git@github.com:' pull

  run-command \
    "Return Brewfile.lock.json to normal" \
    git update-index --no-assume-unchanged Brewfile.lock.json

  UPDATED=1 exec "$0"
fi

run-command \
  "Install Python Modules" \
  /usr/bin/python3 -m pip install --user -r requirements.txt

run-command \
  "Install Brew Formulae" \
  brew bundle install

post-notification "Successfully updated Alfred workflows." ""

