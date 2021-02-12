from random import randint


def main():
    foo = []
    while True:
        try:
            foo.append(input().strip())
        except EOFError:
            break
    for r in list(set(foo)):
        print(r)


if __name__ == '__main__':
    main()
