def calc(transcript):
    x = 0.0
    y = 0.0
    for row in transcript:
        if row[1] >= 90:
            x += 4.0 * row[0]
        elif row[1] >= 60:
            x += (row[1] - 50) * 0.1 *  row[0]
        y += row[0]
    return (x / y, x, y)

def main():
    transcript = []
    while True:
        try:
            row = [float(i) for i in raw_input().strip().split()]
            transcript.append(row)
        except EOFError:
            break
    print(calc(transcript))

if __name__ == '__main__':
    main()
