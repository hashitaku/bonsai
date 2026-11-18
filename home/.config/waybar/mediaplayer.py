#!/usr/bin/env python3
import subprocess
import json
import sys


def run(args):
    try:
        return subprocess.check_output(args, text=True).strip()
    except subprocess.CalledProcessError:
        return ""


status = run(["playerctl", "status"])
if not status or status == "Stopped":
    print(json.dumps({"text": "", "alt": "stopped", "class": "stopped"}))
    sys.exit(0)

artist = run(["playerctl", "metadata", "artist"])
title = run(["playerctl", "metadata", "title"])
player = run(["playerctl", "-l"]).split("\n")[0].lower()

text = f"{artist} - {title}" if artist else title
alt = "spotify" if "spotify" in player else "default"
css_class = f"custom-{alt}"
state_icon = "▶" if status == "Playing" else "⏸"

print(json.dumps({
    "text": f"{state_icon} {text}",
    "alt": alt,
    "class": css_class,
    "tooltip": f"{player}: {text}"
}))
