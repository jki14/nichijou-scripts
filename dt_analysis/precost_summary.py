# -*- coding: utf-8 -*-

import sys
import codecs

a = []

while True:
    buf = ''
    try:
        buf = raw_input()
        if not buf.startswith(codecs.BOM_UTF8):
            buf = codecs.BOM_UTF8 + buf
        buf = buf.decode('utf-8').strip()
    except EOFError:
        break
    row = [cell for cell in buf.split('\t')]
    a.append(row)

h = len(a)
w = max([len(row) for row in a])

for i in xrange(h):
    while len(a[i])<w:
        a[i].append('')

c = [0.0] * w

for i in xrange(1, h):
    seq = []
    for j in xrange(3, w):
        if 'X' in a[i][j].replace(' ', ''):
            seq.append(j)
        else:
            if len(a[i][j])>0:
                sys.stderr.write('unexpected record "%s"\n' % (a[i][j]))
    wht = 0.0
    try:
        wht = float(a[i][2].replace(u'¥', '').replace(',', ''))
    except ValueError:
        sys.stderr.write('unexpected amount "%s"\n' % (a[i][2]))

    if wht>0.0:
        if len(seq)>0:
            wht /= len(seq)*1.0
            for u in seq:
                c[u] += wht
        else:
            sys.stderr.write('non zero amount with empty seq found at row %d\n' % (i))
            continue

for u in xrange(3, w):
    print a[0][u] + ' : ' + str(c[u])

print 'Total : ' + str(sum(c))
