#! /usr/bin/python3

import os, sys

sys.path.append(os.path.join(os.environ['alfred_preferences'], 'workflows'))

import re
import pathlib

import alfred

class Item(dict):
    def __init__(self, obj):
        title = obj["title"]
        url = obj["url"]
        guid = obj["id"]

        self["title"] = title
        self["arg"] = url
        self["subtitle"] = url

alfred.pipeline(
        [
            "./chrome_tabs.js",
            ],
        chunker = alfred.JSONChunker(Item),
        )
