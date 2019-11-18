import calendar
import os
import re
import sys
import time

'''
log create command sample:
ping www.google.com | ts0 | tee google.log
'''

def main():
    recf = re.compile('^\[\d\d\d\d-\d\d-\d\d \d\d:\d\d:\d\d] (.*) '
                     'time=[0-9]+\.?[0-9]* ms$')
    latf = re.compile('time=[0-9]+\.?[0-9]* ms$')
    path = sys.argv[1]
    with open(path, 'r') as log:
        table = { }
        for rec in log:
            rec = rec.strip()
            if recf.match(rec):
                timepoint = rec[1:20]
                latency = latf.findall(rec)[0][5:-3]
                timepoint = time.strptime(timepoint, '%Y-%m-%d %H:%M:%S')
                timepoint = calendar.timegm(timepoint)
                latency = float(latency)
                if latency < 100.0:
                    table[timepoint] = latency
        healthy = sorted(table.keys())
        length = healthy[-1] - healthy[0] + 1
        num_of_break, sum_of_break = 0, 0
        for i in range(len(healthy) - 1):
            if healthy[i] + 5 < healthy[i + 1]:
                num_of_break += 1
                sum_of_break += healthy[i + 1] - healthy[i]
                sys.stdout.write('%s - %s (%d secs)\n' % (
                    time.strftime("%Y-%m-%d %H:%M:%S",
                                  time.localtime(healthy[i] + 1)),
                    time.strftime("%H:%M:%S",
                                  time.localtime(healthy[i + 1] - 1)),
                    healthy[i + 1] - healthy[i])
                )
        if num_of_break == 0:
            sys.stdout.write('worked perfectly '
                             'in %d hours %d minutes\n' % (
                length / 3600,
                length % 3600 / 60)
            )
        else:
            sys.stdout.write('%d / %d (%.2f%% off, %d times of %.2f secs avg) '
                             'in %d hours %d minutes\n' % (
                sum_of_break,
                length,
                sum_of_break * 100.0 / length,
                num_of_break,
                sum_of_break * 1.0 / num_of_break,
                length / 3600,
                length % 3600 / 60)
            )

if __name__ == '__main__':
    main()
