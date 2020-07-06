#! /bin/bash

PATH="/usr/local/bin/:$PATH"

if ! command -v gsed &> /dev/null; then
  echo "gsed not found" >&2
  exit 1
fi

gsed -i "/^$1/d" ./favorite-characters.txt
