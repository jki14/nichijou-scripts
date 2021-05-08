import sys

from datetime import datetime
from keyboard import wait
from pyautogui import pixel, press, hotkey
from time import sleep


def distance2(lhs, rhs):
    foo = 0
    m = len(lhs)
    for i in range(m):
        foo += (lhs[i] - rhs[i]) ** 2
    return foo


def halt_touch():
    cords = [
        (0, 0, 0),          # 0
        (173, 127, 168)     # 1
    ]
    point = pixel(16, 64)
    eps, idx = min([(distance2(point, cords[i]), i) for i in range(len(cords))])
    if idx == 1:
        press('k')
    sys.stdout.write('[%s] Halt Regrowth index %d with %d epsilon.\n' % (
                     datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
                     idx, eps))


def run():
    cords = [
        (0, 0, 0),          # 0
        (9, 28, 85),        # 1
        (19, 57, 170),      # 2
        (28, 85, 0),        # 3
        (38, 113, 85),      # 4
        (47, 142, 170),     # 5
        (57, 170, 0),       # 6
        (66, 198, 85),      # 7
        (76, 227, 170),     # 8
        (85, 0, 0),         # 9
        (94, 28, 85),       # 10
        (104, 57, 170)      # 11
    ]

    wait('ctrl+e')
    halt_touch()
    point = pixel(64, 64)
    eps, idx = min([(distance2(point, cords[i]), i) for i in range(len(cords))])
    if idx != 0:
        hotkey('alt', 'f%d' % (4 + idx))
    sys.stdout.write('[%s] Regrowth index %d with %d epsilon.\n' % (
                     datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
                     idx, eps))
    sleep(0.010)


def guard():
    while True:
        try:
            run()
            break
        except OSError:
            sys.stdout.write('[%s] OSError.\n' %
                             datetime.now().strftime('%Y-%m-%d %H:%M:%S'))
            sleep(0.010)
            pass


def main():
    while True:
        guard()


if __name__ == '__main__':
    main()
