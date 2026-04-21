#include <bits/stdc++.h>
using namespace std;
using ll = long long;

void mos() {
  int n, q;
  vector<int> a;
  vector<array<int, 3>> queries;
  // clang-format off
  // @begin mos
const int BLOCK = 1 << 8;
sort(queries.begin(), queries.end(), [&](auto &a, auto &b) {
  if (a[0] / BLOCK != b[0] / BLOCK)
    return a[0] < b[0];
  return a[0] / BLOCK & 1 ? a[1] < b[1] : a[1] > b[1];
});
auto add = [&](int i) {};
auto remove = [&](int i) {};

int l = 0, r = -1;
for (auto [ql, qr, qi] : queries) {
  while (r < qr)
    add(++r);
  while (l > ql)
    add(--l);
  while (r > qr)
    remove(r--);
  while (l < ql)
    remove(l++);
}
  // @end mos
  // clang-format on
}
