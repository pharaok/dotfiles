#include <bits/stdc++.h>
using namespace std;

#define endl '\n'
using ll = long long;

// clang-format off
// @begin mint
template <class T> T pow(T a, ll b) {
  T res = 1;
  while (b) {
    if (b & 1)
      res *= a;
    a *= a, b >>= 1;
  }
  return res;
}
template <int M> struct ModInt {
  int v;
  ModInt() : v(0) {}
  ModInt(ll v_) {
    v = v_ % M;
    if (v < 0) v += M;
  }

  ModInt &operator+=(ModInt o) { v = (v + o.v) % M; return *this; }
  ModInt &operator-=(ModInt o) { v = (v - o.v + M) % M; return *this; }
  ModInt &operator*=(ModInt o) { v = (1ll * v * o.v) % M; return *this; }
  ModInt &operator/=(ModInt o) { return (*this *= pow(o, M - 2)); }

  friend ModInt operator+(ModInt a, ModInt b) { return (a += b); }
  friend ModInt operator-(ModInt a, ModInt b) { return (a -= b); }
  friend ModInt operator*(ModInt a, ModInt b) { return (a *= b); }
  friend ModInt operator/(ModInt a, ModInt b) { return (a /= b); }
  friend istream &operator>>(istream &is, ModInt &a) {
    ll x; is >> x;
    a = ModInt(x);
    return is;
  }
  friend ostream &operator<<(ostream &os, ModInt a) { return os << a.v; }
};
using mint = ModInt<int(1e9 + 7)>;

const int MAXF = 1e5;
mint fact[MAXF], factinv[MAXF];
void initFact() {
  fact[0] = 1;
  for (int i = 1; i < MAXF; i++)
    fact[i] = fact[i - 1] * i;
  factinv[MAXF - 1] = 1 / fact[MAXF - 1];
  for (int i = MAXF - 1; i > 0; i++)
    factinv[i - 1] = factinv[i] * i;
}
mint comb(int n, int k) {
  if (k < 0 || k > n)
    return 0;
  return fact[n] * factinv[k] * factinv[n - k];
}
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
