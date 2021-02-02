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


def accounts(prefix, foo, bar):
  for path in [os.path.join(prefix, e) for e in bar]:
    if sys.platform.startswith('win'):
      win.symlink(foo, path)
    else:
      os.symlink(foo, path)


def characters(prefix, foo, bar):
  for path in [os.path.join(prefix, *c.split(' - ')) for c in bar]:
    if sys.platform.startswith('win'):
      win.symlink(foo, path)
    else:
      os.symlink(foo, path)
 

def main():
  accounts(os.path.join('WTF', 'Account'),
           os.path.join('WTF', 'Account', '150998550#2'),
           ['150998550#1',
            '602893969#1',
            '150713399#1',
            '555095699#1',
            '153384600#1'])
  characters(os.path.join('WTF', 'Account', '150998550#2'),
             os.path.join('WTF',
                          'Account',
                          '150998550#2',
                          '比格沃斯',
                          '依然活着'),
             ['比格沃斯 - 仍然活着',
              '比格沃斯 - 筱狐狸',
              '比格沃斯 - 八六' ])
  characters(os.path.join('WTF', 'Account', '150998550#2'),
             os.path.join('WTF',
                          'Account',
                          '150998550#2',
                          '比格沃斯',
                          '兩儀未那'),
             ['比格沃斯 - 寒冰贼' ])
  characters(os.path.join('WTF', 'Account', '150998550#2'),
             os.path.join('WTF',
                          'Account',
                          '150998550#2',
                          '比格沃斯',
                          'Pekorinu'),
             ['比格沃斯 - 意大力炮' ])

  if win.batch:
    win.batch.write('PAUSE')
    win.batch.close()


if __name__ == '__main__':
  main()
