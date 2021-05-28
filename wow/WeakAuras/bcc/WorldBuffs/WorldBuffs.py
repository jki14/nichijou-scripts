import sys

from datetime import datetime
from pyautogui import click, moveTo, pixel, press
from time import sleep


def distance2(lhs, rhs):
    foo = 0
    m = len(lhs)
    for i in range(m):
        foo += (lhs[i] - rhs[i]) ** 2
    return foo


def logout(xpos, ypos, dy = -370):
    press('esc')
    sleep(2)
    moveTo(xpos, ypos)
    sleep(2)
    click(xpos, ypos)


def login():
    press('enter')
    sys.stdout.write('[%s] login\n'
                     % (datetime.now().strftime('%Y-%m-%d %H:%M:%S')))
    sys.stdout.flush()


def check(tick):
    cords = [
        (0, 0, 0),          # 0
        (160, 105, 150)     # 1
    ]

    point = pixel(650, 310)
    eps, idx = min([(distance2(point, cords[i]), i) for i in range(len(cords))])
    if tick % 12 == 0 or idx == 1:
        sys.stdout.write('[%s] WorldBuffs index %d with %d epsilon.\n' % (
                         datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
                         idx, eps))
        sys.stdout.flush()
    if idx == 1:
        logout(1040, 655) 
        sys.exit(0)
    else:
        press('space')


def run():
    logout(1040, 655)
    sleep(10)
    login()
    sleep(30)
    for i in range(240):
        check(i)
        sleep(5)


def guard():
    while True:
        try:
            run()
            break
        except OSError:
            sys.stdout.write('[%s] OSError.\n' %
                             datetime.now().strftime('%Y-%m-%d %H:%M:%S'))
            sleep(1)
            pass


def main():
    sleep(4)
    while True:
        guard()


if __name__ == '__main__':
    main()
