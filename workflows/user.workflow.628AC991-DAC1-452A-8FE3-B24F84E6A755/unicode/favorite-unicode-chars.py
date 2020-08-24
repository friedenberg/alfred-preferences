#! /usr/bin/env python3

import sys
import unicodedata
import json

query = sys.argv[1].lower()

favorite_chars = set(line.strip() for line in open('favorite-characters.txt'))

chars = []
for char in favorite_chars:
    c = ord(char)

    name = unicodedata.name(char)

    matches = [
            name,
            str(c),
            char,
            hex(c),
            hex(c)[2:-1],
            ]

    joined = " ".join(matches).lower()

    if query not in joined:
        continue

    item = {
            'title': char,
            'subtitle': name,
            'uid': "unicode." + char,
            'match': joined,
            'arg': char,
            }

    chars.append(item)

item = {
        'title': "Search all unicode characters",
        'uid': "search-all",
        'arg': "search-all",
        }

chars.append(item)

print(json.dumps({'items': chars}))
