#!/usr/bin/python2
from __future__ import print_function
import requests
import newspaper
import sys
import pprint

def err(x):
    print(x, file=sys.stderr)

def is_direct_link(x):
    return x.endswith("jpg") or x.endswith("jpeg") or x.endswith("png")

r = requests.get("http://www.reddit.com/r/wallpapers.json")
j = r.json()

for x in j["data"]["children"]:
    try:
        url = x["data"]["url"]
        if x['data']['is_self']:
            continue
        err(url)
        if url.startswith("http://imgur.com/"):
            imgur_id = url[len("http://imgur.com/"):]
            r = requests.get("http://api.imgur.com/2/image/{}.json".format(imgur_id))
            j = r.json()
            while "links" not in j:
                j = j["image"]
            url = j["links"]["original"]
            if is_direct_link(url):
                break
        else:
            if not is_direct_link(url):
                site = newspaper.Article(url)
                site.download()
                site.parse()
                url = site.top_image
            break

    except Exception as e:
        err(e)
        continue

assert is_direct_link(url), url
print(url)

