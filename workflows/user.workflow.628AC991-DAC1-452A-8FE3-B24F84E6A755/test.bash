#! /bin/bash

PATH="/usr/local/bin/:$PATH"

if ! command -v reattach-to-user-namespace &> /dev/null; then
  echo "reattach-to-usernamespace not found" >&2
  exit 1
fi

if ! command -v pandoc &> /dev/null; then
  echo "pandoc not found" >&2
  exit 1
fi

if [[ "$1" -ne 1 ]]; then
  reattach-to-user-namespace "$0" 1
  exit $?
fi

cat ./test.md | pandoc -H style.css -t html -o test.html
open test.html
