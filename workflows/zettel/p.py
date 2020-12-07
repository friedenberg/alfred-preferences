#! /usr/bin/python3

import os, sys

sys.path.append(os.path.join(os.environ['alfred_preferences'], 'workflows'))

import re
import pathlib

import alfred

ptn_tags = re.compile(r'(?:\W|^)#(?P<tag>[-\w_]+)\b')

class Item(dict):
    def __init__(self, obj):
        title = obj["name"]
        url = obj["url"]
        guid = obj["guid"]
        matches_tags = re.findall(ptn_tags, title)

        match_words = []

        for s in matches_tags:
            match_words += s.split('-')

        for w in title.split(' '):
            match_words += w.split('-')

        self["title"] = title
        self["uid"] = f"bk.{guid}"
        self["match"] = ' '.join(match_words)
        self["arg"] = url
        self["subtitle"] = url

chrome_path = "~/Library/Application Support/Google/Chrome/"
abs_path = os.path.realpath(os.path.expanduser(chrome_path))
base_path = pathlib.Path(abs_path)

paths = [p.absolute().as_posix() for p in base_path.glob('*/Bookmarks')]

alfred.pipeline(
        [
            'jq',
            '.. | .children? | arrays | .[] | select(.type == "url")',
            "--compact-output",
            *paths,
            ],
        [
            "jq",
            "-s",
            ".",
            ],
        #jq --stream "if .[0][-3] == \"children\" and ( .[0][-1] == \"url\" or .[0][-1] == \"name\") then .[1] else null end"
        # [
        #     'osascript',
        #     'chrome_bookmarks.scpt',
        #     ],
        chunker = alfred.JSONChunker(Item),
        )
