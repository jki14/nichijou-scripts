import os

from argparse import ArgumentParser
from re import findall
from sys import stderr


def main():
    parser = ArgumentParser(description='The file renaming script for resorting animations.')
    parser.add_argument('prefix', help='The target prefix, like jojo_s03e.')
    parser.add_argument('--extensions', help='The file extensions, like \'.mp4,.mkv\'.', default='.mp4,.mkv', required=False)
    parser.add_argument('--pattern', help='The pattern of the episode, like \'\[\d\d\]\'.', default='\[\d\d\]', required=False)
    parser.add_argument('--execute', help='Apply the change instead of dryrun.', default=False, action='store_true')

    args = parser.parse_args()

    for filename in os.listdir('.'):
        for e in args.extensions.split(','):
            if not filename.endswith(e):
                continue
            episode = findall(args.pattern, filename)[0]
            target = '%s%s%s' % (args.prefix, episode.strip('[]'), e)
            stderr.write('%s <= %s\n' % (target, filename))
            assert not os.path.exists(target), '%s exsists.' % target
            if args.execute:
                os.rename(filename, target)
            break


if __name__ == '__main__':
    main()
