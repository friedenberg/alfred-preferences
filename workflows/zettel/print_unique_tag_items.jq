#! /usr/bin/env jq -s -f
# z:1627736961

def get_entry($key):
  {
    key: ((.[0]|.[$key]) // "null"),
    value: length
  }
  ;

def get_counts($key):
  [
    group_by (.[$key])[]
    | get_entry($key)
  ]
  # `-.value` for count descending
  | sort_by($key)
  | from_entries
  ;

def get_nested_counts($key):
  [{($key): ((.[] | .[$key]) | .[]?)}]
  | get_counts($key)
  ;

{
  items: [
    get_nested_counts("tags") | to_entries | .[] | {
      # "uid": "desktop",
      # "type": "file",
      "title": .key,
      "subtitle": (if .value == 1 then (.value | tostring) + " zettel" else (.value | tostring) + " zettels" end),
      "arg": .key,
      "match": (.key / "-" | join(" ")),
      # "autocomplete": "Desktop",
      # "icon": {
      #   "type": "fileicon",
      #   "path": "~/Desktop"
      # }
    }
  ]
}
