#! /bin/bash -e

# eval `/usr/libexec/path_helper -s`
export PATH="$HOME/.asdf/shims:$HOME/Eng/go/bin:$PATH"
cd "${ZIT_DIR/#\~/$HOME}"

