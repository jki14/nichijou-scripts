# -*- coding: utf-8 -*-

import os
from PIL import Image

suf = ['.jpg']

a = [filename for filename in os.listdir('.') if len(filename) > 4 and filename[-4:] in suf]
a = sorted(a)
for x in a:
    foo = Image.open(x)
    if hasattr(foo, '_getexif'):
        orientation = 0x0112
        exif = foo._getexif()
        if exif is not None:
            orientation = exif[orientation]
            rotations = {
                3: Image.ROTATE_180,
                6: Image.ROTATE_270,
                8: Image.ROTATE_90
            }
            if orientation in rotations:
                foo = foo.transpose(rotations[orientation])
    # A4 - default 1654 x 2339
    foo.thumbnail((1654, 2339), Image.ANTIALIAS)
    foo.save('t' + x, 'JPEG')
