import subprocess

from libqtile import bar
from qtile_extras import widget
from qtile_extras.widget.decorations import PowerLineDecoration

from .colors import background, blue, foreground, primary, secondary
from .groups import groups
from .utils import launch

left_powerline = {"decorations": [PowerLineDecoration(path="arrow_left", size=12)]}
right_powerline = {"decorations": [PowerLineDecoration(path="arrow_right", size=12)]}

widget_defaults = {
    "foreground": foreground,
    "font": "sans, Symbols Nerd Font",
    "fontsize": 16,
    "padding": 3,
}
extension_defaults = widget_defaults.copy()


def non_ascii_label(g):
    return g.label and not ord(g.label[0]) < 1 << 8


default_margin = [8, 8, 0, 8]


def init_bar(screen: int):
    groupbox_defaults = {
        "highlight_method": "block",
        "margin_x": 0,
        "rounded": False,
        "other_current_screen_border": None,
        "other_screen_border": None,
        "this_current_screen_border": primary,
        "this_screen_border": secondary,
    }

    # batteries = (
    #     subprocess.run(["upower", "-e"], capture_output=True)
    #     .stdout.decode()
    #     .splitlines()
    # )

    return bar.Bar(
        [
            w
            for w in [
                widget.Spacer(
                    length=4,
                    background=primary,
                ),
                widget.TextBox(
                    text="\uf303",
                    fontsize=20,
                    background=primary,
                    foreground=background,
                    mouse_callbacks={
                        "Button1": launch,
                    },
                    **left_powerline,
                ),
                widget.CurrentLayout(
                    background=blue, foreground=background, **left_powerline
                ),
                widget.Spacer(length=8),
                widget.GroupBox(
                    **groupbox_defaults,
                    fontsize=20,
                    padding_x=1,
                    visible_groups=[g.name for g in groups if non_ascii_label(g)],
                ),
                widget.GroupBox(
                    **groupbox_defaults,
                    visible_groups=[g.name for g in groups if not non_ascii_label(g)],
                ),
                widget.Prompt(),
                widget.Spacer(),
                widget.WindowName(width=bar.CALCULATED, max_chars=80),
                widget.Spacer(),
                widget.Mpris2(
                    foreground=blue,
                    fontsize=16,
                    padding=12,
                    scroll=False,
                    paused_text="\uf04b",
                    playing_text="\uf04c",
                    display_metadata=[],
                    no_metadata_text="",
                ),
                widget.Mpris2(
                    foreground=blue,
                    width=150,
                    scroll_interval=0.05,
                    paused_text="{track}",
                ),
                # widget.Battery(hide_threshold=1)
                # if "/org/freedesktop/UPower/devices/battery_BAT0" in batteries
                # else None,
                widget.StatusNotifier(),
                widget.Spacer(length=1, **right_powerline),
                widget.TextBox(
                    text="󰌌", fontsize=20, background=blue, foreground=background
                ),
                widget.KeyboardLayout(
                    background=blue, foreground=background, **right_powerline
                ),
                widget.Clock(
                    background=secondary,
                    foreground=background,
                    format="%Y-%m-%d %a %I:%M %p",
                    **right_powerline,
                ),
                widget.QuickExit(
                    background=primary,
                    foreground=background,
                    default_text="\uf011",
                    countdown_format="{}",
                ),
                widget.Spacer(
                    background=primary,
                    length=4,
                ),
            ]
            if w is not None
        ],
        24,
        background=background + ".5",
        margin=default_margin,
    )
