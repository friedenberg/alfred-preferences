#! /bin/bash

shopt -s extglob

while IFS= read -r -d $'\0' NAME_OLD; do
  DIR="$(dirname "$NAME_OLD")"
  BASENAME="$(basename "$NAME_OLD")"
  BASENAME="${BASENAME##+(*\[)}"
  BASENAME="${BASENAME/]/}"
  NAME_NEW="$DIR/$BASENAME"

  if [[ "$1" == "--dry-run" ]]; then
    echo mv "$NAME_OLD" "$NAME_NEW"
    echo git secrets add "$NAME_NEW"
  else
    mv "$NAME_OLD" "$NAME_NEW"
    git secrets add "$NAME_NEW"
  fi

done < <(find "$(realpath "$(dirname "$0")")" -mindepth 1 -iname '*\[*\].json' -print0)
