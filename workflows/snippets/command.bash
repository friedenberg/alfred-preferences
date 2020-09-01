#! /bin/bash

DIR_SELF="$(dirname "$0")"
# shellcheck source=/dev/null
. "$alfred_preferences/workflows/bootstrap.bash"

cd "$DIR_SELF" || fail "Unable to cd into $DIR_SELF"

reattach-if-necessary "$0" "$@"

FILE_CONTENT_OUT="$(mktemp)"
FILE_ERROR_OUT="$(mktemp)"

# shellcheck disable=SC2068
if echo "$INPUT" | $@ 1> "$FILE_CONTENT_OUT" 2> "$FILE_ERROR_OUT"; then
  cat "$FILE_CONTENT_OUT"
else
  cat "$FILE_ERROR_OUT"
  fail "Failed to run custom transform command" "$FILE_ERROR_OUT"
fi

