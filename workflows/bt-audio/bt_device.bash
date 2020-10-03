#! /bin/bash

DIR_SELF="$(dirname "$0")"
# shellcheck source=/dev/null
. "$alfred_preferences/workflows/bootstrap.bash"

cd "$DIR_SELF" || fail "Unable to cd into $DIR_SELF"

reattach-if-necessary "$0" "$@"
test-missing-dependency SwitchAudioSource

blueutil "--$1" "$2"
blueutil "--info" "$2" --format=json | jq ".name" --raw-output
