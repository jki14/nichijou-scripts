# -*- coding: utf-8 -*-

import os

suf = ['.jpg']

a = [filename for filename in os.listdir('.') if len(filename)>4 and filename[-4:] in suf]
a = sorted(a)
for i in xrange(len(a)):
    x = a[i]
    y = '%02d.jpg' % (i + 1)
    print x + ' <= ' + y
    continue
    if os.path.exists(y):
        print 'path existed'
    else:
        os.rename(x, y)
        print 'done'
