#! /usr/bin/python3

import sys
from richxerox import *

data = sys.stdin.read()

pasteboard.set_contents(html=data)
