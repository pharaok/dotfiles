#include <bits/stdc++.h>
using namespace std;
using ll = long long;

namespace BIT {
// @begin fenwickTree
struct FenwickTree {
  using T = ll;

  vector<T> b;
  FenwickTree(int n) { b.assign(n + 1, 0); }
  FenwickTree(vector<T> &a) : FenwickTree(a.size()) {
    for (int i = 0; i < a.size(); i++)
      update(i, a[i]);
  }

  T query(int r) { // [0, r]
    T ret = 0;
    for (r++; r >= 1; r -= r & -r)
      ret += b[r];
    return ret;
  }
  T query(int l, int r) { // [l, r]
    return query(r) - query(l - 1);
  }
  void update(int i, T v) {
    for (i++; i < b.size(); i += i & -i)
      b[i] += v;
  }
};
// @end fenwickTree
} // namespace BIT

namespace PolynomialBIT {
// @begin fenwickTreePoly
struct FenwickTree {
  using T = ll;

  vector<T> b[4];
  FenwickTree(int n) {
    for (int t = 0; t < 4; t++)
      b[t].assign(n + 1, 0);
  }

  T _query(int t, int r) { // [0, r]
    T ret = 0;
    for (r++; r >= 1; r -= r & -r)
      ret += b[t][r];
    return ret;
  }
  T query(int r) { // [0, r]
    T ret = 0;
    ll x = 1;
    for (int t = 0; t < 4; t++) {
      ret += _query(t, r) * x;
      x *= r;
    }
    return ret / 6;
  }
  T query(int l, int r) { // [l, r]
    return query(r) - query(l - 1);
  }

  void _update(int t, int i, T v) {
    for (i++; i < b[t].size(); i += i & -i)
      b[t][i] += v;
  }
  void update(ll l, ll r, T a, T b, T c) { // add a + bx + cx^2 on [l, r]
    // add everything after multiplying by
    // lcm(1, 2, 6), and divide in the query.

    // add a
    _update(0, l, 6 * a * (-l + 1));
    _update(1, l, 6 * a);
    _update(0, r + 1, -6 * a * (-l + 1) + 6 * a * (r - l + 1));
    _update(1, r + 1, -6 * a);

    // add bx
    _update(0, l, 3 * b * (-l * l + l));
    _update(1, l, 3 * b);
    _update(2, l, 3 * b);
    _update(0, r + 1,
            -3 * b * (-l * l + l) + 3 * b * (r * (r + 1) - (l - 1) * l));
    _update(1, r + 1, -3 * b);
    _update(2, r + 1, -3 * b);

    // add cx^2
    _update(0, l, c * -(l - 1) * l * (2 * l - 1));
    _update(1, l, c);
    _update(2, l, c * 3);
    _update(3, l, c * 2);
    _update(0, r + 1,
            -c * -(l - 1) * l * (2 * l - 1) +
                c * (r * (r + 1) * (2 * r + 1) - (l - 1) * l * (2 * l - 1)));
    _update(1, r + 1, -c);
    _update(2, r + 1, -c * 3);
    _update(3, r + 1, -c * 2);
  }
  void updateRelative(ll l, ll r, T a, T b,
                      T c) { // add a + b(x-l) + c(x-l)^2 on [l, r]
    update(l, r, a - b * l + c * l * l, b + c * (-2 * l), c);
  }
};
// @end fenwickTreePoly
} // namespace PolynomialBIT
