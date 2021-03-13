#! /usr/bin/python3

import os
import sys
import pathlib

import requests_cache
import requests

import alfred
import url_item

requests_cache.install_cache('pinboard')

params = {
        'auth_token': 'sfriedenberg:5F7D314712F8E4A33654',
        'format': 'json',
        }

r = requests.get('https://api.pinboard.in/v1/posts/all', params)

with alfred.JSONOutputter() as out:
    for url_obj in r.json():
        out.item(
                url_item.Item(
                    url_obj['description'],
                    url_obj['href'],
                    url_obj['extended'],
                    url_obj['tags'],
                    )
                )
