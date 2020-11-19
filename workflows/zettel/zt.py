#! /usr/bin/python3

import os, sys

sys.path.append(os.path.join(os.environ['alfred_preferences'], 'workflows'))

import re
import babel.dates

import alfred

from datetime import datetime, timedelta
from pathlib import PurePosixPath

ptn_xargs_header = re.compile(r'==>.*\/(?P<ts>\d+)\s+(?P<title>.*)\.\w+\s+<==')
ptn_tags = re.compile(r'#(?P<tag>[-\w_]+)\b')

class Item(dict):
    def __init__(self, lines):
        dict.__init__(self)
        head_match = re.match(ptn_xargs_header, lines[0])
        tail_matches = re.findall(ptn_tags, lines[1])

        if len(tail_matches) == 0:
            return

        title = "not set"
        ts = ""
        uid = ""
        formatted_date = ""
        subtitle = "not set"

        try:
            title = head_match.groupdict()['title']
            zettel_id = head_match.groupdict()['ts']
            uid = f"zettel.{zettel_id}"
            zettel_date = datetime.strptime(zettel_id, "%Y%m%d%H%M")
            formatted_date = babel.dates.format_datetime(zettel_date, locale='en_US')
        except AttributeError as e:
            title = lines[0]
            subtitle = str(e)

        subtitle = ' '.join([f'#{m}' for m in tail_matches])

        tags = [s.split('-') for s in tail_matches]

        self["title"] = title
        self["subtitle"] = ' '.join([f'#{m}' for m in tail_matches])
        self["uid"] = uid
        self["match"] = ' '.join([i for s in tags for i in s])
        self["arg"] = f"thearchive://match/{zettel_id}"


alfred.pipeline(
        [
            'find',
            os.environ['ZETTEL_PATH'],
            '-type',
            'f',
            '-iname',
            '*.md',
            '-print0',
            ],
        [
            'xargs',
            '-0',
            'head',
            '-1',
            ],
        item_class = Item,
        chunk_size = 3
        )
