import ctypes
import functools
import json
import math
import os
import random
import re
import select
import struct
import sys

CSS_PATH = "@cssPath@"

IN_CLOSE_WRITE = 0x08
IN_MOVED_TO = 0x80
EVENT = struct.Struct("iIII")

libc = ctypes.CDLL(None, use_errno=True)


def check(ret):
    if ret < 0:
        err = ctypes.get_errno()
        raise OSError(err, os.strerror(err))
    return ret


# CSS filters cannot take a var() color, so recoloring a black icon image
# needs a precomputed filter chain per color. Port of the SPSA search from
# https://codepen.io/sosuke/pen/Pjoqqp (MIT).


def clamp(v):
    return min(max(v, 0.0), 255.0)


def multiply(c, m):
    r, g, b = c
    return [
        clamp(r * m[0] + g * m[1] + b * m[2]),
        clamp(r * m[3] + g * m[4] + b * m[5]),
        clamp(r * m[6] + g * m[7] + b * m[8]),
    ]


def linear(c, slope, intercept=0.0):
    return [clamp(v * slope + intercept * 255) for v in c]


def apply_filters(f):
    c = [clamp(f[0] / 100 * 255)] * 3
    s = 1 - f[1] / 100
    c = multiply(c, [
        0.393 + 0.607 * s, 0.769 - 0.769 * s, 0.189 - 0.189 * s,
        0.349 - 0.349 * s, 0.686 + 0.314 * s, 0.168 - 0.168 * s,
        0.272 - 0.272 * s, 0.534 - 0.534 * s, 0.131 + 0.869 * s,
    ])
    v = f[2] / 100
    c = multiply(c, [
        0.213 + 0.787 * v, 0.715 - 0.715 * v, 0.072 - 0.072 * v,
        0.213 - 0.213 * v, 0.715 + 0.285 * v, 0.072 - 0.072 * v,
        0.213 - 0.213 * v, 0.715 - 0.715 * v, 0.072 + 0.928 * v,
    ])
    a = math.radians(f[3] * 3.6)
    cos, sin = math.cos(a), math.sin(a)
    c = multiply(c, [
        0.213 + cos * 0.787 - sin * 0.213, 0.715 - cos * 0.715 - sin * 0.715, 0.072 - cos * 0.072 + sin * 0.928,
        0.213 - cos * 0.213 + sin * 0.143, 0.715 + cos * 0.285 + sin * 0.140, 0.072 - cos * 0.072 - sin * 0.283,
        0.213 - cos * 0.213 - sin * 0.787, 0.715 - cos * 0.715 + sin * 0.715, 0.072 + cos * 0.928 + sin * 0.072,
    ])
    c = linear(c, f[4] / 100)
    return linear(c, f[5] / 100, 0.5 - f[5] / 200)


def hsl(c):
    r, g, b = (v / 255 for v in c)
    hi, lo = max(r, g, b), min(r, g, b)
    light = (hi + lo) / 2
    if hi == lo:
        return 0.0, 0.0, light * 100
    d = hi - lo
    sat = d / (2 - hi - lo) if light > 0.5 else d / (hi + lo)
    if hi == r:
        hue = (g - b) / d + (6 if g < b else 0)
    elif hi == g:
        hue = (b - r) / d + 2
    else:
        hue = (r - g) / d + 4
    return hue / 6 * 100, sat * 100, light * 100


def loss(f, target, target_hsl):
    c = apply_filters(f)
    return sum(abs(a - b) for a, b in zip(c, target)) + sum(
        abs(a - b) for a, b in zip(hsl(c), target_hsl)
    )


def fix(v, i):
    hi = 7500 if i == 2 else 200 if i in (4, 5) else 100
    if i == 3:
        return v % hi
    return min(max(v, 0.0), hi)


def spsa(rng, big_a, a, c, values, iters, target, target_hsl):
    values = list(values)
    best, best_loss = values, math.inf
    for k in range(iters):
        ck = c / (k + 1) ** (1 / 6)
        deltas = [1 if rng.random() > 0.5 else -1 for _ in range(6)]
        high = [v + ck * d for v, d in zip(values, deltas)]
        low = [v - ck * d for v, d in zip(values, deltas)]
        diff = loss(high, target, target_hsl) - loss(low, target, target_hsl)
        values = [
            fix(v - a[i] / (big_a + k + 1) * diff / (2 * ck) * deltas[i], i)
            for i, v in enumerate(values)
        ]
        cur = loss(values, target, target_hsl)
        if cur < best_loss:
            best, best_loss = list(values), cur
    return best, best_loss


@functools.cache
def css_filter(hex_color):
    target = [int(hex_color[i:i + 2], 16) for i in (1, 3, 5)]
    target_hsl = hsl(target)
    # Seeded, so an unchanged color always gets the same chain
    rng = random.Random(hex_color)
    best, best_loss = None, math.inf
    for _ in range(3):
        if best_loss <= 25:
            break
        vals, cur = spsa(rng, 5, [60, 180, 18000, 600, 1.2, 1.2], 15,
                         [50, 20, 3750, 50, 100, 100], 1000, target, target_hsl)
        if cur < best_loss:
            best, best_loss = vals, cur
    a1 = best_loss + 1
    best, _ = spsa(rng, best_loss, [0.25 * a1, 0.25 * a1, a1, 0.25 * a1, 0.2 * a1, 0.2 * a1],
                   2, best, 500, target, target_hsl)
    f = [round(v) for v in best]
    return (
        f"brightness(0) saturate(100%) invert({f[0]}%) sepia({f[1]}%) saturate({f[2]}%) "
        f"hue-rotate({round(best[3] * 3.6)}deg) brightness({f[4]}%) contrast({f[5]}%)"
    )


def with_filters(css):
    colors = re.findall(r"^\s*(--[\w-]+): (#[0-9a-fA-F]{6});", css, re.M)
    lines = "".join(f"  {name}-filter: {css_filter(value.lower())};\n" for name, value in colors)
    return css + ":root {\n" + lines + "}\n"


def send():
    try:
        with open(CSS_PATH) as f:
            css = with_filters(f.read())
    except OSError:
        return
    msg = json.dumps({"css": css}).encode()
    sys.stdout.buffer.write(struct.pack("@I", len(msg)) + msg)
    sys.stdout.buffer.flush()


def touches_target(buf, name):
    offset = 0
    while offset < len(buf):
        _, _, _, length = EVENT.unpack_from(buf, offset)
        start = offset + EVENT.size
        if buf[start : start + length].rstrip(b"\0") == name:
            return True
        offset = start + length
    return False


directory, name = os.path.split(CSS_PATH)
os.makedirs(directory, exist_ok=True)

# Watch the directory, so atomic replaces (rename over the file) are seen too
inotify = check(libc.inotify_init1(os.O_CLOEXEC))
check(libc.inotify_add_watch(inotify, directory.encode(), IN_CLOSE_WRITE | IN_MOVED_TO))

send()

while True:
    ready, _, _ = select.select([0, inotify], [], [])
    # The browser closes stdin when the extension disconnects
    if 0 in ready and not os.read(0, 4096):
        break
    if inotify in ready and touches_target(os.read(inotify, 4096), name.encode()):
        send()
