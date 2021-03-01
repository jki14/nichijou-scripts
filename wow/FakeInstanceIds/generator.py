from random import randint


def solution(n):
    foo = []
    for i in range(n):
        foo.append('hack-108%08d' % randint(1, 99999999))
    return list(set(foo))


def main():
    for item in solution(1024):
        print(item)


if __name__ == '__main__':
    main()
