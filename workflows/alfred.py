#! /usr/bin/env python3

import contextlib
import json
import os
import subprocess
import sys
import shlex
import abc
import asyncio

os.environ['PATH'] = '/usr/local/bin/:' + os.environ['PATH']

class JSONOutputter():
    def __enter__(self):
        print('{"items":[', end = '')
        return self

    def item(self, item):
        print(json.dumps(item),
                ',',
                sep = '',
                end = '')

    def __exit__(self, exc_type, exc_val, exc_tb):
        print(']}')

class Chunker(abc.ABC):
    def __enter__(self):
        pass

    def process_line(self, line):
        pass

    def __exit__(self, exc_type, exc_val, exc_tb):
        pass

class LineChunker(Chunker):
    def __init__(self, item_class, line_count):
        self.acc = []
        self.item_class = item_class
        self.line_count = line_count

    def process_line(self, line):
        try:
            line = line.decode("utf-8").strip()
        except AttributeError as e:
            pass

        self.acc.append(line)

        if len(self.acc) == self.line_count:
            self.outputter.item(self.item_class(self.acc))
            self.acc = []

class FullReadChunker(Chunker):
    def __init__(self, item_class):
        self.acc = []
        self.item_class = item_class

    def process_line(self, line):
        self.acc.append(line)

    def __exit__(self, exc_type, exc_val, exc_tb):
        collected = "".join(self.acc)
        self.outputter.item(self.item_class(collected))

class JSONChunker(FullReadChunker):
    def __exit__(self, exc_type, exc_val, exc_tb):
        collected = b"".join(self.acc)
        for obj in json.loads(collected):
            self.outputter.item(self.item_class(obj))

def pipeline(*commands, chunker = None):
    async def run_pipeline(*commands, chunker):
        commands = [
                [shlex.quote(s) for s in command]
                for command in commands
                ]

        command = " | ".join([" ".join(a) for a in commands])

        process = await asyncio.create_subprocess_shell(
                command,
                stdin = asyncio.subprocess.DEVNULL,
                stdout = asyncio.subprocess.PIPE,
                )

        with JSONOutputter() as out, chunker:
            chunker.outputter = out

            while True:
                if process.stdout.at_eof():
                    break

                line = await process.stdout.readline()
                chunker.process_line(line)

        code = await process.wait()

    asyncio.run(run_pipeline(*commands, chunker = chunker))

if __name__ == "__main__":
    output = pipeline(sys.argv)
