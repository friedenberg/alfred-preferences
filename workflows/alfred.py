#! /usr/bin/env python3

import contextlib
import json
import os
import subprocess
import sys

os.environ['PATH'] = '/usr/local/bin/:' + os.environ['PATH']

class ItemException(RuntimeError):
    def __init__(self, original_line, exception):
        self.original_line = original_line
        self.exception
        super().__init__("")

def pipeline(*commands, item_class = None, chunk_size = 1):
    output = subprocess.check_output(
            "|".join([" ".join(a) for a in commands]),
            shell = True,
            )

    item_outputter = ItemOutputter(item_class, chunk_size)
    item_outputter.process(output.splitlines())

@contextlib.contextmanager
def output_wrapped_item_json():
    print('{"items":[', end = '')
    yield
    print(']}')

def output_item(item):
    print(json.dumps(item),
            ',',
            sep = '',
            end = '')

class ItemOutputter():
    def __init__(self, item_class = None, chunk_size = 1):
        self.item_class = item_class
        self.chunk_size = chunk_size

    def process(self, line_iterator):
        with output_wrapped_item_json():
            collector = []

            for line_object in line_iterator:
                line = line_object

                try:
                    line = line_object.decode("utf-8").strip()
                except AttributeError as e:
                    pass

                collector.append(line)

                if len(collector) == self.chunk_size:
                    item = collector

                    if len(collector) == 1:
                        item = collector[0]

                    if self.item_class is not None:
                        item = self.item_class(item)

                    output_item(item)
                    collector = []

if __name__ == "__main__":
    output = pipeline(sys.argv)
