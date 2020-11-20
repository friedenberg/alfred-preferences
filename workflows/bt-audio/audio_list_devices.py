#! /usr/bin/env python3

import os, sys

sys.path.append(os.path.join(os.environ['alfred_preferences'], 'workflows'))

import re

import alfred

pattern_device = re.compile(r'(.*)\((.*)\)')

class Device(dict):
    def __init__(self, lines):
        dict.__init__(self)
        device = lines[0]

        match = pattern_device.match(device)
        device_name = ""
        device_type = ""

        if match is not None:
            device_name = match.group(1).strip()
            device_type = match.group(2).strip()

        self["title"] = device_name
        self["subtitle"] = device_type
        self["uid"] = f"audio-device.{device_name}.{device_type}"
        self["arg"] = f"-t {device_type} -s '{device_name}'"

devices = sys.stdin.read().splitlines()
items = [Device(d) for d in devices]

alfred.pipeline(
        [
            "SwitchAudioSource",
            "-a",
            ],
        chunker = alfred.LineChunker(Device, 1)
        )
