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
    stdin = subprocess.DEVNULL

    for command in commands:
        if len(processes) > 0:
            stdin = processes[-1].stdout

        process = subprocess.Popen(
                command,
                stdin = stdin,
                stdout = subprocess.PIPE,
                stderr = subprocess.PIPE,
                )

        processes.append(process)

    def close_and_wait():
        for process in processes[:-1]:
            process.stdout.close()

        for process in processes:
            process.wait()

    if item_class is None:
        close_and_wait()

        errors = [
                {
                    "title": f"Command error ({p.returncode}): {p.args}",
                    "subtitle": f"Output: ${p.stderr.read()}",
                    }
                for p in processes
                if p.returncode != 0
                ]

        if len(errors) is 0:
            return processes[-1].stdout.read()
        else:
            item_outputter = ItemOutputter(errors)
            item_outputter.process()
            return None
    else:
        try:
            item_outputter = ItemOutputter(process.stdout, item_class)
            item_outputter.process()

        finally:
            close_and_wait()


class ItemOutputter():
    def __init__(self, line_iterator, item_class = None):
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

            if self.item_class is None:
                item = line
            else:
                item = self.item_class(line)
            print(json.dumps(item),
                    ',',
                    sep = '',
                    end = '')

        print(']}')
