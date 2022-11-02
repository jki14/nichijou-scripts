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
    sys.stdout.write('[%s] %s pressed\n' % (datetime.now().strftime('%Y-%m-%d %H:%M:%S'), key))
    sys.stdout.flush()


def oneround():
    sleep(urandom32(22, 44))
    shoot('enter')
    sleep(urandom32(22, 44))
    shoot('enter')


def relogin():
    xpos, ypos = 717, 532 
    if size() == (3440, 1440):
        xpos, ypos = 1720, 836
    sleep(urandom32(4, 14))
    press('esc')
    sleep(urandom32(4, 14))
    moveTo(xpos, ypos)
    sleep(urandom32(4, 14))
    click(xpos, ypos)
    sleep(urandom32(4, 14))
    click(xpos, ypos)
    sleep(urandom32(22, 44))
    press('enter')
    sleep(urandom32(22, 44))
    press('enter')
    sys.stdout.write('[%s] re-login\n' % (datetime.now().strftime('%Y-%m-%d %H:%M:%S')))
    sys.stdout.flush()


def main():
    try:
        relogin()
        while True:
            for i in range(14):
                oneround()
            relogin()
    except KeyboardInterrupt:
        pass


if __name__ == '__main__':
    main()
