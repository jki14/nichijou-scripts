import os
import statistics
import sys

def isCrital(cr):
    bar = 2147483648 * cr
    foo = int(os.urandom(4).hex(), 16)
    return foo < bar

def zandalarian(cr):
    total = 0
    energe, star, extra = 80, 0, 40
    for i in range(20):
        if i % 2 == 0:
            energe = min(energe + 20, 100)
        # cast
        if star == 5:
            if energe >= 35:
                energe = 0
                star = 0
                # TODO: check if the bite trigger extra reduce
                # extra = max(extra - 2, 0)
        else:
            if energe >= 48:
                energe -= 48
                if isCrital(cr):
                    total += extra * 4.5
                    star = min(star + 2, 5)
                    extra = max(extra - 2, 0)
                else:
                    total += extra * 2.25
                    star = min(star + 1, 5)
                extra = max(extra - 2, 0)
        if isCrital(cr):
            total += extra * 2.0
        else:
            total += extra
        extra = max(extra - 2, 0)
    return total / 20.0


def earthstrike(cr):
    total = 0
    energe, star = 80, 0
    for i in range(20):
        if i % 2 == 0:
            energe = min(energe + 20, 100)
        # cast
        if star == 5:
            if energe >= 35:
                energe = 0
                star = 0
                if isCrital(cr):
                    total += 84.0
                else:
                    total += 42.0
        else:
            if energe >= 48:
                energe -= 48
                if isCrital(cr):
                    total += 90
                    star = min(star + 2, 5)
                else:
                    total += 45
                    star = min(star + 1, 5)
        if isCrital(cr):
            total += 40
        else:
            total += 20
    return total / 20.0


def slayerscrest(cr):
    total = 0
    energe, star = 80, 0
    for i in range(20):
        if i % 2 == 0:
            energe = min(energe + 20, 100)
        # cast
        if star == 5:
            if energe >= 35:
                energe = 0
                star = 0
                if isCrital(cr):
                    total += 97.2
                else:
                    total += 48.6
        else:
            if energe >= 48:
                energe -= 48
                if isCrital(cr):
                    total += 104
                    star = min(star + 2, 5)
                else:
                    total += 52
                    star = min(star + 1, 5)
        if isCrital(cr):
            total += 46
        else:
            total += 23
    return total / 20.0


def solution(cr):
    zug = [zandalarian(cr) for i in range(1000000)]
    zug = sorted(zug)
    sys.stdout.write('zandalarian\n')
    sys.stdout.write('  min: %.6f\n' % zug[0])
    sys.stdout.write('  max: %.6f\n' % zug[-1])
    sys.stdout.write('  p50: %.6f\n' % statistics.median(zug))
    sys.stdout.write('  avg: %.6f\n' % statistics.mean(zug))

    aq2 = [earthstrike(cr) for i in range(1000000)]
    aq2 = sorted(aq2)
    sys.stdout.write('zandalarian\n')
    sys.stdout.write('  min: %.6f\n' % aq2[0])
    sys.stdout.write('  max: %.6f\n' % aq2[-1])
    sys.stdout.write('  p50: %.6f\n' % statistics.median(aq2))
    sys.stdout.write('  avg: %.6f\n' % statistics.mean(aq2))
    
    nax = [slayerscrest(cr) for i in range(1000000)]
    nax = sorted(nax)
    sys.stdout.write('slayerscrest\n')
    sys.stdout.write('  min: %.6f\n' % nax[0])
    sys.stdout.write('  max: %.6f\n' % nax[-1])
    sys.stdout.write('  p50: %.6f\n' % statistics.median(nax))
    sys.stdout.write('  avg: %.6f\n' % statistics.mean(nax))


def main():
    cr = float(sys.argv[1])
    solution(cr)


if __name__ == '__main__':
    main()
