#! /bin/bash -xe

eval `/usr/libexec/path_helper -s`
PATH="$HOME/Eng/go/bin:$PATH"
cd "${ZETTEL_PATH/#\~/$HOME}"
# cd "$HOME/zit"
