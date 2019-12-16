# -*- coding: utf-8 -*-

import os
import re

suf = ['.mp4', '.mkv']
pat = 'S\d\dE\d\d'
fmt = 'the-big-bang-theory_s%02de%02d'

for filename in os.listdir('.'):
    if len(filename) > 4 and filename[-4:] in suf:
        #print re.findall(pat, filename)
        key = re.findall(pat, filename)[0]
        new = (fmt % (int(key[-5:-3]), int(key[-2:]))) + filename[-4:]
        print new + ' <= ' + filename
        continue
        if os.path.exists(new):
            print 'path existed'
        else:
            os.rename(filename, new)
            print 'done'
