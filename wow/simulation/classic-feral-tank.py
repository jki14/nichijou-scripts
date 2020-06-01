import json
import sys

from texttable import Texttable


def armor_dr(amount):
    # Armor / (Armor + 400 + 85 * (AttackerLevel + 4.5 * (AttackerLevel - 59)))
    # Hard Cap: 21855
    # return amount / (amount + 7285.)
    # Armor / (Armor + 400 + 85 * AttackerLevel)
    # Hard Cap: 17265
    return amount / (amount + 5755)


def coefficient(dodge, defense):
    miss = dodge + 0.05 + (defense - 315) * 0.0004
    crit = 0.05 + (315 - defense) * 0.0004
    crush = max(min(1.0 - crit - miss, 0.15), 0.0)
    hit = max(1.0 - miss - crit - crush, 0.0)
    return crit * 2.0 + crush * 1.5 + hit * 1.0


def stamina_hp(amount):
    return amount * 1.2 * 10. * 1.05


def find(lef, rig, value, func):
    if value > 0.75:
        raise ValueError
    while lef + 1e-2 < rig:
        mid = (lef + rig) / 2.
        if func(mid) > value:
            rig = mid
        else:
            lef = mid
    return rig


def one_stamina(health, armor):
    total_damage = (health + stamina_hp(1)) / (1. - armor_dr(armor))
    dr_required = 1. - health / total_damage
    return (find(0., 22000., dr_required, armor_dr) - armor) / 5.06


def one_agility(health, armor, dodge, defense):
    total_damage = health / (1. - armor_dr(armor + 2))
    total_damage = total_damage / coefficient(dodge + 0.0005, defense)
    dr_required = 1. - health / coefficient(dodge, defense) / total_damage
    return (find(0., 22000., dr_required, armor_dr) - armor) / 5.06


def one_dodge(health, armor, dodge, defense):
    total_damage = health / (1. - armor_dr(armor))
    total_damage = total_damage / coefficient(dodge + 0.01, defense)
    dr_required = 1. - health / coefficient(dodge, defense) / total_damage
    return (find(0., 22000., dr_required, armor_dr) - armor) / 5.06


def one_defense(health, armor, dodge, defense):
    total_damage = health / (1. - armor_dr(armor))
    total_damage = total_damage / coefficient(dodge + 0.0004, defense + 1)
    dr_required = 1. - health / coefficient(dodge, defense) / total_damage
    return (find(0., 22000., dr_required, armor_dr) - armor) / 5.06


def process(health, armor, dodge, defense):
    weights = {
        'armor': 1.,
        'stamina': one_stamina(health, armor),
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
    for att in dims:
        row = [att]
        for col in dims:
            row.append('%.6f' % (weights[att] / weights[col]))
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
