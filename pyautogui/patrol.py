import os

import pyautogui
pyautogui.FAILSAFE = False

from pyautogui import easeInOutQuad, moveTo
from sys import argv
from time import sleep, time


def urandom32(low, hig):
    foo = os.urandom(4).hex()
    foo = int(foo, 16)
    foo %= hig - low + 1
    foo += low
    return foo


def oneround():
    p, q = (14, 21), (1024, 768)
    moveTo(p[0], p[1], 2, easeInOutQuad)
    sleep(urandom32(12, 18))
    moveTo(q[0], q[1], 2, easeInOutQuad)
    sleep(urandom32(12, 18))


def main():
    ttl = int(argv[1]) if len(argv) > 1 else None
    t0 = time()
    try:
        while True:
            oneround()
            if ttl and time() - t0 > ttl:
                break
    except KeyboardInterrupt:
        pass


if __name__ == '__main__':
    main()
