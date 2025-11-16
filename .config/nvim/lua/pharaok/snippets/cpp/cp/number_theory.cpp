#include <bits/stdc++.h>
using namespace std;

#define endl '\n'
using ll = long long;

// clang-format off
// @begin mint
const int MOD = 1e9 + 7;
struct mint {
  int x;
  mint(ll _x)  {
    x = _x % MOD;
    if (x < 0) x += MOD;
  }

  mint binpow(mint a, ll b) {
    mint res = 1;
    while (b) {
      if (b & 1) res *= a;
      a *= a, b >>= 1;
    }
    return res;
  }

  mint &operator+=(mint other) { x = (x + other.x) % MOD; return *this; }
  mint &operator-=(mint other) { x = (x - other.x + MOD) % MOD; return *this; }
  mint &operator*=(mint other) { x = (1ll * x * other.x) % MOD; return *this; }
  mint &operator/=(mint other) { return (*this *= binpow(other, MOD - 2)); }

  friend mint operator+(mint lhs, mint rhs) { return (lhs += rhs); }
  friend mint operator-(mint lhs, mint rhs) { return (lhs -= rhs); }
  friend mint operator*(mint lhs, mint rhs) { return (lhs *= rhs); }
  friend mint operator/(mint lhs, mint rhs) { return (lhs /= rhs); }
  friend istream &operator>>(istream &is, mint &a) {
    ll x; is >> x;
    a = mint(x);
    return is;
  }
  friend ostream &operator<<(ostream &os, mint a) { return os << a.x; }
};
// @end mint
// clang-format on

// @begin spfSieve
const int MAXP = 1e6;
int spf[MAXP];
vector<int> primes;
void initSpf() {
  for (int i = 2; i < MAXP; i++) {
    if (spf[i] == 0) {
      spf[i] = i;
      primes.push_back(i);
    }
    for (int j = 0; i * primes[j] < MAXP; j++) {
      spf[i * primes[j]] = primes[j];
      if (primes[j] == spf[i])
        break;
    }
  }
}
// @end spfSieve
