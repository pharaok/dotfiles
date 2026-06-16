#include <bits/stdc++.h>
using namespace std;
using ll = long long;

// @begin kmp
vector<int> prefix_function(const string &s) {
  int n = s.length();
  vector<int> pi(n);
  for (int i = 1; i < n; i++) {
    int j = pi[i - 1];
    while (j > 0 && s[i] != s[j])
      j = pi[j - 1];
    if (s[i] == s[j])
      j++;
    pi[i] = j;
  }
  return pi;
}
// @end kmp

// @begin kmpAutomaton
vector<vector<int>> compute_automaton(string s) {
  s += '#';
  int n = s.size();
  vector<int> pi = prefix_function(s);
  vector<vector<int>> aut(n, vector<int>(26));
  for (int i = 0; i < n; i++) {
    for (int c = 0; c < 26; c++) {
      if (i > 0 && 'a' + c != s[i])
        aut[i][c] = aut[pi[i - 1]][c];
      else
        aut[i][c] = i + ('a' + c == s[i]);
    }
  }
  return aut;
}
// @end kmpAutomaton

// @begin zFunction
vector<int> z_function(const string &s) {
  int n = s.size();
  vector<int> z(n);
  int l = 0, r = 0;
  for (int i = 1; i < n; i++) {
    if (i < r)
      z[i] = min(r - i, z[i - l]);
    while (i + z[i] < n && s[z[i]] == s[i + z[i]])
      z[i]++;
    if (i + z[i] > r)
      l = i, r = i + z[i];
  }
  return z;
}
// @end zFunction

namespace Trie {
// @begin trie
struct Trie {
  int count;
  Trie *children[26];
  Trie() : count(0) { fill(children, children + 26, nullptr); }

  void insert(string &s, int m = 1) {
    auto cur = this;
    for (char c : s) {
      int x = c - 'a';
      if (cur->children[x] == nullptr)
        cur->children[x] = new Trie();
      cur = cur->children[x];
      cur->count += m;
    }
  }
  int query(string &s) {
    auto cur = this;
    for (int i = 0; i < s.size(); i++) {
      int x = s[i] - 'a';
      if (cur->children[x] == nullptr || cur->children[x]->count <= 0)
        return 0;
      cur = cur->children[x];
    }
    return cur->count;
  }
};
// @end trie
} // namespace Trie

namespace BinaryTrie {
// @begin binaryTrie
struct Trie {
  const int B = 30;
  int count;
  Trie *children[2];
  Trie() : count(0) { fill(children, children + 2, nullptr); }

  void insert(ll s, int d = 1) {
    auto cur = this;
    for (int i = B; i >= 0; i--) {
      int x = (s >> i) & 1;
      if (cur->children[x] == nullptr)
        cur->children[x] = new Trie();
      cur = cur->children[x];
      cur->count += d;
    }
  }
  ll maxXor(ll s) {
    auto cur = this;
    ll ans = 0;
    for (int i = B; i >= 0; i--) {
      int k = s >> i & 1;
      if (cur->children[!k] != nullptr && cur->children[!k]->count > 0)
        cur = cur->children[!k], ans <<= 1, ans++;
      else
        cur = cur->children[k], ans <<= 1;
    }
    return ans;
  }
  ll minXor(ll s) {
    auto cur = this;
    ll ans = 0;
    for (int i = B; i >= 0; i--) {
      int k = s >> i & 1;
      if (cur->children[k] != nullptr && cur->children[k]->count > 0)
        cur = cur->children[k], ans <<= 1;
      else
        cur = cur->children[!k], ans <<= 1, ans++;
    }
    return ans;
  }
};
// @end binaryTrie
} // namespace BinaryTrie

namespace stringHash {
template <class T> T binpow(T a, ll b) {
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
    if (v < 0)
      v += M;
  }

  bool operator==(ModInt o) const { return v == o.v; };
  bool operator!=(ModInt o) const { return v != o.v; };

  ModInt &operator+=(ModInt o) {
    v = (v + o.v) % M;
    return *this;
  }
  ModInt &operator-=(ModInt o) {
    v = (v - o.v + M) % M;
    return *this;
  }
  ModInt &operator*=(ModInt o) {
    v = (1ll * v * o.v) % M;
    return *this;
  }
  ModInt &operator/=(ModInt o) { return (*this *= binpow(o, M - 2)); }

  friend ModInt operator+(ModInt a, ModInt b) { return (a += b); }
  friend ModInt operator-(ModInt a, ModInt b) { return (a -= b); }
  friend ModInt operator*(ModInt a, ModInt b) { return (a *= b); }
  friend ModInt operator/(ModInt a, ModInt b) { return (a /= b); }
  friend istream &operator>>(istream &is, ModInt &a) {
    ll x;
    is >> x;
    a = ModInt(x);
    return is;
  }
  friend ostream &operator<<(ostream &os, ModInt a) { return os << a.v; }
};

// @begin stringHash

using M0 = ModInt<1'000'002'821>;
using M1 = ModInt<1'000'002'823>;
// using M3 = ModInt<1'000'002'827>;
struct H {
  M0 h0;
  M1 h1;
  H operator+(H o) { return {h0 + o.h0, h1 + o.h1}; }
  H operator-(H o) { return {h0 - o.h0, h1 - o.h1}; }
  H operator*(H o) { return {h0 * o.h0, h1 * o.h1}; }
  H operator/(H o) { return {h0 / o.h0, h1 / o.h1}; }
  bool operator==(H o) { return h0 == o.h0 && h1 == o.h1; }
};
const H BASE = {31, 37};
const int MAXL = 1e6;
vector<H> hpow, invhpow;
void initPow() {
  hpow[0] = {1, 1};
  for (int i = 1; i < MAXL; i++)
    hpow[i] = hpow[i - 1] * BASE;
  invhpow[MAXL - 1] = H(1, 1) / hpow[MAXL - 1];
  for (int i = MAXL - 2; i >= 0; i--) {
    auto [p0, p1] = invhpow[i + 1];
    invhpow[i] = invhpow[i + 1] * BASE;
  }
}
vector<H> stringHashes(string &s) {
  int n = s.size();
  vector<H> hashes(n + 1);
  H cur = {1, 1};
  for (int i = 0; i < n; i++) {
    int x = s[i] - 'a' + 1;
    hashes[i + 1] = hashes[i] + H(x, x) * cur;
    cur = cur * BASE;
  }
  return hashes;
}
H substringHash(vector<H> &hashes, int l, int r) {
  return (hashes[r + 1] - hashes[l]) * invhpow[l];
}
// @end stringHash
} // namespace stringHash
