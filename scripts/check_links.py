#!/usr/bin/env python3
"""Check internal links, images and #anchors in the built site (run after 'zensical build')."""
import os
import re
import sys
import urllib.parse

site = sys.argv[1] if len(sys.argv) > 1 else "site"
bad = 0
for root, _, files in os.walk(site):
    for f in files:
        # 404.html uses absolute paths on purpose
        if not f.endswith(".html") or f == "404.html":
            continue
        page = os.path.join(root, f)
        html = open(page, encoding="utf-8").read()
        for url in re.findall(r'(?:href|src)="([^"?]+)"', html):
            if re.match(r"^[a-z]+:|^//", url):
                continue
            path, _, frag = url.partition("#")
            target = os.path.normpath(os.path.join(root, urllib.parse.unquote(path))) if path else page
            if not (target.endswith(".html") or os.path.isfile(target)):
                target = os.path.join(target, "index.html")
            if not os.path.exists(target):
                bad += 1
                print(f"missing  {page}: {url}")
            elif frag and target.endswith(".html"):
                ids = set(re.findall(r'id="([^"]+)"', open(target, encoding="utf-8").read()))
                if frag not in ids:
                    bad += 1
                    print(f"anchor   {page}: {url}")
print(f"{bad} broken link(s)")
sys.exit(1 if bad else 0)
