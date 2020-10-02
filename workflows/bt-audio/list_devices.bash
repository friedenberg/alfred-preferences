#! /bin/bash

DIR_SELF="$(dirname "$0")"
# shellcheck source=/dev/null
. "$alfred_preferences/workflows/bootstrap.bash"

cd "$DIR_SELF" || fail "Unable to cd into $DIR_SELF"

reattach-if-necessary "$0" "$@"
test-missing-dependency SwitchAudioSource

SwitchAudioSource -a | \
  awk -F' \\(' "/.*($1)/ { print \$1 }" | \
  $DIR_SELF/list_devices.py
