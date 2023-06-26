#! /bin/bash -xe

ZIT_DIR="${ZIT_DIR/#\~/$HOME}"

dir_flake="$(pwd)/../"

pushd "$ZIT_DIR" >/dev/null
/nix/var/nix/profiles/default/bin/nix shell -i "$dir_flake" -c "$@"
