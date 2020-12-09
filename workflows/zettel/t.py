#! /usr/bin/python3

import os, sys

sys.path.append(os.path.join(os.environ['alfred_preferences'], 'workflows'))

import re
import pathlib

import alfred
import url_item

alfred.pipeline(
        [
            "./chrome_tabs.js",
            ],
        chunker = alfred.JSONChunker(
            lambda x: url_item.Item(
                x["title"],
                x["url"],
                ),
            ),
        )
