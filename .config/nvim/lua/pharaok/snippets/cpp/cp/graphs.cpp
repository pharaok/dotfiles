#include <bits/stdc++.h>
using namespace std;

#define endl '\n'
using ll = long long;

// @begin DSU
struct DSU {
  vector<int> p, sz;
  DSU(int n) {
    p.resize(n);
    iota(p.begin(), p.end(), 0);
    sz.assign(n, 1);
  }
  int find(int u) {
    if (p[u] == u)
      return u;
    return (p[u] = find(p[u]));
  }
  void unite(int u, int v) {
    u = find(u), v = find(v);
    if (u == v)
      return;
    if (sz[u] < sz[v])
      swap(u, v);
    p[v] = u;
    sz[u] += sz[v];
  }
};
// @end DSU

// @begin binaryLifting
struct LCA {
  int _t;
  vector<vector<int>> &_adj;

  int n;
  const int l = 24;
  vector<int> tin, tout;
  vector<vector<int>> up;
  LCA(vector<vector<int>> &adj) : _adj(adj) {
    n = _adj.size();
    tin.resize(n);
    tout.resize(n);
    _t = 0;
    up.assign(n, vector<int>(l));
    dfs(0, 0);
  }
  void dfs(int u, int p) {
    tin[u] = _t++;
    up[u][0] = p;
    for (int i = 1; i < l; i++)
      up[u][i] = up[up[u][i - 1]][i - 1];
    for (int v : _adj[u]) {
      if (v != p)
        dfs(v, u);
    }
    tout[u] = _t++;
  }
  bool is_ancestor(int u, int v) {
    return tin[u] <= tin[v] && tout[v] <= tout[u];
  }
  int lca(int u, int v) {
    if (is_ancestor(u, v))
      return u;
    if (is_ancestor(v, u))
      return v;
    for (int i = l - 1; i >= 0; i--) {
      if (!is_ancestor(up[u][i], v))
        u = up[u][i];
    }
    return up[u][0];
  }
};
// @end LCA
