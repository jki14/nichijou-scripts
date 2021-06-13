import os
import sys

from datetime import datetime
from pyautogui import click, moveTo, press, size
from time import sleep


def urandom32(low, hig):
    foo = os.urandom(4).hex()
    foo = int(foo, 16)
    foo %= hig - low + 1
    foo += low
    return foo


def shoot(key):
    press(key)
    sys.stdout.write('[%s] %s pressed\n'
                     % (datetime.now().strftime('%Y-%m-%d %H:%M:%S'), key))
    sys.stdout.flush()


def oneround():
    sleep(urandom32(2, 6))
    # shoot('space')
    shoot('p')
    sleep(urandom32(2, 6))
    shoot('p')
    # shoot('space')


def relogin():
    xpos, ypos = 1040, 655
    if size() == (3440, 1440):
        xpos, ypos = 1720, 805
    if size() == (2560, 1440):
        xpos, ypos = 1280, 840
    sleep(urandom32(2, 6))
    press('esc')
    sleep(urandom32(2, 6))
    moveTo(xpos, ypos)
    sleep(urandom32(2, 6))
    click(xpos, ypos)
    sleep(urandom32(2, 6))
    click(xpos, ypos)
    sleep(urandom32(24, 28))
    press('enter')
    sleep(urandom32(2, 6))
    press('enter')
    sys.stdout.write('[%s] re-login\n'
                     % (datetime.now().strftime('%Y-%m-%d %H:%M:%S')))
    sys.stdout.flush()


def main():
    try:
        relogin()
        while True:
            for i in range(150):
                oneround()
            relogin()
    except KeyboardInterrupt:
        pass


if __name__ == '__main__':
    main()
