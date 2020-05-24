import os
import sys

from pyautogui import press
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


def main():
    try:
        while True:
            oneround()
    except KeyboardInterrupt:
        pass


if __name__ == '__main__':
    main()
