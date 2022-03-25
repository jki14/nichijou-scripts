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
        (0, 0, 0),      # 0
        (255, 0, 0),    # 1
        (0, 255, 0),    # 2
        (255, 255, 0),  # 3
        (0, 0, 255),    # 4
        (255, 0, 255),  # 5
        (0, 255, 255),  # 6
        (255, 255, 255),# 7
        (255, 85, 255), # 8
        (255, 170, 255),# 9
        (170, 170, 170),# A
    ]

    keys = [
        (),                     # 0
        ('1'),                  # 1
        ('2'),                  # 2
        ('4'),                  # 3
        ('e'),                  # 4
        ('3'),                  # 5
        ('alt', 'shift', 'h'),  # 6
        ('c'),                  # 7
        ('alt', '3'),           # 8
        ('alt', '2'),           # 9
        ('t'),                  # A
    ]

    point = pixel(16, 16)
    eps, idx = min([(distance2(point, cords[i]), i) for i in range(len(cords))])

    if eps > 0:
        sys.stdout.write('[%s] cheating paused index %d with %d epsilon.\n' % (
                         datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
                         idx, eps))
        wait('num 0')
        sys.stdout.write('[%s] cheating continue.\n' % (
                         datetime.now().strftime('%Y-%m-%d %H:%M:%S')))
        sleep(0.030)
        return False

    if idx != 0:
        hotkey(*keys[idx])
        sys.stdout.write('[%s] Feral index %d with %d epsilon.\n' % (
                         datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
                         idx, eps))
        sleep(0.100)
    sleep(0.030)


def guard():
    while True:
        try:
            run()
        except OSError:
            sys.stdout.write('[%s] OSError.\n' %
                             datetime.now().strftime('%Y-%m-%d %H:%M:%S'))
            sleep(0.030)
            pass


def main():
    while True:
        guard()


if __name__ == '__main__':
    main()
