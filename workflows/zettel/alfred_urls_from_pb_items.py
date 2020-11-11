#! /usr/local/bin/python3

import os, sys

sys.path.append(os.path.join(os.environ['alfred_preferences'], 'workflows'))

import re
import babel.dates

import alfred

from datetime import datetime, timedelta
from pathlib import PurePosixPath

pattern = re.compile(r'^(\d+) pb\W+')

class Item(dict):
    def __init__(self, c):
        dict.__init__(self)

        path = PurePosixPath(c)

        name = path.stem

        title = pattern.sub('', name)
        uid_match = pattern.match(name)
        uid = ""
        formatted_date = ""

        if uid_match:
            zettel_id = uid_match.group(1)
            uid = f"archive.pb.{zettel_id}"
            zettel_date = datetime.strptime(zettel_id, "%Y%m%d%H%M")
            formatted_date = babel.dates.format_timedelta(datetime.now() - zettel_date)

        url = ""

        with open(path) as f:
            url = f.readline().strip()

        self["title"] = title
        self["subtitle"] = formatted_date
        self["uid"] = uid
        self["match"] = name
        self["arg"] = url

alfred.pipeline(
        [
            "mdfind",
            "-onlyin",
            os.environ["ZETTEL_PATH"],
            "kMDItemFSName == '*pb:*' || kMDItemTextContent == '*#pb*'",
            ],
        item_class = Item
        )
