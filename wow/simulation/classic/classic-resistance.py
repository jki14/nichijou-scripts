import sys

def hit():
    table = [
        [ 0, 25, 50, 75, 100],
        [ 0,  2, 11, 33,  54],
        [ 1,  6, 24, 49,  20],
        [ 1, 18, 48, 26,   7],
        [11, 34, 40, 14,   1],
        [25, 55, 16,  3,   1]
    ]
    for i in range(1, 6):
        foo = sum([table[0][j] * table[i][j] for j in range(5)]) / 100.
        sys.stdout.write('%dx - Hit Damage: %.2f%%\n' % (i, foo))


def main():
    hit()


if __name__ == '__main__':
    main()
