from numpy import double, fabs, ones, zeros

from SubStatsAdder import SubStatsAdder


class SubStatsAdderTest:

    def dfs(p, r, notv, b=double("1.0")):
        if r == 0:
            return
        w_sum = notv @ SubStatsAdder.factors
        for i in range(len(SubStatsAdder.dims)):
            if notv[i] < double("0.5"):
                continue
            c = b * SubStatsAdder.factors[i] / w_sum
            p[i] += c
            notv[i] = double("0.0")
            SubStatsAdderTest.dfs(p, r - 1, notv, c)
            notv[i] = double("1.0")

    def simulate(presented, target):
        p = zeros(len(SubStatsAdder.dims), dtype=double)
        r = target
        notv = ones(len(SubStatsAdder.dims), dtype=double)
        for i in range(len(SubStatsAdder.dims)):
            if SubStatsAdder.dims[i] in presented:
                p[i] = double("1.0")
                notv[i] = double("0.0")
                r -= 1

        SubStatsAdderTest.dfs(p, r, notv)

        res = {}
        for i in range(len(SubStatsAdder.dims)):
            res[SubStatsAdder.dims[i]] = p[i]
        return res

    def checkMapStringDoubleEqual(lhs, rhs):
        assert len(lhs) == len(rhs)
        for key in lhs:
            if fabs(lhs[key] - rhs[key]) > 1e-9:
                print(lhs)
                print(rhs)
                assert False
        print("passed.")

    def test():
        # presented = []
        substats_adder = SubStatsAdder(presented=[], debug=False)
        lhs = substats_adder.start(target=4)
        rhs = SubStatsAdderTest.simulate(presented=[], target=4)
        SubStatsAdderTest.checkMapStringDoubleEqual(lhs, rhs)
        # presented = [...]
        m = len(SubStatsAdder.dims)
        for w in range(m):
            for x in range(w, m):
                for y in range(x, m):
                    for z in range(y, m):
                        presented = [
                            SubStatsAdder.dims[w],
                            SubStatsAdder.dims[x],
                            SubStatsAdder.dims[y],
                            SubStatsAdder.dims[z],
                        ]
                        presented = list(dict.fromkeys(presented))
                        substats_adder = SubStatsAdder(presented=presented, debug=False)
                        lhs = substats_adder.start(target=4)
                        rhs = SubStatsAdderTest.simulate(presented=presented, target=4)
                        SubStatsAdderTest.checkMapStringDoubleEqual(lhs, rhs)


def main():
    SubStatsAdderTest.test()


if __name__ == "__main__":
    main()
