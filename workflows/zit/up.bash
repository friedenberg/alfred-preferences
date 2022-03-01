#! /bin/bash -xe

eval `/usr/libexec/path_helper -s`
PATH="$HOME/Eng/go/bin:$PATH"
cd "${ZIT_DIR/#\~/$HOME}"
