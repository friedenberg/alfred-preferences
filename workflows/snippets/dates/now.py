#! /usr/bin/python3

import os, sys

sys.path.append(os.path.join(os.environ['alfred_preferences'], 'workflows'))

import alfred

from datetime import datetime

class Date(dict):
    def __init__(self, title, value, identifier):
        dict.__init__(self)

        now = datetime.now().astimezone()
        value = now.strftime(value)

        self["title"] = title
        self["subtitle"] = value
        self["uid"] = identifier
        self["match"] = " ".join([title, value])
        self["arg"] = value

formats = [
        ("Week Number",    "%V",                     "snippets.date.week_number"),
        ("Time Zone",      "%Z",                     "snippets.date.time_zone"),
        ("UTC",            "%s",                     "snippets.date.timestamp"),
        ("File Safe Date", "%Y-%m-%d",               "snippets.date.file_safe_date"),
        ("Daily Log Date", "%Y-%m-%d, %A",           "snippets.date.daily_log_date"),
        ("ISO 8601",       "%Y-%m-%dT%H:%M:%S.%f%z", "snippets.date.iso8601"),
        ("Date Time",      "%Y-%m-%d %H:%M:%S",      "snippets.date.date_time"),
        ]

with alfred.JSONOutputter() as out:
    [out.item(Date(*i)) for i in formats]


