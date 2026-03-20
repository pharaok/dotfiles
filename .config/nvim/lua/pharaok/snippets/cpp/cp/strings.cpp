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
