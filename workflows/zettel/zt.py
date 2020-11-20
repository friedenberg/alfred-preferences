#! /usr/bin/python3

import os, sys

sys.path.append(os.path.join(os.environ['alfred_preferences'], 'workflows'))

import re
import babel.dates

import alfred

from datetime import datetime, timedelta
from pathlib import PurePosixPath

ptn_xargs_header = re.compile(r'==>.*\/(?P<ts>\d+)\s+(?P<title>.*)\.\w+\s+<==')
ptn_tags = re.compile(r'(?:\W|^)#(?P<tag>[-\w_]+)\b')

class Item(dict):
    def __init__(self, lines):
        dict.__init__(self)
        head_match = re.match(ptn_xargs_header, lines[0])
        tail_matches = re.findall(ptn_tags, lines[1])

        url = None

        try:
            url = lines[2]
        except IndexError:
            pass

        title = "not set"
        ts = ""
        uid = ""
        formatted_date = ""
        subtitle = "not set"
        arg = "not set"
        zettel_id = "not set"
        error = None

        try:
            title = head_match.groupdict()['title']
            zettel_id = head_match.groupdict()['ts']
            uid = f"zettel.{zettel_id}"
            zettel_date = datetime.strptime(zettel_id, "%Y%m%d%H%M")
            formatted_date = babel.dates.format_date(zettel_date, locale='en_US')
        except AttributeError as e:
            print(lines[0], file = sys.stderr)
            title = lines[0]
            error = str(e)

        subtitle = ' '.join([f'#{m}' for m in tail_matches])

        if url is not None and "kind-pb" in tail_matches:
            arg = url
        else:
            arg = f"thearchive://match/{zettel_id}"

        match_words = []

        for s in tail_matches:
            match_words += s.split('-')

        for s in title.split(' '):
            match_words += s.split('-')

        self["title"] = title
        self["uid"] = uid
        self["match"] = ' '.join(match_words)
        self["arg"] = arg

        if error is None:
            tag_list = ' '.join([f'#{m}' for m in tail_matches])
            if len(tag_list) == 0:
                self["subtitle"] = formatted_date
            else:
                self["subtitle"] = f"{formatted_date}, {tag_list}"
        else:
            self["subtitle"] = error

class Chunker(alfred.Chunker):
    def __init__(self):
        self.acc = []

    def process_line(self, line):
        try:
            line = line.decode("utf-8").strip()
        except AttributeError as e:
            pass

        if len(self.acc) > 0 and self.is_head_line(line):
            alfred.output_item(Item(self.acc))
            self.acc = [line]
        else:
            self.acc.append(line)

    def is_head_line(self, line):
        return line.startswith('==>') and line.endswith('<==')


alfred.pipeline(
        [
            'find',
            os.path.realpath(os.path.expanduser(os.environ['ZETTEL_PATH'])),
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
            '-2',
            ],
        chunker = Chunker(),
        )
