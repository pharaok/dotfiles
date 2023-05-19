import os
from typing import Dict, List

from libqtile.config import Key
from libqtile.lazy import lazy

from modules.utils import (
    LayoutToggler,
    dict_to_options,
    flameshot_capture_window,
    launch,
    Options,
    Direction,
    lazy_move,
    lazy_grow,
    lazy_shuffle
)

mod = "mod4"

terminal = "wezterm"

max_layout_toggler = LayoutToggler("max")

flameshot_defaults: Options = {
    "--clipboard": True,
    "--path": os.path.expanduser("~/Pictures/screenshots/"),
}

flameshot_options = dict_to_options(flameshot_defaults)

directions: Dict[Direction, List[str]] = {
    "left": ["Left", "h"],
    "right": ["Right", "l"],
    "down": ["Down", "j"],
    "up": ["Up", "k"],
}


keys = [
    Key(
        [mod],
        "space",
        launch,
        desc="Spawn rofi",
    ),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    # Key(["control", "mod1"], "t", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Next layout"),
    Key([mod, "shift"], "Tab", lazy.prev_layout(), desc="Previous layout"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key(
        [],
        "F11",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on focused window",
    ),
    Key(
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on focused window",
    ),
    Key(
        [mod],
        "s",
        lazy.window.toggle_floating(),
        desc="Toggle floating on focused window",
    ),
    Key(
        [mod],
        "m",
        lazy.function(max_layout_toggler.toggle_max),
        desc="Toggle Max layout",
    ),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key(
        ["control", "mod1"],
        "l",
        lazy.spawn(
            f"{terminal} -e nvim {os.path.expanduser('~/.local/share/qtile/qtile.log')}"
        ),
        desc="Open log file",
    ),
    Key(
        ["control", "mod1"],
        "c",
        lazy.spawn(
            f"{terminal} -e nvim {os.path.expanduser('~/.config/qtile/')}"),
        desc="Open log file",
    ),
    Key([mod], "r", lazy.spawncmd(),
        desc="Spawn a command using a prompt widget"),
    # Multimedia
    Key(
        [],
        "XF86AudioPrev",
        lazy.spawn("playerctl previous"),
        desc="Previous track",
    ),
    Key(
        [],
        "XF86AudioPlay",
        lazy.spawn("playerctl play-pause"),
        desc="Play/Pause",
    ),
    Key(
        [],
        "XF86AudioNext",
        lazy.spawn("playerctl next"),
        desc="Next track",
    ),
]

keys.extend(
    [
        Key(
            [],
            "Print",
            lazy.spawn(" ".join(["flameshot", "full", flameshot_options])),
            desc="Take screenshot of all screens with flameshot.",
        ),
        Key(
            [mod],
            "Print",
            lazy.spawn(
                " ".join(["flameshot", "screen", flameshot_options])),
            desc="Take screenshot of the current screen with flameshot.",
        ),
        Key(
            ["shift"],
            "Print",
            lazy.spawn(" ".join(["flameshot", "gui", flameshot_options])),
            desc="Take screenshot of a region with flameshot.",
        ),
        Key(
            ["control"],
            "Print",
            flameshot_capture_window(flameshot_defaults),
            desc="Take screenshot of the current window with flameshot.",
        ),
    ]
)

keys.extend(
    [
        Key(
            ["mod4" if mod == "mod1" else "mod1"],
            str(1 + n),
            lazy.to_screen(n),
            desc=f"Focus screen {n}",
        )
        for n in range(3)
    ]
)

for direction, ks in directions.items():
    for k in ks:
        keys.extend(
            [
                Key(
                    [mod],
                    k,
                    lazy_move(direction),
                    desc=f"Move focus {direction}",
                ),
                Key(
                    [mod, "shift"],
                    k,
                    lazy_shuffle(direction),
                    desc=f"Move window {direction}",
                ),
                Key(
                    [mod, "control"],
                    k,
                    lazy_grow(direction),
                    desc=f"Grow window {direction}",
                ),
            ]
        )
