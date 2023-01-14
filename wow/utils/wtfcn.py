from os import path
from sys import stdout


def main():
    curloc = path.split(path.realpath(__file__))[0]
    stdout.write('wow in %s.\n' % curloc)
    cfgloc = path.join(curloc, 'WTF', 'Config.wtf')
    stdout.write('cfg at %s.\n' % cfgloc)
    if path.isfile(cfgloc):
        stdout.write('  confirmed.')
        body = ''
        config = {}
        with open(cfgloc, 'r') as cfg:
            for row in cfg.readlines():
                dummy, key, value = row.strip().split(' ', 2)
                config[key] = value
            config['portal'] = '"CN"'
            config['overrideArchive'] = '"0"'
            for key in config:
                body = body + ('SET %s %s\n' % (key, config[key]))
        with open(cfgloc, 'w') as cfg:
            cfg.write(body)


if __name__ == '__main__':
    main()
