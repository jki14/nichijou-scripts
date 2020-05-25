import os
import sys

from pyautogui import click, moveTo, press
from time import sleep


def urandom32(low, hig):
    foo = os.urandom(4).hex()
    foo = int(foo, 16)
    foo %= hig - low + 1
    foo += low
    return foo


def shoot(key):
    press(key)
    sys.stdout.write('%s pressed\n' % key)
    sys.stdout.flush()


def oneround():
    sleep(urandom32(8, 16))
    shoot('space')
    sleep(urandom32(8, 16))
    shoot('p')


def relogin():
    sleep(urandom32(4, 8))
    press('esc')
    sleep(urandom32(4, 8))
    moveTo(720, 525)
    sleep(urandom32(4, 8))
    click(720, 525)
    sleep(urandom32(4, 8))
    click(720, 525)
    sleep(urandom32(32, 48))
    press('enter')
    sleep(urandom32(4, 8))
    press('enter')
    sys.stdout.write('re-login\n')
    sys.stdout.flush()


def main():
    try:
        while True:
            for i in range(50):
                oneround()
            relogin()
    except KeyboardInterrupt:
        pass


if __name__ == '__main__':
    main()
