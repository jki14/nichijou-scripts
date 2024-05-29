from numpy import array, copy, double, fill_diagonal, ones, stack, zeros

from utils.names import NAMES
from utils.selects import SELECTS
from utils.styles import STYLES


class SubStatsAdder:
    dims = [
        NAMES.CRIT_RATE,
        NAMES.CRIT_DMG,
        NAMES.ENERGY_RECHARGE,
        NAMES.ELEMENTAL_MASTERY,
        NAMES.ATK_PCT,
        NAMES.HP_PCT,
        NAMES.DEF_PCT,
        NAMES.ATK,
        NAMES.HP,
        NAMES.DEF,
    ]
    ones10 = ones(10, dtype=double)

    factors = array(
        [
            SELECTS.CRIT_RATE,
            SELECTS.CRIT_DMG,
            SELECTS.ENERGY_RECHARGE,
            SELECTS.ELEMENTAL_MASTERY,
            SELECTS.ATK_PCT,
            SELECTS.HP_PCT,
            SELECTS.DEF_PCT,
            SELECTS.ATK,
            SELECTS.HP,
            SELECTS.DEF,
        ],
        dtype=double,
    )

    def __init__(self, presented, debug):
        presented = list(dict.fromkeys(presented))
        self.presented_num = len(presented)

        self.debug = debug

        self.f = zeros(1 << 10, dtype=double)
        self.p = zeros(10, dtype=double)

        self.presented_msk = 0
        for i in range(10):
            if SubStatsAdder.dims[i] in presented:
                self.p[i] = double("1.0")
                self.presented_msk |= 1 << i
        self.f[self.presented_msk] = double("1.0")

    def pshow(self):
        if not self.debug:
            return
        if self.p[0] > 1e-9:
            STYLES.CRIT_RATE.print("%s: %.6f" % (NAMES.CRIT_RATE, self.p[0]))
        if self.p[1] > 1e-9:
            STYLES.CRIT_DMG.print("%s: %.6f" % (NAMES.CRIT_DMG, self.p[1]))
        if self.p[2] > 1e-9:
            STYLES.ENERGY_RECHARGE.print("%s: %.6f" % (NAMES.ENERGY_RECHARGE, self.p[2]))
        if self.p[3] > 1e-9:
            STYLES.ELEMENTAL_MASTERY.print("%s: %.6f" % (NAMES.ELEMENTAL_MASTERY, self.p[3]))
        if self.p[4] > 1e-9:
            STYLES.ATK_PCT.print("%s: %.6f" % (NAMES.ATK_PCT, self.p[4]))
        if self.p[5] > 1e-9:
            STYLES.HP_PCT.print("%s: %.6f" % (NAMES.HP_PCT, self.p[5]))
        if self.p[6] > 1e-9:
            STYLES.DEF_PCT.print("%s: %.6f" % (NAMES.DEF_PCT, self.p[6]))
        if self.p[7] > 1e-9:
            STYLES.ATK.print("%s: %.6f" % (NAMES.ATK, self.p[7]))
        if self.p[8] > 1e-9:
            STYLES.HP.print("%s: %.6f" % (NAMES.HP, self.p[8]))
        if self.p[9] > 1e-9:
            STYLES.DEF.print("%s: %.6f" % (NAMES.DEF, self.p[9]))
        STYLES.INFO.print("================ SUM: %.2f" % sum(self.p))

    def mask_next(self, i):
        lowbit = i & (-i)
        fund = i + lowbit
        sup = ((fund ^ i) >> 2) // lowbit
        return fund | sup

    def calc_onemore(self):
        msk = (1 << self.presented_num) - 1
        while msk < len(self.f):
            if self.f[msk] > 1e-9:
                not_exsisted = array([0 if msk & (1 << i) else 1 for i in range(10)], dtype=double)
                w_sum = not_exsisted @ SubStatsAdder.factors
                incremental = SubStatsAdder.factors / w_sum * self.f[msk] * not_exsisted
                for i in range(10):
                    self.f[msk | (1 << i)] += incremental[i]
            if msk == 0:
                break
            msk = self.mask_next(msk)
        self.presented_num += 1

        self.p = zeros(10, dtype=double)
        msk = (1 << self.presented_num) - 1
        while msk < len(self.f):
            for i in range(10):
                if msk & (1 << i):
                    self.p[i] += self.f[msk]
            if msk == 0:
                break
            msk = self.mask_next(msk)

    def start(self, target):
        self.pshow()
        for i in range(self.presented_num, target):
            self.calc_onemore()
            self.pshow()
        res = {}
        for i in range(len(SubStatsAdder.dims)):
            if self.p[i] > 1e-9 and self.p[i] < double("1.0") - 1e-9:
                res[SubStatsAdder.dims[i]] = self.p[i]
        return res


def main():
    substats_demo = SubStatsAdder(presented=[], debug=True)
    substats_demo.start(target=4)


if __name__ == "__main__":
    main()
