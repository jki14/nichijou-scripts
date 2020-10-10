import sys

from datetime import datetime
from keyboard import on_release_key
from pyautogui import press
from time import sleep


def w_callback(e):
    press('s')
    sys.stdout.write('[%s] W pro-stopped.\n' % 
                     datetime.now().strftime('%Y-%m-%d %H:%M:%S'))


def s_callback(e):
    press('w')
    sys.stdout.write('[%s] S pro-stopped.\n' % 
                     datetime.now().strftime('%Y-%m-%d %H:%M:%S'))


def a_callback(e):
    press('d')
    sys.stdout.write('[%s] A pro-stopped.\n' % 
                     datetime.now().strftime('%Y-%m-%d %H:%M:%S'))


def d_callback(e):
    press('a')
    sys.stdout.write('[%s] D pro-stopped.\n' % 
                     datetime.now().strftime('%Y-%m-%d %H:%M:%S'))


def main():
    on_release_key('w', w_callback)
    on_release_key('s', s_callback)
    on_release_key('a', a_callback)
    on_release_key('d', d_callback)
    try:
        while True:
            sleep(60)
    except KeyboardInterrupt:
        pass


if __name__ == '__main__':
    main()
