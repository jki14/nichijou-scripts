import io
import re
import socket
import urllib2

from PIL import Image

def getList(cur):
    foo = set()
    pat = re.compile('http://.*\#pic|$')
    pak = re.compile('/[a-z0-9]+\#')
    while True:
        key = pak.search(cur).group()[1:-1]
        if key in foo:
            break
        foo.add(key)
        cooldown = 0.0
        while True:
            try:
                rep = urllib2.urlopen(cur)
            except urllib2.URLError, socket.error:
                cooldown += 0.2
                time.sleep(cooldown)
                continue
            break
        raw = rep.read()
        cur = pat.search(raw).group()
    return list(foo)

def main():
    keys = getList('http://photo.blog.sina.com.cn/photo/1288485012/4cccb894bfdea410f99df#pic')
    for i in xrange(len(keys)):
        cooldown = 0.0
        while True:
            try:
                rep = urllib2.urlopen('http://s16.sinaimg.cn/orignal/%s&690' % keys[i])
            except urllib2.URLError, socket.error:
                cooldown += 0.2
                time.sleep(cooldown)
                continue
            break
        raw = rep.read()
        Image.open(io.BytesIO(raw)).convert('RGB').save('images/%02d-%s.jpg' % (i+1, keys[i]), 'JPEG')

if __name__ == '__main__':
    main()
