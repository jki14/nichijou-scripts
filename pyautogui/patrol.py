import os

from pyautogui import FAILSAFE, easeInOutQuad, moveTo
from time import sleep


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
    FAILSAFE = False
    try:
        while True:
            oneround()
    except KeyboardInterrupt:
        pass


if __name__ == '__main__':
    main()
