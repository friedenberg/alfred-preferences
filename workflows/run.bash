#! /bin/bash -e

dir_parent="$(dirname "$0")"
dir_first_path="$(realpath "$dir_parent/result/bin")"
PATH="$dir_first_path:$PATH"

ZIT_DIR="${ZIT_DIR/#\~/$HOME}"

pushd "$ZIT_DIR" >/dev/null
"$@"
