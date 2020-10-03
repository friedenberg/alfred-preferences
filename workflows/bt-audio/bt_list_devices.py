#! /usr/bin/env python3

import json
import sys
import urllib.parse

class Device(dict):
    def __init__(self, device):
        dict.__init__(self)

        self["title"] = device["name"]

        recentAccessDate = device["recentAccessDate"]

        if recentAccessDate is not None:
            self["subtitle"] = device["recentAccessDate"]

        self["uid"] = urllib.parse.quote("bt-device." + device["address"])
        self["arg"] = device["address"]

in_devices = sys.stdin.read()
in_devices = json.loads(in_devices)

out_items = [Device(d) for d in in_devices]

print(json.dumps({'items': out_items}))
