import pyautogui
from pyautogui import hotkey, pixel
from sys import stdout
from time import time as ts


def main():
    tic = ts()
    pixel(16, 16)
    tac = ts()
    stdout.write('pixel (PAUSE = %.6f): %.6f\n' % (pyautogui.PAUSE, tac - tic))
    tic = ts()
    hotkey('num0')
    tac = ts()
    stdout.write('hotkey (PAUSE = %.6f): %.6f\n' % (pyautogui.PAUSE, tac - tic))

    pyautogui.PAUSE = 0

    tic = ts()
    pixel(16, 16)
    tac = ts()
    stdout.write('pixel (PAUSE = %.6f): %.6f\n' % (pyautogui.PAUSE, tac - tic))
    tic = ts()
    hotkey('num0')
    tac = ts()
    stdout.write('hotkey (PAUSE = %.6f): %.6f\n' % (pyautogui.PAUSE, tac - tic))


if __name__ == '__main__':
    main()
