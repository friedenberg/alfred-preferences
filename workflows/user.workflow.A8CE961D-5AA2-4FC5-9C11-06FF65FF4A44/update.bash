#! /bin/bash

PATH="/usr/local/bin/:$PATH"

# shellcheck disable=SC2154
cd "$alfred_preferences/workflows/" || exit

json_escape () {
  printf '%s' "$1" | php -r 'echo json_encode(file_get_contents("php://stdin"));'
}

output-item() {
cat <<EOM
{"alfredworkflow": {"variables": {"TITLE": $(json_escape "$1"),
"SUBTITLE": $(json_escape "$2")}}}
EOM
}

fail() {
  output-item "$1" "$2"
  exit 1
}

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
