from sys import stderr, stdout


def main():
    while True:
        try:
            row = input()
            if '29534' in row:
                stderr.write('%s\n' % row)
                continue
            else:
                stdout.write('%s\n' % row)
        except EOFError:
            break


if __name__ == '__main__':
    main()
