#! /bin/bash -e

dir_parent="$(dirname "$0")"
dirs_to_add=("$dir_parent"/result*/bin)

for dir in "${dirs_to_add[@]}"; do
  dir="$(realpath "$dir")"
  PATH="$dir:$PATH"
done

ZIT_DIR="${ZIT_DIR/#\~/$HOME}"

pushd "$ZIT_DIR" >/dev/null
"$@"
