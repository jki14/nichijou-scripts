# -*- coding: utf-8 -*-

import os
import re

suf = ['.mp4', '.mkv']
pat = '\[\d\d\]'
prf = 'jojo_s04e'

for filename in os.listdir('.'):
    if len(filename) > 4 and filename[-4:] in suf:
        #print re.findall(pat, filename)
        key = re.findall(pat, filename)[0]
        new = prf + key[-3:-1] + filename[-4:]
        print new + ' <= ' + filename
        continue
        if os.path.exists(new):
            print 'path existed'
        else:
            os.rename(filename, new)
            print 'done'
