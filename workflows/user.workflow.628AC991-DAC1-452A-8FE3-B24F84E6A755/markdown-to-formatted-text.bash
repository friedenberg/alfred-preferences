#! /bin/bash

DIR_SELF="$(dirname "$0")"
# shellcheck source=/dev/null
. "$DIR_SELF/../bootstrap.bash"

cd "$DIR_SELF" || fail "Unable to cd into $DIR_SELF"

reattach-if-necessary "$0" "$@"
test-missing-dependency pandoc

FILE_HTML_OUT="$(mktemp)"
FILE_ERROR_OUT="$(mktemp)"

echo -n "$INPUT" \
  | tr '\240' ' ' \
  | pandoc -H style.css -t html -o "$FILE_HTML_OUT" 2> "$FILE_ERROR_OUT"

if [[ "$(cat "$FILE_ERROR_OUT")" != "$(cat "expected_pandoc_html_error")" ]]; then
  cat "$FILE_ERROR_OUT" >&2
  exit 1
fi

sed -i' ' 's|<title>-</title>||' "$FILE_HTML_OUT"

./set-pasteboard.py < "$FILE_HTML_OUT"

osascript -e "$(cat <<-EOM
tell application "System Events"
  tell (name of application processes whose frontmost is true)
    keystroke "v" using command down
  end tell
end tell
EOM
)"
