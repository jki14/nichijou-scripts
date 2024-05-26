# -*- coding: utf-8 -*-
import os
import sys


class win:
  handler = None

  def __init__(self):
    self.batch = open('symbolic.cmd', 'w')
    self.batch.write('@ECHO OFF\n')

  def add(self, src, dst):
    parent = '\\'.join(dst.split('\\')[:-1])
    self.batch.write('IF NOT EXIST "%s" MKDIR "%s"\n' % (parent, parent))
    self.batch.write('MKLINK /J "%s" "%s"\n' % (dst, src))

  def __del__(self):
    self.batch.write('PAUSE')
    self.batch.close()

  @staticmethod
  def symlink(src, dst):
    if not win.handler:
      win.handler = win()
    win.handler.add(src, dst)


class nix:
  @staticmethod
  def relative(foo, bar):
    foo = foo.split('/')
    bar = bar.split('/')
    lcp = 0
    while lcp < len(foo) and lcp < len(bar):
      if foo[lcp] == bar[lcp]:
        lcp += 1
      else:
        break
    foo = ['..' for i in range(len(bar) - lcp - 1)]+ foo[lcp:]
    return '/'.join(foo)

  @staticmethod
  def symlink(src, dst):
    os.makedirs('/'.join(dst.split('/')[:-1]), exist_ok = True)
    os.symlink(nix.relative(src, dst), dst)


def create_symlink(src, dst):
  if sys.platform.startswith('win'):
    win.symlink(src, dst)
  else:
    nix.symlink(src, dst)


def accounts(prefix, foo, bar):
  for path in [os.path.join(prefix, e) for e in bar]:
    create_symlink(foo, path)


def characters(prefix, foo, bar):
  for path in [os.path.join(prefix, *c.split(' - ')) for c in bar]:
    create_symlink(foo, path)
 

def main():
  accounts(os.path.join('WTF', 'Account'),
           os.path.join('WTF', 'Account', '150998550#2'),
           ['150998550#1',
            '150713399#1',
            '153384600#1',
            '158551774#1',
            '177602705#1',
            '555095699#1',
            '602893969#1',
            'DAYWALKER4',
            '14435195#1',
            '83215426#1',
            '1401199128#1',
            '858779833#1',
            '798149128#1',
            '819812327#1',
            'REYEON001',
            '17317768#1'])
  characters(os.path.join('WTF', 'Account', '150998550#2'),
             os.path.join('WTF',
                          'Account',
                          '150998550#2',
                          '比格沃斯',
                          '依然活着'),
             ['比格沃斯 - 八六',
              '比格沃斯 - 打工仔丶',
              '比格沃斯 - 筱狐狸',
              '比格沃斯 - 八六的灾厄',
              '比格沃斯 - 刚到底',
              '逐風者 - 依然活著',
              '逐風者 - 仍然活著',
              '逐風者 - 魔裝少年',
              '逐風者 - 筱狐狸',
              '逐風者 - 鷄肉韋嘎嘣脆',
              '逐風者 - 執著的牛',
              '逐風者 - 黑莲尖叫姬',
              '逐風者 - Oceanboy',
              '札里克 - 仍然活著',
              '烏蘇雷 - 仍然活著',
              'Classic PTR Realm 1 - 依然活著',
              'Classic PTR Realm 1 - 仍然活著',
              'Classic PTR Realm 1 - 依舊活著',
              'Classic PTR Realm 1 - 仍舊活著',
              'Classic PTR Realm 1 - 還活著',
              '比格沃斯 - 仍然活着'])
  # characters(os.path.join('WTF', 'Account', '150998550#2'),
  #            os.path.join('WTF',
  #                         'Account',
  #                         '150998550#2',
  #                         '比格沃斯',
  #                         '兩儀未那'),
  #            ['比格沃斯 - 寒冰贼'])
  # characters(os.path.join('WTF', 'Account', '150998550#2'),
  #            os.path.join('WTF',
  #                         'Account',
  #                         '150998550#2',
  #                         '比格沃斯',
  #                         'Pekorinu'),
  #            ['比格沃斯 - 意大力炮'])


if __name__ == '__main__':
  main()
