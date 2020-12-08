#! /usr/bin/python3

import os, sys

sys.path.append(os.path.join(os.environ['alfred_preferences'], 'workflows'))

import sqlite3
import tempfile
import shutil
import pathlib
import re
import urllib.parse
import url_normalize

import alfred

ptn_tags = re.compile(r'(?:\W|^)#(?P<tag>[-\w_]+)\b')

urls = set()

class Item(dict):
    def __init__(self, obj):
        title = obj[2]

        url = url_normalize.url_normalize(obj[1])
        [scheme, netloc, path, query, fragment] = urllib.parse.urlsplit(url)
        scheme = "https"

        netloc_parts = netloc.split(".")

        if len(netloc_parts) == 2:
            netloc_parts.insert(0, "www")

        url = urllib.parse.urlunsplit(
                (scheme, ".".join(netloc_parts), path, query, fragment)
                )

        if url in urls:
            return
        else:
            urls.add(url)

        matches_tags = re.findall(ptn_tags, title)

        match_words = []

        for s in matches_tags:
            match_words += s.split('-')

        for w in title.split(' '):
            match_words += w.split('-')

        self["title"] = title
        #self["uid"] = f"bk.{guid}"
        self["match"] = ' '.join(match_words)
        self["arg"] = url
        self["subtitle"] = url

chrome_path = "~/Library/Application Support/Google/Chrome/Default/History"
abs_path = os.path.realpath(os.path.expanduser(chrome_path))
base_path = pathlib.Path(abs_path)

f = tempfile.NamedTemporaryFile('wb')
with open(base_path, 'rb') as a:
    shutil.copyfileobj(a, f)

c = sqlite3.connect(f.name)

with alfred.JSONOutputter() as out:
    for row in c.execute("select * from urls;"):
        out.item(Item(row))



