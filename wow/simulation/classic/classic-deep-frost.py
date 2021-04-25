import json
import sys

from texttable import Texttable


def frostbolt(power, crit, hit):
    dmg = 535
    dmg += power * 3.0 / 3.5 * 0.95
    dmg *= min(0.89 + hit, 0.99)
    dmg *= 1.0 + min(0.15 + crit, 1.00)
    return dmg


def process(power, crit, hit):
    base = frostbolt(power, crit, hit)
    weights = {
        'power': frostbolt(power + 1.00, crit, hit) - base,
        'crit': frostbolt(power, crit + 0.01, hit) - base,
        'hit': frostbolt(power, crit, hit + 0.01) - base
    }

    weights['hit'] /= weights['power']
    weights['crit'] /= weights['power']
    weights['power'] /= weights['power']

    table= Texttable()
    table.header(['power', 'crit', 'hit'])
    table.set_cols_align(['r' for i in range(3)])
    table.add_row(['%d' % power, '%.2f%%' % crit, '%.2f%%' % hit])
    table.add_row(['%.6f' % weights['power'],
                   '%.6f' % weights['crit'],
                   '%.6f' % weights['hit']])
    print(table.draw())


def main():
    with open('classic-deep-frost.json', 'r') as json_file:
        profiles = json.load(json_file)
        for key, value in profiles.items():
            print('#### %s:' % key)
            process(value['power'],
                    value['crit'],
                    value['hit'])


if __name__ == '__main__':
    main()
