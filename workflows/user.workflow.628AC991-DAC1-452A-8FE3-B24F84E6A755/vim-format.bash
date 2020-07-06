#! /bin/bash

PATH="/usr/local/bin/:$PATH"

if ! command -v reattach-to-user-namespace &> /dev/null; then
  echo "reattach-to-usernamespace not found" >&2
  exit 1
fi

if [[ "$1" -ne 1 ]]; then
  reattach-to-user-namespace "$0" 1 "$@"
  exit $?
fi

cd "$(dirname "$0")" || exit 1

FILE="$(mktemp)"

echo -n "$INPUT" > "$FILE"

vim -e --clean \
  "+filetype plugin indent on" \
  "+set filetype=$2" \
  '+normal gg=G' \
  '+%print' \
  '+q!' \
  /dev/stdin \
  < "$FILE" \
  | pbcopy

osascript -e "$(cat <<-EOM
tell application "System Events"
  tell (name of application processes whose frontmost is true)
    keystroke "v" using command down
  end tell
end tell
EOM
)"

