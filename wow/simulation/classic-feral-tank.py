import sys

def armor_dr(amount):
    # Armor / (Armor + 400 + 85 * (AttackerLevel + 4.5 * (AttackerLevel - 59)))
    return amount / (amount + 7285.)

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

def main():
    print(one_stamina(float(sys.argv[1]), float(sys.argv[2])))

if __name__ == '__main__':
    main()
