import sys


def armor_dr(amount):
    # Armor / (Armor + 400 + 85 * (AttackerLevel + 4.5 * (AttackerLevel - 59)))
    return amount / (amount + 7285.)


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


def main():
    health, armor, dodge, defense = [float(i) for i in sys.argv[1:]]
    print('1 stamina ~ %.6f armor' % one_stamina(health, armor))
    print('1 doddge ~ %.6f armor' % one_dodge(health, armor, dodge, defense))
    print('1 defense ~ %.6f armor' % one_defense(health, armor, dodge, defense))


if __name__ == '__main__':
    main()
