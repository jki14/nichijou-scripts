# -*- coding: utf-8 -*-

import os
import sys


def dropfiles(prefix):
    foo = []
    for path in [os.path.join(prefix, sub) for sub in os.listdir(prefix)]:
        if os.path.isdir(path):
            foo += dropfiles(path)
        if len(path) > 5 and path[-4:] == '.mp4' and path[-6:-4] != '~1':
            foo.append(path)
    return foo


def main():
    foo = dropfiles('.')
    for path in foo:
        if os.path.isfile(path[:-4] + '~1' + path[-4:]):
            sys.stdout.write('drop: %s\n' % path)
            os.unlink(path)


if __name__ == '__main__':
    main()
