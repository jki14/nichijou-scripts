import numpy as np

from Utils.Constants import eps
from Utils.Stats import stats_num, stats_prob


class SubStatsAdder:
    @staticmethod
    def toExsists(statsVec: np.array):
        return (np.fabs(statsVec) > eps).astype(np.double)

    def __init__(self, statsVec, debug):
        self.debug = debug

        self.f = np.zeros(1 << stats_num(), dtype=np.double)
        self.r = (np.fabs(statsVec) > eps).astype(np.double)
        self.r = SubStatsAdder.toExsists(statsVec)

        self.presented_msk = 0
        self.presented_num = 0
        for i in range(stats_num()):
            if self.r[i] > eps:
                self.presented_msk |= 1 << i
                self.presented_num += 1

        self.f[self.presented_msk] = np.double(1)

    def mask_next(self, i):
        lowbit = i & (-i)
        fund = i + lowbit
        sup = ((fund ^ i) >> 2) // lowbit
        return fund | sup

    def add_onemore(self):
        msk = (1 << self.presented_num) - 1
        while msk < len(self.f):
            if self.f[msk] > eps:
                not_exsisted = np.array([0 if msk & (1 << i) else 1 for i in range(stats_num())], dtype=np.double)
                w_sum = not_exsisted @ stats_prob()
                incremental = stats_prob() / w_sum * self.f[msk] * not_exsisted
                for i in range(stats_num()):
                    self.f[msk | (1 << i)] += incremental[i]
            if msk == 0:
                break
            msk = self.mask_next(msk)
        self.presented_num += 1

        self.r = np.zeros(stats_num(), dtype=np.double)
        msk = (1 << self.presented_num) - 1
        while msk < len(self.f):
            for i in range(stats_num()):
                if msk & (1 << i):
                    self.r[i] += self.f[msk]
            if msk == 0:
                break
            msk = self.mask_next(msk)

    def calc(self, iterNum):
        for k in range(iterNum):
            if self.presented_num < 5:
                self.add_onemore()
            else:
                self.r *= np.double(1) + np.double(0.25) * np.double(iterNum - k)
                break
        return self.r


def main():
    substats_demo = SubStatsAdder(np.zeros(stats_num(), dtype=np.double), debug=True)
    substats_demo.calc(iterNum=4)


if __name__ == "__main__":
    main()
