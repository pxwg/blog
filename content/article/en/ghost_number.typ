#import "../../../typ/templates/blog.typ": *
#let title = "Ghost Number Anomaly, Riemann-Roch Theorem and VOA"
#show: main.with(
  title: title,
  desc: [Ghost anomaly in bc ghost system could be viewed as Riemann-Roch Theorem],
  date: "2025-09-11",
  tags: (
    blog-tags.physics,
    blog-tags.quantum-field,
  ),
)

= Intro: Monopole inside a Sphere

Consider a monopole inside a sphere $bb(S)^(2)$, there is no global well-defined gauge connection $A$ over $bb(S)^(2)$.
One needs to use some patches ${U_(i)}$ to cover $bb(S)^(2)$, then define $A_(i) in Omega^(1)(U_(i))$ (after identify a reference connection), and using transition functions ${f_("ij")}$ to obtain global $U(1)$ connection.

For the situation of $bb(S)^(2)$, the simplest choice of patches might be 两个半球合在一起，where 两个 patches 的交是一个圆周$bb(S)^(1)$.
Thus, one can easily prove that, the connection could be written as:
$
  A(theta, phi) = cases(
    frac(1, 2) (1-cos theta) dif phi \, theta in (0, pi/2),
    frac(1, 2)(-1 - cos theta) dif phi \, theta in (pi/2, pi)
  ),
$
where the associated gauge curvature could be written as $F = frac(1, 2) dif S$, and the transition function could be written as $upright(e)^(upright(i) phi): A |-> A + dif phi$.
Using the formula above, the flux could be calculated by:
$
  "Flux" = integral_(bb(S)^(2)) F = integral_(U_(1)) dif A + integral_(U_(2)) dif A = integral_(partial U_(1)) A + integral_(partial U_(2)) A = integral_(bb(S)^(1)) dif phi in ZZ.
$

= Ghost System and Ghost Number Flow

Consider the ghost system over a Riemann surface $X$ with conformal weight $(lambda, 0)$ and $(1 - lambda, 0)$:
$
  S = frac(1, 2pi) integral_(X) b overline(diff) c,
$
where $b in Gamma(X, L^(times.circle lambda))$, $c in Gamma(X, K times.circle L^(- times.circle lambda))$, $L$ is a holomorphic line bundle and $K$ is the canonical bundle over $X$.
The energy-momentum tensor is
$
  T(z) = - lambda :b diff c: + (1-lambda) : diff b c :,
$
, and the $U(1)$ current is:
$
  J(z) = :b c: := lim_(w -> z) b(w) c(z) - frac(dif z, w - z),
$
The OPE for the current could be written as
$
  T(z)J(w) = frac(1 - 2 lambda, (z - w)^(3)) dif z + frac(J(w), (z-w)^(2)) + frac(diff_(z) J(w), z- w) + :T(z)J(w):,
$
which implies the current changing while one consider the conformal transformation $z |-> w$:
$
  J(w) = J'(z) + frac(1-2 lambda, 2) diff (ln diff_(z) w),
$
which implies that $J(w)$ is not a primary field.
Thus, the conserved quantity could be naively written as $overline(partial) J(z) = 0$.
This equation is true for any patch $U_(i)$, however, more precisely consideration is needed while we consider the global structre of this field theory.

While we want to glue patches into one dimensional complex manifold, a holomorphic function $f$ satisfies $diff_(z) f(p) != 0$ would play a role as transition function, which indeed is a conformal transformation $z |-> w$.
Thus, recall the discussion in the intro, the integration of $overline(partial) J$ over $X$ should be rephrased as the integration over multiple patches glued by some conformal transformation:
$
  integral_(X) overline(diff) J := sum_(i) integral_(U_(i)) overline(diff) J(z_(i)).
$

Before reveal more abstract structures, consider a simple example $X = bb(S)^(2)$ might be helpful.
In this case, transition function is $omega = frac(1, z)$, thus the integration could be written as:
$
  integral_(X) overline(diff) J = integral_(bb(S)^(1)) (1-2lambda) frac(dif w, w) = 2pi upright(i) (1 - 2lambda).
$
To translate the result above into a more familiar form, note that $dif^(2) sigma = 2 upright(i) dif z dif overline(z)$ and $J(z) = j(z) dif z$, one have
$
  integral_(X) dif^(2) sigma thin overline(partial)_(z) j(z) = pi(1-2 lambda).
$
// TODO: Cech Cohomology

= Zero Modes, Riemann-Roch and Index

The zero mode equation for $b c$ ghost equation could be written as
$
  overline(diff) c = 0, quad overline(diff) b = 0.
$
We denote the number of zero modes for $b$, $c$ fields as $B$ and $C$ respectively.
It is easy to identify that $C = ker(overline(diff)_(K times L^(-lambda)))$ and $B = ker(overline(diff)_(L^(lambda)))$, thus the 零模式的差值将会给出：
$
  C - B = dim(H^(0)(X, cal(O)(K times.circle L^(-lambda)))) - dim(H^(0)(X, cal(O)(L^(lambda)))),
$
using Serre duality $H^(i)(X, cal(O)(K times.circle L^(-lambda))) approx H^(n-i)(X, cal(O)(L^(lambda)))^(or)$, one have (in our case, $n=1$)
$
  C - B = dim(H^(1)(X, cal(O)(L^(lambda)))) - dim(H^(0)(X, cal(O)(L^(lambda)))) := h^(1)(X, cal(O)(L^(lambda))) - h^(0)(X, cal(O)(L^(lambda))),
$
thus the index of elliptic operator $overline(diff)$ could be rephrased as
$
  "ind"(overline(diff)) = B - C.
$

= Vertex Algebra Bundle
