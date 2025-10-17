// @begin cp
#include <bits/stdc++.h>
using namespace std;

#define endl '\n'
using ll = long long;

template <typename T> void print(T &v) {
  for (auto x : v)
    cout << x << ' ';
  cout << endl;
}

void solve() {
  // @0
}
int main() {
  ios_base::sync_with_stdio(0), cin.tie(0);
  // freopen(".in", "r", stdin);
  // freopen(".out", "w", stdout);

  int t = 1;
  cin >> t;
  while (t--)
    solve();

  return 0;
}
// @end cp

// @begin orderedSet
#include <ext/pb_ds/assoc_container.hpp>
#include <ext/pb_ds/tree_policy.hpp>
using namespace __gnu_pbds;

template <class T>
using ordered_set =
    tree<T, null_type, less<T>, rb_tree_tag, tree_order_statistics_node_update>;

template <class T>
using ordered_multiset = tree<T, null_type, less_equal<T>, rb_tree_tag,
                              tree_order_statistics_node_update>;
// @end orderedSet
