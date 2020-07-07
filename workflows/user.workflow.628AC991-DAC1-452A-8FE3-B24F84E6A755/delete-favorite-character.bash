#! /bin/bash

DIR_SELF="$(dirname "$0")"
# shellcheck source=/dev/null
. "$DIR_SELF/../bootstrap.bash"

cd "$DIR_SELF" || fail "Unable to cd into $DIR_SELF"

test-missing-dependency gsed

gsed -i "/^$1/d" ./favorite-characters.txt
