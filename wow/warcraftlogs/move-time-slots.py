from sys import stderr, stdout
from datetime import datetime, timedelta

def main():
    while True:
        try:
            bars = input().strip().split(' ')
            dt = datetime.strptime(bars[0] + ' ' + bars[1].split('.')[0], '%m/%d %H:%M:%S')
            dt -= timedelta(minutes = 110)
            foo = dt.strftime('%m/%d %H:%M:%S') + '.' + bars[1].split('.')[1]
            foo = ' '.join([foo] + bars[2:])
            print(foo)
        except EOFError:
            break


if __name__ == '__main__':
    main()
