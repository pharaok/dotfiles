#include <bits/stdc++.h>
using namespace std;
using ll = long long;

// @begin treap
mt19937 rng(chrono::steady_clock::now().time_since_epoch().count());
using T = int;
struct TreapItem {
  bool rev;
  T val;
  int prio;
  int size;
  TreapItem *parent, *left, *right;
  TreapItem(T v, int p)
      : rev(false), val(v), prio(p), size(1), parent(nullptr), left(nullptr),
        right(nullptr) {}
  TreapItem(T v) : TreapItem(v, rng()) {}
};
using TreapP = TreapItem *;
int size(TreapP t) { return t == nullptr ? 0 : t->size; }
int key(TreapP t) { return size(t->left) + 1; }
void push(TreapP t) {
  if (t == nullptr)
    return;
  if (t->rev) {
    swap(t->left, t->right);
    if (t->left)
      t->left->rev ^= 1;
    if (t->right)
      t->right->rev ^= 1;
    t->rev = 0;
  }
}
void pull(TreapP t) {
  if (t == nullptr)
    return;
  push(t->left), push(t->right);
  t->size = 1 + size(t->left) + size(t->right);
  if (t->left)
    t->left->parent = t;
  if (t->right)
    t->right->parent = t;
}

void split(TreapP t, int cnt, TreapP &l, TreapP &r) {
  if (t == nullptr)
    return void(l = r = nullptr);
  push(t);
  int k = key(t);
  if (k <= cnt)
    split(t->right, cnt - k, t->right, r), l = t;
  else
    split(t->left, cnt, l, t->left), r = t;
  if (l)
    l->parent = nullptr;
  if (r)
    r->parent = nullptr;
  pull(t);
}
void merge(TreapP &t, TreapP l, TreapP r) {
  push(l), push(r);
  if (l == nullptr)
    t = r;
  else if (r == nullptr)
    t = l;
  else if (l->prio > r->prio)
    merge(l->right, l->right, r), t = l;
  else
    merge(r->left, l, r->left), t = r;
  if (t)
    t->parent = nullptr;
  pull(t);
}
void insert(TreapP &t, int cnt, TreapP it) {
  if (t == nullptr)
    return void(t = it);
  push(t);
  int k = key(t);
  if (it->prio > t->prio)
    split(t, cnt, it->left, it->right), t = it;
  else if (k <= cnt)
    insert(t->right, cnt - k, it);
  else
    insert(t->left, cnt, it);
  pull(t);
}
void erase(TreapP &t, int pos) {
  if (t == nullptr)
    return;
  push(t);
  int k = key(t) - 1;
  if (k == pos) {
    TreapP tmp = t;
    merge(t, t->left, t->right);
    delete tmp;
  } else if (k <= pos)
    erase(t->right, pos - k - 1);
  else
    erase(t->left, pos);
  pull(t);
}
void inorder(TreapP t) {
  if (t == nullptr)
    return;
  push(t);
  inorder(t->left);
  cout << t->val << " ";
  inorder(t->right);
}
TreapP find(TreapP t) {
  while (t->parent != nullptr)
    t = t->parent;
  return t;
}
// @end treap
