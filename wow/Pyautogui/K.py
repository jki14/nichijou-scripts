import os
import sys

from datetime import datetime
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
    # sys.stdout.write('[%s] %s pressed\n'
    #                  % (datetime.now().strftime('%Y-%m-%d %H:%M:%S'), key))
    # sys.stdout.flush()


def main():
    try:
        while True:
            sleep(urandom32(16, 32) * 1.0)
            shoot('space')
            sleep(urandom32(16, 32) * 1.0)
            shoot('enter')
    except KeyboardInterrupt:
        pass


if __name__ == '__main__':
    main()
