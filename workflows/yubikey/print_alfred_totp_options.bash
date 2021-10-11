#! /bin/bash -e

ykman oath accounts list \
      | cut -d: -f1 \
      | tr \\n \\0 \
      | xargs -0 -L1 printf '"%s"\n' \
      | jq -s '{items:[.[] | {title: ., arg: ., match: (. | split(" ") | join("") | ascii_downcase)}]}'
