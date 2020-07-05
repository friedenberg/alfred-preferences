#! /usr/bin/env python3

import sys
import pasteboard

uti_type = sys.argv[1]

data = sys.stdin.read()

pb = pasteboard.Pasteboard()

uti_flag_map = {
        "--html": pasteboard.HTML,
        "--rtf": pasteboard.RTF,
        }

try:
    pb.set_contents(data, uti_flag_map[uti_type])
except KeyError:
    sys.stderr.write("Unsupported UTI: " + uti_type)
    exit(1)

