#include <cmath>
#include <iostream>
using namespace std;

int main() {
  cout << "Please input the W : H ratio of the main monitor with one space"
          " between them." << endl;
  double xw, xh;
  cin >> xw >> xh;
  cout << "Please input the size of the main monitor." << endl;
  double xs;
  cin >> xs;
  cout << "Please input the W : H ratio of the secondary monitor with one space"
          " between them." << endl;
  double yw, yh;
  cin >> yw >> yh;
  double ratio1d = xh / yh;
  double ys = xs / sqrt(xw * xh) * sqrt(yw * yh * ratio1d * ratio1d);
  cout << ys << endl;
  return 0;
}
