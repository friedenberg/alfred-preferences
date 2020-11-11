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

def pipeline(*commands, item_class = None):
    processes = []

    for command in commands:
        stdin = subprocess.DEVNULL

        if len(processes) > 0:
            stdin = processes[-1].stdout

        process = subprocess.Popen(
                command,
                stdin = stdin,
                stdout = subprocess.PIPE
                )

        processes.append(process)

    try:
        if item_class is None:
            return process.stdout.read()
        else:
            item_outputter = ItemOutputter(process.stdout, item_class)
            item_outputter.process()

    #todo surface errors

    finally:
        for process in processes[:-1]:
            process.stdout.close()

        processes[-1].wait()

class ItemOutputter():
    def __init__(self, line_iterator, item_class):
        self.line_iterator = line_iterator
        self.item_class = item_class

    def process(self):
        print('{"items":[', end = '')

        for line_object in self.line_iterator:
            line = line_object

            try:
                line = line_object.decode("utf-8").strip()
            except AttributeError as e:
                pass

            item = self.item_class(line)
            print(json.dumps(item),
                    ',',
                    sep = '',
                    end = '')

        print(']}')
