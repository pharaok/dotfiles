from libqtile import qtile, hook
from libqtile.config import Screen
from libqtile.log_utils import logger

from .bar import default_margin, init_bar
from .colors import background


@hook.subscribe.layout_change
def layout_change(layout, group):
    if layout.name == "max":
        margin = [0, 0, 0, 0]
        bg = background
    else:
        margin = default_margin
        bg = background + ".5"

    try:
        bar = qtile.current_screen.top
    except AttributeError:
        return

    if bar is None:
        return

    bar._initial_margin = margin
    bar.background = bg
    bar._configure(qtile, qtile.current_screen, reconfigure=True)
    bar.draw()


def init_screens():
    return [
        Screen(
            wallpaper="~/.config/qtile/wallpaper.jpg",
            wallpaper_mode="fill",
            top=init_bar(i),
        )
        for i in range(3)
    ]
