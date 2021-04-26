from sys import stdout


def main():
    foo = []
    while True:
        try:
            row = input().strip()
            foo.append(row)
        except EOFError:
            break
    stdout.write('\n'.join(sorted(foo)))


if __name__ == '__main__':
    main()
