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


def run():
    cords = [
        (0, 0, 0),          # 0
        (113, 159, 207),    # 1
        (154, 226, 52),     # 2
        (173, 127, 168),    # 3
        (238, 238, 238),    # 4
        (52, 226, 226),     # 5
        (85, 87, 83)        # 6
    ]

    point = pixel(16, 16)
    eps, idx = min([(distance2(point, cords[i]), i) for i in range(len(cords))])
    if idx == 1:
        press('g')
    elif idx == 2:
        press('h')
    elif idx == 3:
        press('t')
    elif idx == 4:
        hotkey('alt', ']')
    elif idx == 5:
        hotkey('alt', '[')
    elif idx == 6:
        hotkey('alt', 'shift', '3')
    sys.stdout.write('[%s] Nourish index %d with %d epsilon.\n' % (
                     datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
                     idx, eps))
    sleep(0.100)


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
