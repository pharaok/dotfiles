#include <bits/stdc++.h>
using namespace std;
using ll = long long;

// @begin segTree
struct SegTree {
  using T = int;
  T op(T a, T b) { return a + b; }
  const T iden = 0;

  int size;
  vector<T> st;

  int left(int x) { return 2 * x + 1; }
  int right(int x) { return 2 * x + 2; }

  SegTree(int n) {
    size = 1;
    while (size < n)
      size *= 2;
    st.assign(2 * size, iden);
  }

  void build(vector<T> &a, int x, int xl, int xr) {
    if (xr - xl == 1) {
      if (xl < a.size())
        st[x] = a[xl];
      return;
    }
    int xm = (xl + xr) / 2;
    build(a, left(x), xl, xm);
    build(a, right(x), xm, xr);
    st[x] = op(st[left(x)], st[right(x)]);
  }
  void build(vector<T> &a) { return build(a, 0, 0, size); }

  T query(int l, int r, int x, int xl, int xr) { // r exclusive
    if (l <= xl && xr <= r)
      return st[x];
    if (r <= xl || xr <= l)
      return iden;
    int xm = (xl + xr) / 2;
    return op(query(l, r, left(x), xl, xm), query(l, r, right(x), xm, xr));
  }
  T query(int l, int r) { return query(l, r + 1, 0, 0, size); } // r inlusive

  void set(int i, T v, int x, int xl, int xr) {
    if (xr - xl == 1) {
      st[x] = v;
      return;
    }
    int xm = (xl + xr) / 2;
    if (i < xm)
      set(i, v, left(x), xl, xm);
    else
      set(i, v, right(x), xm, xr);
    st[x] = op(st[left(x)], st[right(x)]);
  }
  void set(int i, T v) { return set(i, v, 0, 0, size); }
};
// @end segTree

// @begin lazySegTree
struct LazySegTree {
  using T = ll;
  T op(T a, T b) { return a + b; }
  const T iden = 0;

  int size;
  vector<T> st;

  int left(int x) { return 2 * x + 1; }
  int right(int x) { return 2 * x + 2; }

  LazySegTree(int n) {
    size = 1;
    while (size < n)
      size *= 2;
    st.assign(2 * size, iden);
  }

  void build(vector<T> &a, int x, int xl, int xr) {
    if (xr - xl == 1) {
      if (xl < a.size())
        st[x] = a[xl];
      return;
    }
    int xm = (xl + xr) / 2;
    build(a, left(x), xl, xm);
    build(a, right(x), xm, xr);
    st[x] = op(st[left(x)], st[right(x)]);
  }
  void build(vector<T> &a) { return build(a, 0, 0, size); }

  T query(int i, int x, int xl, int xr) {
    if (xr - xl == 1)
      return st[x];
    int xm = (xl + xr) / 2;
    if (i < xm)
      return op(st[x], query(i, left(x), xl, xm));
    else
      return op(st[x], query(i, right(x), xm, xr));
  }
  T query(int i) { return query(i, 0, 0, size); }

  void set(int l, int r, T dv, int x, int xl, int xr) { // r exclusive
    if (l <= xl && xr <= r) {
      st[x] = op(st[x], dv);
      return;
    }
    if (r <= xl || xr <= l)
      return;

    int xm = (xl + xr) / 2;
    set(l, r, dv, left(x), xl, xm);
    set(l, r, dv, right(x), xm, xr);
  }
  // r inclusive
  void set(int l, int r, T dv) { return set(l, r + 1, dv, 0, 0, size); }
};
// @end lazySegTree
