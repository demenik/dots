import ctypes
import json
import os
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


def send():
    try:
        with open(CSS_PATH) as f:
            css = f.read()
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
