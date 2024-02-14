import cv2
import os

BASE_DIR = '/Users/zwwn/Pictures/candidates'

def get_prev(i, f):
    c = i - 1
    while c >= 0 and f.get(c):
        c = c - 1
    if c >= 0 and not f.get(c):
        return c
    return i


def get_next(i, n, f):
    c = i + 1
    while c < n and f.get(c):
        c = c + 1
    if c < n and not f.get(c):
        return c
    return i


def display(fp):
    img = cv2.imread(fp)
    cv2.imshow('cursor', img)
    return cv2.waitKey(0)


def main():
    foo = sorted(os.listdir(BASE_DIR))
    bar = []
    flg = {}

    n = len(foo)
    i = 0

    while True:
        key = display(os.path.join(BASE_DIR, foo[i]))
        if key == 2: # LEFT
            i = get_prev(i, flg)
        elif key == 3: # RIGHT
            i = get_next(i, n, flg)
        elif key == 0: # UP
            if bar:
                i = bar.pop()
                flg[i] = None
        elif key == 1: # DOWN
            bar.append(i)
            i = get_next(i, n, flg)
            if i == bar[-1]:
                i = get_prev(i, flg)
            flg[bar[-1]] = True
        elif key == 27: # ESC
            cv2.destroyAllWindows()
            break
    for i in bar:
        os.rename(os.path.join(BASE_DIR, foo[i]), os.path.join(BASE_DIR, '_' + foo[i]))


if __name__ == '__main__':
    main()
