// @begin cp
#include <bits/stdc++.h>
using namespace std;

#define endl '\n'
using ll = long long;

template <class T> void print(T &v) {
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

// @begin rng
mt19937 rng(chrono::steady_clock::now().time_since_epoch().count());
// @end rng

// @begin customHash
struct custom_hash {
  static uint64_t splitmix64(uint64_t x) {
    // http://xorshift.di.unimi.it/splitmix64.c
    x += 0x9e3779b97f4a7c15;
    x = (x ^ (x >> 30)) * 0xbf58476d1ce4e5b9;
    x = (x ^ (x >> 27)) * 0x94d049bb133111eb;
    return x ^ (x >> 31);
  }

  size_t operator()(uint64_t x) const {
    static const uint64_t FIXED_RANDOM =
        chrono::steady_clock::now().time_since_epoch().count();
    return splitmix64(x + FIXED_RANDOM);
  }
};
template <class T, class U>
using unordered_map = unordered_map<T, U, custom_hash>;
template <class T> using unordered_set = unordered_set<T, custom_hash>;
// @end customHash
