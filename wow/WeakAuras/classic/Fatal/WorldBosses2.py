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


def oneround(xpos, ypos):
    sleep(urandom32(2, 6))
    click(xpos, ypos)
    sleep(urandom32(2, 6))
    shoot('p')


def relogin(xpos, ypos):
    sleep(urandom32(2, 6))
    click(xpos, ypos)
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
    sleep(14)
    try:
        relogin(1040, 655)
        relogin(485, 405)
        while True:
            for i in range(80):
                oneround(1040, 655)
                oneround(485, 405)
            relogin(1040, 655)
            relogin(485, 405)
    except KeyboardInterrupt:
        pass


if __name__ == '__main__':
    main()
