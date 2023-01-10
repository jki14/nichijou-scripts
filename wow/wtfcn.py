from os import path
from sys import stderr, stdout


def main():
    curloc = path.split(path.realpath(__file__))[0]
    stderr.write('wow in %s.\n' % curloc)
    cfgloc = path.join(curloc, 'WTF', 'Config.wtf')
    stderr.write('cfg at %s.\n' % cfgloc)
    if path.isfile(cfgloc):
        stderr.write('  confirmed.')
        config = {}
        with open(cfgloc, 'r') as cfg:
            for row in cfg.readlines():
                dummy, key, value = row.strip().split(' ', 2)
                config[key] = value
            config['portal'] = '"CN"'
            config['overrideArchive'] = '"0"'
            for key in config:
                stdout.write('SET %s %s\n' % (key, config[key]))


if __name__ == '__main__':
    main()
