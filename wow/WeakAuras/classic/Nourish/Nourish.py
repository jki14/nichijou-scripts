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
        (255, 124, 10)      # 1
    ]

    wait('shift+3')
    point = pixel(64, 64)
    eps, idx = min([(distance2(point, cords[i]), i) for i in range(len(cords))])
    if idx != 0:
        press('k')
    sleep(0.010)
    hotkey('ctrl', 'f4')
    sys.stdout.write('[%s] PreHeal index %d with %d epsilon.\n' % (
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
