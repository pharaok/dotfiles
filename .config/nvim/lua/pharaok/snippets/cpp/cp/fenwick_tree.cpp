#include <bits/stdc++.h>
using namespace std;
using ll = long long;

// @begin fenwickTree
struct FenwickTree {
  using T = ll;

  vector<T> b;
  FenwickTree(int n) { b.assign(n + 1, 0); }
  FenwickTree(vector<T> &a) : FenwickTree(a.size()) {
    for (int i = 0; i < a.size(); i++)
      update(i, a[i]);
  }

  T query(int r) { // [1, r]
    T ret = 0;
    for (; r >= 1; r -= r & -r)
      ret += b[r];
    return ret;
  }
  T query(int l, int r) { // [l, r]
    return query(r + 1) - query(l);
  }
  void update(int i, T v) {
    for (i++; i < b.size(); i += i & -i)
      b[i] += v;
  }
};
// @end fenwickTree
