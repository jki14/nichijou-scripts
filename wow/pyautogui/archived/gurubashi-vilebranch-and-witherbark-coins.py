import os
import sys

from datetime import datetime
from pyautogui import moveTo, click
from time import sleep


def urandom32(low, hig):
    foo = os.urandom(4).hex()
    foo = int(foo, 16)
    foo %= hig - low + 1
    foo += low
    return foo


def shoot():
    sleep(urandom32(16, 32) * 0.01)
    moveTo(220, 485)
    sleep(urandom32(16, 32) * 0.01)
    click(220, 485)
    sleep(urandom32(16, 32) * 0.05)
    moveTo(100, 700)
    sleep(urandom32(16, 32) * 0.01)
    click(100, 700)
    sleep(urandom32(16, 32) * 0.05)
    click(100, 700)
    sleep(urandom32(16, 32) * 0.05)


def main():
    try:
        while True:
            shoot()
    except KeyboardInterrupt:
        pass


if __name__ == '__main__':
    main()
