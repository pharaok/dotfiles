#include <bits/stdc++.h>
using namespace std;
using ll = long long;

// @begin fenwickTree
struct FenwickTree {
  using T = int;
  T f(T x, T y) { return x + y; }

  vector<T> t;
  FenwickTree(int n) { t.assign(n + 1, 0); }
  FenwickTree(vector<T> &a) : FenwickTree(a.size()) {
    for (int i = 0; i < a.size(); i++)
      update(i + 1, a[i]);
  }

  T get(int r) { // [1, r]
    T ret = 0;
    for (; r >= 1; r -= r & -r)
      ret = f(ret, t[r]);
    return ret;
  }
  T get(int l, int r) { // [l, r]
    return get(r) - get(l - 1);
  }
  void update(int i, T v) {
    for (; i < t.size(); i += i & -i)
      t[i] = f(t[i], v);
  }
};
// @end fenwickTree
