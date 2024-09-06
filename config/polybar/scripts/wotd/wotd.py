#!/usr/bin/env python3
# pylint: disable=C0103,C0116

"""Simple script to show a random word of the day"""

import os
import random
import json

WORDLIST = "/home/rec1dite/media/lists/wordlist3"
NUM_CACHE_WORDS = 10

def getWord():
    cache_file = os.path.dirname(os.path.realpath(__file__)) + os.sep + "cache.json"

    # Cache stores the most recent N words displayed
    cache = None

    # Create cache if non-existant
    if not os.path.exists(cache_file):
        with open(cache_file, "w", encoding="utf-8") as f:
            f.write(json.dumps({}))
        cache = {}
    else:
        with open(cache_file, "r", encoding="utf-8") as f:
            cache = json.loads(f.read())

    # Find latest word
    if os.path.exists(WORDLIST):
        with open(WORDLIST, "r", encoding="utf-8") as f:
            # Get file length
            f.seek(0, os.SEEK_END)
            file_size = f.tell()

            # Get a random word
            f.seek(0, os.SEEK_SET)
            f.seek(random.randint(0, file_size))
            f.readline()
            [word, definition] = f.readline().strip().split("#")[0:2]

            return word, definition


if __name__ == "__main__":
    w, d = getWord()
    print(f"{w}: {d}")