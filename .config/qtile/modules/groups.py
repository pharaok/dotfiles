from libqtile.config import DropDown, Group, Key, Match, Rule, ScratchPad
from libqtile.lazy import lazy

from modules.keys import keys, mod, terminal
from modules.utils import WindowMatcher

key_groups = {str(i): Group(i) for i in "123456789"}
key_groups.update(
    {
        "1": Group("Terminal", label="\ue795"),
        "2": Group("Browser", label="\U000F0239"),
        "3": Group(
            "Music",
            label="\uf1bc",
        ),
    }
)


WindowMatcher("Spotify", "Music")

for k, group in key_groups.items():
    keys.extend(
        [
            Key(
                [mod],
                k,
                lazy.group[group.name].toscreen(),
                desc=f"Switch to group {group.name}",
            ),
            Key(
                [mod, "shift"],
                k,
                lazy.window.togroup(group.name),
                desc="Move focused window to group {}".format(group.name),
            ),
        ]
    )

groups = list(key_groups.values())

dropdown_defualts = {"x": 0.1, "y": 0.1, "width": 0.8, "height": 0.8}

dropdowns = {
    (("control", "mod1"), "t"): DropDown(
        "term", "wezterm start --always-new-process", **dropdown_defualts
    ),
    ((mod,), "e"): DropDown(
        "vifm", "wezterm start --always-new-process vifm", **dropdown_defualts
    ),
    (("control", "shift"), "escape"): DropDown(
        "htop", "wezterm start --always-new-process htop", **dropdown_defualts
    ),
}
groups.append(ScratchPad("scratchpad", list(dropdowns.values())))

for (mods, key), dd in dropdowns.items():
    keys.append(Key(list(mods), key, lazy.group["scratchpad"].dropdown_toggle(dd.name)))
