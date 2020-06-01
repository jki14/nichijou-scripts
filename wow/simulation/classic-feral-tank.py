import json
import sys

from texttable import Texttable


def armor_dr(amount):
    # Armor / (Armor + 400 + 85 * (AttackerLevel + 4.5 * (AttackerLevel - 59)))
    # Hard Cap: 21855
    # return amount / (amount + 7285.)
    # Armor / (Armor + 400 + 85 * AttackerLevel)
    # Hard Cap: 17265
    amount *= 1.25
    return min(amount / (amount + 5755), 0.75)


def coefficient(dodge, defense):
    miss = dodge + 0.05 + (defense - 315) * 0.0004
    crit = 0.05 + (315 - defense) * 0.0004
    crush = max(min(1.0 - crit - miss, 0.15), 0.0)
    hit = max(1.0 - miss - crit - crush, 0.0)
    return crit * 2.0 + crush * 1.5 + hit * 1.0


def one_stamina():
    return 1.2 * 10. * 1.05


def one_armor(health, armor, dodge, defense):
    total_damage = health / (1. - armor_dr(armor + 5.06))
    total_damage = total_damage / coefficient(dodge, defense)
    hp_required = total_damage * (1. - armor_dr(armor))
    hp_required = hp_required * coefficient(dodge, defense)
    return hp_required - health


def one_agility(health, armor, dodge, defense):
    total_damage = health / (1. - armor_dr(armor + 2))
    total_damage = total_damage / coefficient(dodge + 0.0005, defense)
    hp_required = total_damage * (1. - armor_dr(armor))
    hp_required = hp_required * coefficient(dodge, defense)
    return hp_required - health


def one_dodge(health, armor, dodge, defense):
    total_damage = health / (1. - armor_dr(armor))
    total_damage = total_damage / coefficient(dodge + 0.01, defense)
    hp_required = total_damage * (1. - armor_dr(armor))
    hp_required = hp_required * coefficient(dodge, defense)
    return hp_required - health


def one_defense(health, armor, dodge, defense):
    total_damage = health / (1. - armor_dr(armor))
    total_damage = total_damage / coefficient(dodge + 0.0004, defense + 1)
    hp_required = total_damage * (1. - armor_dr(armor))
    hp_required = hp_required * coefficient(dodge, defense)
    return hp_required - health


def process(health, armor, dodge, defense):
    weights = {
        'hitpoint': 1.,
        'armor': one_armor(health, armor, dodge, defense),
        'stamina': one_stamina(),
        'agility': one_agility(health, armor, dodge, defense),
        'dodge': one_dodge(health, armor, dodge, defense),
        'defense': one_defense(health, armor, dodge, defense)
    }

    status = Texttable()
    status.header(['health', 'armor', 'dodge', 'defense'])
    status.set_cols_align(['r' for i in range(4)])
    status.add_row(['%d' % health, '%d' % armor,
                    '%.2f%%' % (dodge * 100.), '%d' % defense])
    print(status.draw())

    table = Texttable()
    dims = ['armor', 'stamina', 'agility', 'dodge', 'defense']
    table.header([''] + dims)
    table.set_cols_dtype(['t' for i in range(len(dims) + 1)])
    table.set_cols_align(['r' for i in range(len(dims) + 1)])
    for att in ['hitpoint'] + dims:
        row = [att]
        for col in dims:
            try:
                row.append('%.6f' % (weights[att] / weights[col]))
            except ZeroDivisionError:
                row.append('inf')
        table.add_row(row)
    print(table.draw())


def main():
    with open('classic-feral-tank.json', 'r') as json_file:
        profiles = json.load(json_file)
        for key, value in profiles.items():
            print('#### %s:' % key)
            process(value['health'],
                    value['armor'],
                    value['dodge'],
                    value['defense'])


if __name__ == '__main__':
    main()
