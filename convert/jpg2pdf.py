# -*- coding: utf-8 -*-

import os
from fpdf import FPDF

suf = ['.jpg']

# A4 - default 1654 x 2339
foo = FPDF('P', 'pt', (1654, 2339))
foo.set_auto_page_break(False)

a = [filename for filename in os.listdir('.') if len(filename) > 4 and filename[-4:] in suf and filename[0] == 't']
a = sorted(a)
for x in a:
    foo.add_page()
    foo.image(x)
foo.output('temp.pdf')
