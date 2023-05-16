#include <cassert>
#include <cstdio>
#include <utility>

void process(double const a, double const x, double const b) {
    static auto const solution =
            [](double const a, double const x, double const b)
                    -> std::pair<double, double> {
        double const yk = (a + 1.0) / (b + 1.0);
        double const gk = a - yk;
        return std::make_pair(yk * x, gk * x);
    };
    if (b < 0.0) {
        bool lose = true;
        for (int i = 1; i <= 999; ++i) {
            double const b = i * 0.01;
            auto const foobar = solution(a, x, b);
            if (lose && foobar.second > -1e-6) {
                printf("--------\n");
                lose = false;
            }
            printf("b = %.2f, y = %.2f, g = %.2f\n",
                   b, foobar.first, foobar.second);
        }
    } else {
        double const c = (a + 1.0) / a - 1.0;
        auto const foocar = solution(a, x, c);
        printf("b = %.2f, y = %.2f, g = %.2f\n",
               c, foocar.first, foocar.second);
        double const d = (a + 1.0) / (a - 1.0) - 1.0;
        auto const foodar = solution(a, x, d);
        printf("b = %.2f, y = %.2f, g = %.2f\n",
               d, foodar.first, foodar.second);
        auto const foobar = solution(a, x, b);
        printf("b = %.2f, y = %.2f, g = %.2f\n",
               b, foobar.first, foobar.second);
    }
}

int main(int argc, char *argv[]) {
    double a, x = 1.0, b = -1.0;
    if (argc < 2 || argc > 4) {
      fprintf(stderr, "? ./reverse-lever lhs-rates [lhs-bets] [rhs-rates]\n");
    }
    assert(2 <= argc && argc <= 4);
    sscanf(argv[1], "%lf", &a);
    if (argc >= 3) {
      sscanf(argv[2], "%lf", &x);
    }
    if (argc == 4) {
      sscanf(argv[3], "%lf", &b);
    }
    process(a, x, b);
    return 0;
}
