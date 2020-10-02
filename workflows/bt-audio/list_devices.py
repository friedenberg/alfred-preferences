#! /usr/bin/env python3

import json
import sys
import urllib.parse

class Device(dict):
    def __init__(self, device):
        dict.__init__(self)

        self["title"] = device
        self["uid"] = urllib.parse.quote("audio-device." + device)
        self["arg"] = device

devices = sys.stdin.read().splitlines()
items = [Device(d) for d in devices]

print(json.dumps({'items': items}))
