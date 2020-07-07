#! /bin/bash

DIR_SELF="$(dirname "$0")"
# shellcheck source=/dev/null
. "$DIR_SELF/../bootstrap.bash"

cd "$DIR_SELF" || fail "Unable to cd into $DIR_SELF"

reattach-if-necessary "$0" "$@"

FILE="$(mktemp)"

echo -n "$INPUT" > "$FILE"

vim -e --clean \
  "+filetype plugin indent on" \
  "+set filetype=$1" \
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

