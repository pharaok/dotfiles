#!/usr/bin/env python3
import json
import re
import subprocess
import time

"""
{"WindowOpenedOrChanged":{"window":{"id":20,"title":"Mozilla Firefox","app_id":"firefox","pid":84522,"workspace_id":1,"is_focused":true,"is_floating":false,"is_urgent":false,"layout":{"pos_in_scrolling_layout":[3,1],"tile_size":[1520.0,908.0],"window_size":[1520,908],"tile_pos_in_workspace_view":null,"window_offset_in_tile":[0.0,0.0]}}}}
{"WindowOpenedOrChanged":{"window":{"id":20,"title":"Extension: (Bitwarden Password Manager) - — Mozilla Firefox","app_id":"firefox","pid":84522,"workspace_id":1,"is_focused":true,"is_floating":false,"is_urgent":false,"layout":{"pos_in_scrolling_layout":[3,1],"tile_size":[1520.0,908.0],"window_size":[1520,908],"tile_pos_in_workspace_view":null,"window_offset_in_tile":[0.0,0.0]}}}}
{"WindowOpenedOrChanged":{"window":{"id":20,"title":"Extension: (Bitwarden Password Manager) - Bitwarden — Mozilla Firefox","app_id":"firefox","pid":84522,"workspace_id":1,"is_focused":true,"is_floating":false,"is_urgent":false,"layout":{"pos_in_scrolling_layout":[3,1],"tile_size":[1520.0,908.0],"window_size":[1520,908],"tile_pos_in_workspace_view":null,"window_offset_in_tile":[0.0,0.0]}}}}
"""


def action(args: list[str], id: str):
    subprocess.run(
        [
            "niri",
            "msg",
            "action",
            *args,
            "--id",
            str(id),
        ]
    )


def bitwarden_action(win):
    id = win["id"]
    action(["move-window-to-floating"], id=id)
    action(["set-window-width", "400"], id=id)
    action(["set-window-height", "600"], id=id)
    time.sleep(0.1)
    action(["center-window"], id=win["id"])


WINDOW_RULES: list = [
    {
        "match": {
            "app_id": "^firefox$",
            "title": r"^Extension: \(Bitwarden Password Manager\)",
            "is_floating": False,
        },
        "action": bitwarden_action,
    },
]


def match(obj, rule):
    for key, value in rule.items():
        if isinstance(value, str):
            if not re.search(value, obj[key]):
                return False
        elif isinstance(value, dict):
            if key not in obj or not match(obj[key], value):
                return False
        else:
            if obj[key] != value:
                return False
    return True


def main():
    # Open niri event-stream
    proc = subprocess.Popen(
        [
            "niri",
            "msg",
            "--json",
            "event-stream",
        ],
        stdout=subprocess.PIPE,
        text=True,
    )

    for line in proc.stdout:
        try:
            event = json.loads(line)
        except json.JSONDecodeError:
            continue

        if "WindowOpenedOrChanged" not in event:
            continue

        win = event["WindowOpenedOrChanged"]["window"]
        if not win:
            continue

        for rule in WINDOW_RULES:
            if match(win, rule["match"]):
                print("matched", win)
                rule["action"](win)


if __name__ == "__main__":
    main()
