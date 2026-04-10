#include <bits/stdc++.h>
using namespace std;
using ll = long long;

namespace PURQ {
// @begin segTree
template <class T> struct SegmentTree {
  int size;
  vector<T> st;

  int left(int x) { return 2 * x + 1; }
  int right(int x) { return 2 * x + 2; }

  SegmentTree(int n) {
    size = 1;
    while (size < n)
      size *= 2;
    st.assign(2 * size, T());
  }

  template <class U> void build(vector<U> &a, int x, int xl, int xr) {
    if (xr - xl == 1) {
      if (xl < a.size())
        st[x] = T(a[xl]);
      return;
    }
    int xm = (xl + xr) / 2;
    build(a, left(x), xl, xm);
    build(a, right(x), xm, xr);
    st[x] = op(st[left(x)], st[right(x)]);
  }
  template <class U> void build(vector<U> &a) { return build(a, 0, 0, size); }

  T query(int l, int r, int x, int xl, int xr) { // r exclusive
    if (r <= xl || xr <= l)
      return T();
    if (l <= xl && xr <= r)
      return st[x];
    int xm = (xl + xr) / 2;
    return op(query(l, r, left(x), xl, xm), query(l, r, right(x), xm, xr));
  }
  T query(int l, int r) { return query(l, r + 1, 0, 0, size); } // r inlusive

  template <class U> void update(int i, U v, int x, int xl, int xr) {
    if (xr - xl == 1) {
      st[x] = T(v);
      return;
    }
    int xm = (xl + xr) / 2;
    if (i < xm)
      update(i, v, left(x), xl, xm);
    else
      update(i, v, right(x), xm, xr);
    st[x] = op(st[left(x)], st[right(x)]);
  }
  template <class U> void update(int i, U v) {
    return update(i, v, 0, 0, size);
  }
};
struct Info {
  ll v;
  Info(ll v_) : v(v_) {}
  Info() : Info(0) {} // IDEN

  friend Info op(Info a, Info b) {
    Info ret;
    ret.v = a.v + b.v;
    return ret;
  }
};
using SegTree = SegmentTree<Info>;
// @end segTree
} // namespace PURQ

namespace RUPQ {
// @begin segTreeRUPQ
template <class T, class Op> struct SegTree {
  T iden;
  Op op;

  int size;
  vector<T> st;

  int left(int x) { return 2 * x + 1; }
  int right(int x) { return 2 * x + 2; }

  SegTree(int n, T iden, Op op) : iden(iden), op(op) {
    size = 1;
    while (size < n)
      size *= 2;
    st.assign(2 * size, iden);
  }

  template <class U> void build(vector<U> &a, int x, int xl, int xr) {
    if (xr - xl == 1) {
      if (xl < a.size())
        st[x] = T(a[xl]);
      return;
    }
    int xm = (xl + xr) / 2;
    build(a, left(x), xl, xm);
    build(a, right(x), xm, xr);
    st[x] = op(st[left(x)], st[right(x)]);
  }
  template <class U> void build(vector<U> &a) { return build(a, 0, 0, size); }

  T query(int i, int x, int xl, int xr) {
    if (xr - xl == 1)
      return st[x];
    int xm = (xl + xr) / 2;
    T res;
    if (i < xm)
      res = query(i, left(x), xl, xm);
    else
      res = query(i, right(x), xm, xr);
    return op(st[x], res);
  }
  T query(int i) { return query(i, 0, 0, size); } // r inlusive

  template <class U> void set(int l, int r, U v, int x, int xl, int xr) {
    if (r <= xl || xr <= l)
      return;
    if (l <= xl && xr <= r) {
      st[x] = op(st[x], T(v));
      return;
    }
    int xm = (xl + xr) / 2;
    set(l, r, v, left(x), xl, xm);
    set(l, r, v, right(x), xm, xr);
  }
  template <class U> void set(int l, int r, U v) {
    return set(l, r + 1, v, 0, 0, size);
  }
};
// @end segTreeRUPQ
} // namespace RUPQ

namespace Lazy {
// @begin segTreeLazy
template <class T, class F> struct LazySegmentTree {
  int size;
  vector<T> st;
  vector<F> lazy;

  void apply(F v, int x, int xl, int xr) {
    st[x].apply(v, xl, xr);
    lazy[x].apply(v, xl, xr);
  }
  void push(int x, int xl, int xr) {
    if (xr - xl == 1)
      return;
    int xm = (xl + xr) / 2;
    apply(lazy[x], left(x), xl, xm);
    apply(lazy[x], right(x), xm, xr);
    lazy[x] = F();
  };
  void pull(int x) { st[x] = op(st[left(x)], st[right(x)]); }

  int left(int x) { return 2 * x + 1; }
  int right(int x) { return 2 * x + 2; }

  LazySegmentTree(int n) {
    size = 1;
    while (size < n)
      size *= 2;
    st.assign(2 * size, T());
    lazy.assign(2 * size, F());
  }

  template <class U> void build(vector<U> &a, int x, int xl, int xr) {
    if (xr - xl == 1) {
      if (xl < a.size())
        st[x] = T(a[xl]);
      return;
    }
    int xm = (xl + xr) / 2;
    build(a, left(x), xl, xm);
    build(a, right(x), xm, xr);
    st[x] = op(st[left(x)], st[right(x)]);
  }
  template <class U> void build(vector<U> &a) { return build(a, 0, 0, size); }

  T query(int l, int r, int x, int xl, int xr) { // r exclusive
    push(x, xl, xr);
    if (r <= xl || xr <= l)
      return T();
    if (l <= xl && xr <= r)
      return st[x];
    int xm = (xl + xr) / 2;
    return op(query(l, r, left(x), xl, xm), query(l, r, right(x), xm, xr));
  }
  T query(int l, int r) { return query(l, r + 1, 0, 0, size); } // r inlusive

  void update(int l, int r, F v, int x, int xl, int xr) {
    push(x, xl, xr);
    if (r <= xl || xr <= l)
      return;
    if (l <= xl && xr <= r) {
      apply(v, x, xl, xr);
      return;
    }
    int xm = (xl + xr) / 2;
    update(l, r, v, left(x), xl, xm);
    update(l, r, v, right(x), xm, xr);
    pull(x);
  }
  void update(int l, int r, F v) { return update(l, r + 1, v, 0, 0, size); }
};

struct Tag {
  ll b, c;
  Tag(ll b_, ll c_) : b(b_), c(c_) {}
  Tag() : Tag(1, 0) {} // NOOP

  void apply(Tag tag, int xl, int xr) {
    b *= tag.b;
    c = c * tag.b + tag.c;
  }
};
struct Info {
  ll v;
  Info(ll v_) : v(v_) {}
  Info() : Info(0) {} // IDEN

  friend Info op(Info a, Info b) {
    Info ret;
    ret.v = a.v + b.v;
    return ret;
  }
  void apply(Tag tag, int xl, int xr) { v = (v * tag.b) + tag.c * (xr - xl); }
};
using LazySegTree = LazySegmentTree<Info, Tag>;
// @end segTreeLazy
} // namespace Lazy
