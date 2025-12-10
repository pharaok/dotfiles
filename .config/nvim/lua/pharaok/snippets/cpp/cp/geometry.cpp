#include <bits/stdc++.h>
using namespace std;
using ll = long long;

// @begin geo
using T = double;
using pt = complex<T>;
#define x() real()
#define y() imag()

double PI = acos(-1);
T EPS = 1e-9;

int sign(double x) { return x < -EPS ? -1 : x > EPS ? 1 : 0; }
T dot(pt a, pt b) { return (conj(a) * b).x(); }
T cross(pt a, pt b) { return (conj(a) * b).y(); }
T orient(pt a, pt b, pt c) { return cross(b - a, c - a); }
double abs(pt p) { return sqrt(norm(p)); }
double arg(pt p) { return atan2(p.y(), p.x()); }

pt perp(pt p) { return pt(-p.y(), p.x()); }
double angle(pt p, pt q) {
  return acos(clamp(dot(p, q) / abs(p) / abs(q), -1.0, 1.0));
}
double orientedAngle(pt a, pt b, pt c) {
  if (orient(a, b, c) < 0)
    return 2 * PI - angle(b - a, c - a);
  return angle(b - a, c - a);
}
// @end geo

// @begin line
struct line {
  pt v;
  T c;
  line(pt v, T c) : v(v), c(c) {}
  line(T a, T b, T c) : v(perp(pt(a, b))), c(c) {} // ax + by = c
  line(pt p, pt q) : v(q - p), c(cross(v, p)) {}

  T side(pt p) { return cross(v, p) - c; }
  double dist(pt p) { return abs(side(p)) / abs(v); }
  double sqDist(pt p) { return side(p) * side(p) / (double)norm(v); }
  line perpThrough(pt p) { return line(perp(v), cross(perp(v), p)); }
  line translate(pt t) { return line(v, c + cross(v, t)); }

  // T = double
  line shift(double d) { return line(v, c + d * abs(v)); }
  pt perpTo(pt p) { return perp(v) * side(p) / norm(v); }
  pt proj(pt p) { return p - perpTo(p); }
  pt refl(pt p) { return p - T(2) * perpTo(p); }
};
bool inter(line l1, line l2, pt &out) {
  T d = cross(l1.v, l2.v);
  if (d == 0)
    return false;
  out = (l2.v * l1.c - l1.v * l2.c) / d; // T = double
  return true;
}
line bisector(line l1, line l2, bool interior) {
  assert(!interior && cross(l1.v, l2.v) != 0);
  pt v1 = l1.v / T(abs(l1.v)), v2 = l2.v / T(abs(l2.v));
  if (!interior)
    v2 = -v2;
  return line(v1 + v2, l1.c / abs(l1.v) + l2.c / abs(l2.v));
}
// @end line

// @begin seg
bool inDisk(pt a, pt b, pt p) { return dot(a - p, b - p) <= 0; }
bool onSeg(pt a, pt b, pt p) { return orient(a, b, p) == 0 && inDisk(a, b, p); }

bool segSeg(pt a1, pt a2, pt b1, pt b2) {
  if (onSeg(a1, a2, b1) || onSeg(a1, a2, b2) || onSeg(b1, b2, a1) ||
      onSeg(b1, b2, a2))
    return true;
  T oa1 = orient(b1, b2, a1), oa2 = orient(b1, b2, a2),
    ob1 = orient(a1, a2, b1), ob2 = orient(a1, a2, b2);
  if (sign(oa1) != sign(oa2) && sign(ob1) != sign(ob2))
    return true;
  return false;
}
// @end seg

// @begin rayCasting
bool above(pt a, pt p) { return p.y() > a.y(); }
bool crossesRay(pt a, pt p, pt q) {
  return (above(a, q) - above(a, p)) * orient(a, p, q) > 0;
}
bool inPolygon(vector<pt> p, pt a, bool strict = true) {
  int numCrossings = 0;
  for (int i = 0, n = p.size(); i < n; i++) {
    if (onSeg(p[i], p[(i + 1) % n], a))
      return !strict;
    numCrossings += crossesRay(a, p[i], p[(i + 1) % n]);
  }
  return numCrossings & 1; // inside if odd number of crossings
}
// @end rayCasting

// @begin windingNumber
double angleTravelled(pt a, pt b, pt p) {
  return remainder(arg(a - p) - arg(b - p), 2 * PI);
}
int windingNumber(vector<pt> poly, pt p) {
  double a = 0;
  int n = poly.size();
  for (int i = 0; i < n; i++)
    a += angleTravelled(poly[i], poly[(i + 1) % n], p);
  return round(a / 2 / PI);
}
// @end windingNumber

// @begin polygonArea
T area(vector<pt> &p) {
  int n = p.size();
  T ans = 0;
  for (int i = 0; i < n; i++)
    ans += cross(p[i], p[(i + 1) % n]);
  return ans / 2;
}
// @end polygonArea

// @begin convexTest
bool isConvex(vector<pt> p) {
  int s = sign(orient(p[0], p[1], p[2]));
  for (int i = 0, n = p.size(); i < n; i++) {
    if (sign(orient(p[i], p[(i + 1) % n], p[(i + 2) % n])) != s)
      return false;
  }
  return true;
}
// @end convexTest

// @begin convexHull
bool half(pt p) {
  assert(p.x() != 0 || p.y() != 0);
  return p.y() > 0 || (p.y() == 0 && p.x() < 0);
}
vector<pt> convexHull(vector<pt> &pts) {
  pt p0 = *min_element(pts.begin(), pts.end(), [](pt &a, pt &b) {
    return make_pair(a.x(), a.y()) < make_pair(b.x(), b.y());
  });

  sort(pts.begin(), pts.end(), [&](pt a, pt b) {
    a -= p0, b -= p0;
    return make_tuple(half(a), 0, norm(a)) <
           make_tuple(half(b), cross(a, b), norm(b));
  });

  vector<pt> ch;
  for (int i = 0; i < (int)pts.size(); i++) {
    while (ch.size() >= 2 &&
           orient(ch[ch.size() - 2], ch[ch.size() - 1], pts[i]) <= 0)
      ch.pop_back();

    ch.push_back(pts[i]);
  }

  return ch;
}
// @end convexHull

// @begin circle
pt circumCenter(pt a, pt b, pt c) {
  b = b - a, c = c - a;     // consider coordinates relative to A
  assert(cross(b, c) != 0); // no circumcircle if collinear
  return a + perp(b * norm(c) - c * norm(b)) / cross(b, c) / T(2);
}
int circleLine(pt o, double r, line l, pair<pt, pt> &out) {
  double h2 = r * r - l.sqDist(o);
  if (h2 >= 0) {                            // the line touches the circle
    pt p = l.proj(o);                       // point P
    pt h = l.v * T(sqrt(h2)) / T(abs(l.v)); // vector parallel to l, of length h
    out = {p - h, p + h};
  }
  return 1 + sign(h2);
}
// @end circle

// @begin welzl
using circle = pair<double, pt>;

circle welzl(int n, vector<pt> &rem, vector<pt> &p) {
  if (n == 0 || rem.size() >= 3) {
    if (rem.empty())
      return circle();

    pt c;
    if (rem.size() == 1)
      c = rem[0];
    if (rem.size() == 2)
      c = (rem[0] + rem[1]) / 2.0;
    if (rem.size() == 3)
      c = circumCenter(rem[0], rem[1], rem[2]);

    return circle(abs(rem[0] - c), c);
  }
  pt q = p[n - 1];
  circle c = welzl(n - 1, rem, p);
  if (abs(q - c.second) <= c.first + EPS)
    return c;
  rem.push_back(q);
  auto res = welzl(n - 1, rem, p);
  rem.pop_back();
  return res;
}
pair<double, pt> minimumEnclosingCircle(vector<pt> &p) {
  shuffle(p.begin(), p.end(), mt19937(random_device{}()));
  vector<pt> R;
  return welzl((int)p.size(), R, p);
}
// @end
