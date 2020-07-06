#! /bin/bash

PATH="/usr/local/bin/:$PATH"

if ! command -v reattach-to-user-namespace &> /dev/null; then
  echo "reattach-to-usernamespace not found" >&2
  exit 1
fi

if ! command -v pandoc &> /dev/null; then
  echo "pandoc not found" >&2
  exit 1
fi

if [[ "$1" -ne 1 ]]; then
  reattach-to-user-namespace "$0" 1
  exit $?
fi

cd "$(dirname "$0")"

FILE_HTML_OUT="$(mktemp)"
echo -n "$INPUT" | tr '\240' ' ' | pandoc -H style.css -t html -o "$FILE_HTML_OUT"
cat "$FILE_HTML_OUT" | ./set-pasteboard.py --html

osascript -e "$(cat <<-EOM
tell application "System Events"
  tell (name of application processes whose frontmost is true)
    keystroke "v" using command down
  end tell
end tell
EOM
)"

