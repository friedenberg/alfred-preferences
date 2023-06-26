#! /bin/bash -e

# eval `/usr/libexec/path_helper -s`
/nix/var/nix/profiles/default/bin/nix shell --quiet -c echo hello
cd "${ZIT_DIR/#\~/$HOME}"

