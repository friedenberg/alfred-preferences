#! /bin/bash -xe

eval `/usr/libexec/path_helper -s`
cd "${ZETTEL_PATH/#\~/$HOME}"

if [[ ! -f ./z ]]; then
  cp ~/Eng/go/src/github.com/friedenberg/z/z ./z
fi
