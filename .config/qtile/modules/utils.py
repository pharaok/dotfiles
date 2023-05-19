import datetime
import os
from collections import defaultdict
from shlex import quote
from typing import Literal, Mapping

from libqtile import hook
from libqtile.core.manager import Qtile
from libqtile.lazy import lazy
from libqtile.log_utils import logger

Options = Mapping[str, str | bool]


def dict_to_options(options: Options):
    return " ".join(
        k + (" " + v if isinstance(v, str) else "")
        for k, v in options.items()
        if not isinstance(v, bool) or v
    )


class LayoutToggler:
    def __init__(self, layout):
        self.layout = layout
        self.toggle_state = {}

    def toggle_max(self, qtile: Qtile):
        group = qtile.current_group
        if group.layout.name == self.layout and group.name in self.toggle_state:
            group.cmd_setlayout(self.toggle_state[group.name])
            self.toggle_state.pop(group.name)
        else:
            self.toggle_state[group.name] = group.layout.name
            group.cmd_setlayout(self.layout)


class WindowMatcher:
    def __init__(self, name, group):
        self.name = name
        self.group = group
        self.rename_count = defaultdict(int)

        hook.subscribe.client_name_updated(self.client_name_updated)
        hook.subscribe.client_killed(self.client_killed)

    def client_name_updated(self, client):
        if self.rename_count[client.wid] > 1:
            return

        self.rename_count[client.wid] += 1

        if client.name == self.name:
            client.cmd_togroup(self.group)

    def client_killed(self, client):
        if client.wid in self.rename_count:
            self.rename_count.pop(client.wid)


@lazy.function
def launch(qtile: Qtile):
    qtile.cmd_spawn("rofi -mode run,drun -show drun")


@lazy.function
def flameshot_capture_window(qtile: Qtile, defaults: Options):
    window = qtile.current_window
    if not window:
        return

    found, border_width = qtile.current_layout._find_default("border_width")
    if not found:
        logger.warning("Failed to get layout border width.")
        border_width = 0
    x, y = [n + border_width for n in window.cmd_get_position()]
    w, h = window.cmd_get_size()

    options = dict(defaults)

    now = datetime.datetime.now().strftime("%Y-%m-%d_%H-%M")
    path = f"~/Pictures/screenshots/{now}_{window.name}.png"
    options.update(
        {
            "--region": f"{w}x{h}+{x}+{y}",
            "--path": quote(os.path.expanduser(path)),
        }
    )

    qtile.cmd_spawn(" ".join(["flameshot", "full", dict_to_options(options)]))


Direction = Literal["left", "right", "down", "up"]


def rotate_cw(direction: Direction):
    if direction == "up":
        return "right"
    elif direction == "right":
        return "down"
    elif direction == "down":
        return "left"
    else:
        return "up"


def flip(direction: Direction):
    return rotate_cw(rotate_cw(direction))


def rotate_ccw(direction: Direction):
    return flip(rotate_cw(direction))


def lazy_move(direction: Direction):
    return getattr(lazy.layout, direction)()


@lazy.function
def lazy_shuffle(qtile, direction: Direction):
    if (
        qtile.current_layout.name in ["monadtall", "monadwide"]
        and qtile.current_layout.clients.current_index == 0
    ):
        main_direction = "right"
        if qtile.current_layout.name == "monadwide":
            main_direction = rotate_cw(main_direction)
        if qtile.current_layout.align == 1:
            main_direction = flip(main_direction)

        if direction == main_direction:
            qtile.current_layout.cmd_flip()
            return

    getattr(qtile.current_layout, f"cmd_shuffle_{direction}")()


@lazy.function
def lazy_grow(qtile, direction: Direction):
    if qtile.current_layout.name in ["monadtall", "monadwide"]:
        if qtile.current_layout.name == "monadwide":
            direction = rotate_ccw(direction)

        if (qtile.current_layout.align == 0) == (
            qtile.current_layout.clients.current_index == 0
        ):
            direction = flip(direction)

        if direction == "right":
            qtile.current_layout.cmd_grow_main()
        elif direction == "left":
            qtile.current_layout.cmd_shrink_main()
        elif direction == "up":
            qtile.current_layout.cmd_grow()
        else:
            qtile.current_layout.cmd_shrink()
