# -*- coding: utf-8 -*-
import os
import sys

class win:
  batch = None
  @staticmethod
  def symlink(src, dst):
    if not win.batch:
      win.batch = open('symbolic.cmd', 'w')
      win.batch.write('@ECHO OFF\n')
    win.batch.write('MKLINK /J %s %s\n' % (dst, src))

def accounts():
  prefix = os.path.join('WTF', 'Account')
  foo = os.path.join(prefix, '150998550#2')
  bar = ['150998550#1']
  for path in [os.path.join(prefix, e) for e in bar]:
    if sys.platform.startswith('win'):
      win.symlink(foo, path)
    os.symlink(foo, path)

def characters():
  prefix = os.path.join('WTF', 'Account', '150998550#2')
  foo = os.path.join(prefix, '比格沃斯', '依然活着')
  bar = [
    '比格沃斯 - 仍然活着'
  ]
  for path in [os.path.join(prefix, *c.split(' - ')) for c in bar]:
    if sys.platform.startswith('win'):
      win.symlink(foo, path)
    os.symlink(foo, path)
 
def main():
  accounts()
  characters()
  if win.batch:
    win.batch.write('PAUSE')
    win.batch.close()

if __name__ == '__main__':
  main()
