import os
import subprocess


def get_volume(index):
    muted = (
        subprocess.Popen(["pactl", "get-sink-mute", index], stdout=subprocess.PIPE)
        .stdout.read()
        .decode("utf8")
    )
    muted = "yes" in muted
    volume = (
        subprocess.Popen(["pactl", "get-sink-volume", index], stdout=subprocess.PIPE)
        .stdout.read()
        .decode("utf8")
    )
    volume = [s for s in volume.split(" ") if s]
    return muted, int(volume[4][:-1])


def get_icon(muted, volume):
    if muted:
        return "muted"
    if volume <= 33:
        return "low"
    elif volume <= 66:
        return "medium"
    else:
        return "high"


default_sink = (
    subprocess.Popen(["pactl", "get-default-sink"], stdout=subprocess.PIPE)
    .stdout.read()
    .decode("utf8")
    .strip()
)

sinks = (
    subprocess.Popen(["pactl", "list", "sinks", "short"], stdout=subprocess.PIPE)
    .stdout.read()
    .decode("utf8")
)


default_sink_index = None
for sink in sinks.splitlines():
    sink = sink.split("\t")
    if sink[1] == default_sink:
        default_sink_index = sink[0]
        break
default_sink_index = default_sink_index

pactl = subprocess.Popen(["pactl", "subscribe"], stdout=subprocess.PIPE)

prev_volume = None
id = 5001

while True:
    try:
        line = pactl.stdout.readline().decode("utf8").strip()
        if line != f"Event 'change' on sink #{default_sink_index}":
            continue
        muted, volume = get_volume(default_sink_index)
        if volume != prev_volume:
            subprocess.Popen(
                [
                    "dunstify",
                    "-u",
                    "0",
                    "-r",
                    str(id),
                    "-t",
                    "1000",
                    "-i",
                    f"audio-volume-{get_icon(muted, volume)}-symbolic",
                    f"Volume: {volume}%",
                    "-h",
                    f"int:value:{volume}",
                ],
                stdout=subprocess.PIPE,
            )

            prev_volume = volume
    except EOFError:
        break
