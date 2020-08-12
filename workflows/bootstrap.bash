#! /bin/bash

PATH="/usr/local/bin/:$PATH"

json_escape () {
  printf '%s' "$1" | php -r 'echo json_encode(file_get_contents("php://stdin"));'
}

post-notification() {
  TITLE="$(echo -n $1 | sed 's/"/\\"/g')"
  BODY="$(echo -n $2 | sed 's/"/\\"/g')"
  osascript -e "display notification \"$BODY\" with title \"$TITLE\""
}

output-item() {
cat <<EOM
{"alfredworkflow": {"variables": {"TITLE": $(json_escape "$1"),
"SUBTITLE": $(json_escape "$2")}}}
EOM
}

fail() {
  BODY="$2"

  if [[ -a "$BODY" ]]; then
    BODY="$(cat "$BODY")"
  fi

  post-notification "$1" "$BODY"
  exit 1
}

test-missing-dependency() {
  if ! command -v "$1" &> /dev/null; then
    fail "$1 not found"
  fi
}

reattach-if-necessary() {
  if [[ "$REATTACHED_TO_USER_NAMESPACE" -ne 1 ]]; then
    REATTACHED_TO_USER_NAMESPACE=1 reattach-to-user-namespace "$@"
  else
    exit
  fi
}
