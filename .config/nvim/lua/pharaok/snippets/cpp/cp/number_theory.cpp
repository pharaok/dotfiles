#include <bits/stdc++.h>
using namespace std;

#define endl '\n'
using ll = long long;

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
