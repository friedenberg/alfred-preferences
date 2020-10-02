#! /bin/bash

DIR_SELF="$(dirname "$0")"
# shellcheck source=/dev/null
. "$alfred_preferences/workflows/bootstrap.bash"

cd "$DIR_SELF" || fail "Unable to cd into $DIR_SELF"

reattach-if-necessary "$0" "$@"
test-missing-dependency pandoc

FILE_HTML_OUT="$(mktemp)"
FILE_ERROR_OUT="$(mktemp)"

TEXT_INPUT="$(./../get-pasteboard.py)"

echo -n "$TEXT_INPUT" \
  | tr '\240' ' ' \
  | pandoc -H style.css -t html -o "$FILE_HTML_OUT" 2> "$FILE_ERROR_OUT"

if [[ "$(cat "$FILE_ERROR_OUT")" != "$(cat "expected_pandoc_html_error")" ]]; then
  fail "Failed to generate html from markdown via pandoc" "$FILE_ERROR_OUT"
fi

if ! sed -i' ' 's|<title>-</title>||' "$FILE_HTML_OUT" 2> "$FILE_ERROR_OUT"; then
  fail "Failed to remove html title from markdown" "$FILE_ERROR_OUT"
fi

if ! ./../set-pasteboard.py < "$FILE_HTML_OUT" 2> "$FILE_ERROR_OUT"; then
  fail "Failed to set html pasteboard content" "$FILE_ERROR_OUT"
fi

osascript -e "$(cat <<-EOM
tell application "System Events"
  tell (name of application processes whose frontmost is true)
    keystroke "v" using command down
  end tell
end tell
EOM
)"
