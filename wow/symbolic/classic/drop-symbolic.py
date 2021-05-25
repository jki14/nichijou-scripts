# -*- coding: utf-8 -*-
import os
import sys


def drop(prefix):
  for path in [os.path.join(prefix, sub) for sub in os.listdir(prefix)]:
    if os.path.islink(path):
      sys.stderr.write('islink %s\n' % path)
      os.unlink(path)


def accounts():
  prefix = os.path.join('WTF', 'Account')
  drop(prefix)


def characters():
  prefix = os.path.join('WTF', 'Account', '150998550#2')
  for path in [os.path.join(prefix, sub) for sub in os.listdir(prefix)]:
    if os.path.isdir(path):
      drop(path)

 
def main():
  accounts()
  characters()


if __name__ == '__main__':
  main()
