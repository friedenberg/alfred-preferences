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

PASTEBOARD="$(dirname "$0")/set-pasteboard.py"

RTF=$(echo "$INPUT" | pandoc -s --to rtf | "$PASTEBOARD" --rtf)

CSS_FILE="$(dirname "$0")/style.css"
HTML_COMMAND="pandoc --css $CSS_FILE -H $CSS_FILE --to html"
HTML=$(echo "$INPUT" | $HTML_COMMAND | "$PASTEBOARD" --html)

osascript -e "$(cat <<-EOM
tell application "System Events"
  tell (name of application processes whose frontmost is true)
    keystroke "v" using command down
  end tell
end tell
EOM
)"

