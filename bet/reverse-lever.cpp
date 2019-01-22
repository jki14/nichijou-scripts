#include <cassert>
#include <cstdio>

void process(const double a, const double x) {
    bool negative = true;
    for (int i = 1; i <= 999; ++i) {
        const double b = i * 0.01;
        const double yk = (a + 1.0) / (b + 1.0);
        const double gk = a - yk;
        if (negative && gk > -1e-6) {
            printf("--------\n");
            negative = false;
        }
        printf("b = %.2f?, y = %.2f, g = %.2f\n", b, yk * x, gk * x);
    }
}

int main(int argc, char *argv[]) {
    assert(argc == 3);
    double a, x;
    sscanf(argv[1], "%lf", &a);
    sscanf(argv[2], "%lf", &x);
    process(a, x);
    return 0;
}
