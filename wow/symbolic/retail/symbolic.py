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
  foo = os.path.join(prefix, '83215426#1')
  bar = ['150998550#1', '150998550#2', '223607616#1', '223607616#2', 'WOW_TAB']
  for path in [os.path.join(prefix, e) for e in bar]:
    if sys.platform.startswith('win'):
      win.symlink(foo, path)
    else:
      os.symlink(foo, path)

def characters():
  prefix = os.path.join('WTF', 'Account', '83215426#1')
  foo = os.path.join(prefix, 'Tichondrius', 'Masoshonen')
  bar = [
    'Tichondrius - Morgiane', 'Tichondrius - Morgianu',
    '熊猫酒仙 - 魔装少年', '凤凰之神 - 依然活著', '凤凰之神 - 仍然活著',
  ]
  for path in [os.path.join(prefix, *c.split(' - ')) for c in bar]:
    if sys.platform.startswith('win'):
      win.symlink(foo, path)
    else:
      os.symlink(foo, path)
 
def main():
  accounts()
  characters()
  if win.batch:
    win.batch.write('PAUSE')
    win.batch.close()

if __name__ == '__main__':
  main()
