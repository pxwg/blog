#import "../../../typ/templates/blog.typ": *
#import "../../../typ/packages/typst-fletcher.typ": *
#let title = "Mixed Anomaly and Riemann-Roch Theorem"
#show: main.with(
  title: title,
  desc: [U(1)-gravity mixed anomaly in bc CFT manifests as Riemann-Roch Theorem],
  date: "2025-09-14",
  tags: (
    blog-tags.physics,
    blog-tags.quantum-field,
  ),
  lang: "en",
  translationKey: "u1_grav",
)

= Introduction: Monopole Inside a Sphere
<intro>

Consider a monopole inside a sphere $bb(S)^(2)$, there is no global well-defined gauge connection $A$ over $bb(S)^(2)$.
One needs to use some patches ${U_(i)}$ to cover $bb(S)^(2)$, then define $A_(i) in Omega^(1)(U_(i))$ (after identify a reference connection), and using transition functions ${f_(i j)}$ to obtain global $U(1)$ connection.

For the situation of $bb(S)^(2)$, the simplest choice of patches might be two hemispheres, where the intersection of two patches is a circle $bb(S)^(1)$.
Thus, one can easily prove that, the connection could be written as:
$
  A(theta, phi) = cases(
    frac(1, 2) (1-cos theta) dif phi \, theta in (0, pi/2),
    frac(1, 2)(-1 - cos theta) dif phi \, theta in (pi/2, pi)
  ),
$
where the associated gauge curvature could be written as $F = frac(1, 2) dif S$, and the transition function could be written as $upright(e)^(i phi): A |-> A + dif phi$.
Using the formula above, the flux could be calculated by:
$
  "Flux" = integral_(bb(S)^(2)) F = integral_(U_(1)) dif A + integral_(U_(2)) dif A = integral_(partial U_(1)) A + integral_(partial U_(2)) A = integral_(bb(S)^(1)) dif phi in ZZ.
$

= bc CFT and U(1) Current

== Local Description

Consider the $b c$ CFT over a Riemann surface $X$ with conformal weight $(lambda, 0)$ and $(1 - lambda, 0)$:
$
  S = frac(1, 2pi) integral_(X) b overline(diff) c,
$
where $b in Gamma(X, L^(times.circle lambda))$, $c in Gamma(X, K times.circle L^(- times.circle lambda))$, $L$ is a holomorphic line bundle and $K$ is the canonical bundle over $X$.


Now we consider the local description of this CFT over a patch $U approx bb(C)$ with local coordinate $z$.
The energy-momentum tensor under this coordinate is given by:
$
  T(z) = - lambda :b diff c: + (1-lambda) : diff b c :,
$
and the $U(1)$ current is:
$
  J(z) = :b c: := lim_(w -> z) b(w) c(z) - frac(dif z, w - z),
$
The OPE for the current could be written as:
$
  T(z)J(w) = frac(1 - 2 lambda, (z - w)^(3)) dif z + frac(J(w), (z-w)^(2)) + frac(diff_(z) J(w), z- w) + :T(z)J(w):,
$
which implies the current changing while one consider the conformal transformation $z |-> w$:
$
  J(w) = J'(z) + frac(1-2 lambda, 2) diff (ln diff_(z) w) = J'(z) + frac(1 - 2 lambda, 2) dif (ln diff_(z) w).
$
The last equality holds because the conformal translation is _holomorphic_.
This translation formula implies that $J(w)$ is not a primary field.

The conserved quantity here from classical mechanics could be naively written as $integral_(Sigma) overline(diff) J dif x =0$.
This equation is true on $CC$ with compact supported $b c$ fields.
However, more precisely consideration is needed while we consider the global structre of this field theory.

== Glue Patches from Local Data

While we want to glue patches into one dimensional complex manifold, a holomorphic function $f$ satisfies $diff_(z) f(p) != 0$ would play a role as _transition function_, which indeed is a conformal transformation $z |-> w$.
Thus, recall the discussion in the intro, the integration of $overline(partial) J$ over $X$ should be rephrased as the integration over multiple patches glued by some conformal transformation:
$
  integral_(X) overline(diff) J := sum_(i) integral_(U_(i)) overline(diff) J(z_(i)).
$
Here we chose a good over $U_(i)$ of $X$ and attach local coordinates ${z_(i)}$ on each patch.
Since $J(z_(i))$ is $(1,0)$ form over $U_(i)$, the integration above could be rewritten as:
$
  integral_(X) overline(diff) J := sum_(i) integral_(U_(i)) dif J(z_(i)).
$

Given a (good) cover $cal(U) := {U_(i)}$ of $X$, transition function is given by $f_(i j): z_(j) |-> f_(i j)(z_(i))$, thus the current on two patches are related by:
$
  J(z_(j)) = J(z_(i)) + frac(1 - 2 lambda, 2) dif (ln diff_(z_(i)) f_(i j)).
$
For now, we have met a similar situation as the monopole inside a sphere, where the current $J$ plays the role of gauge connection $A$ which might not be globally well-defined.

A way to formulate the consideration in the intro, where we first integrate $dif J$ over each patch, then sum them up with the transition function.

// == Čech Complex and First Chern Class

One can embed the consideration above into _Čech complex_, where $J(z_(i))$ is an element in $C^(0)(cal(U), Omega^(1))$, and $frac(1 - 2 lambda, 2) dif (ln diff_(z_(i)) f_(i j))$ is an element in $C^(1)(cal(U), Omega^(1))$, where:
- The first cohomology degree in $C^(bullet)$ is the intersection number of patches, e.g., $U_(i)$ is an element in $C^(0)$, $U_(i) inter U_(j)$ is an element in $C^(1)$ and so on.
- The second cohomology degree in $Omega^(bullet)$ denotes the degree of differential forms, e.g., $Omega^(0)$ is degree $0$ form (function), $Omega^(1)$ is degree $1$ form and so on #footnote([$(1,0)$ form over $U_(i)$ could be naturally embedded into $C^(0)(cal(U), Omega^(1))$, so that we write $J in C^(0)(cal(U), Omega^(1))$.]).
And the associated Čech differential is induced by:
- $delta: C^(p)(cal(U), Omega^(q)) |-> C^(p+1)(cal(U), Omega^(q))$, where $delta: f_(i_1,...,i_(n)) |-> (delta f)_(i_1, ..., i_(n), i_(n+1))$.
- $dif: C^(p)(cal(U), Omega^(q)) -> C^(p)(cal(U), Omega^(q+1))$ is the standard _de Rham differential_ over a patch $U_(i_1, ..., i_(n))$.

Therefore, the transition of current $J$ could be rephrased as:
$
  delta J_(i j) = frac(1 - 2 lambda, 2) dif (ln diff_(z_(j)) f_(i j)),
$
which could be rewritten as:

// TODO: better function to draw commutative diagram for html output
#if get-target() == "web" {
  theme-frame(
    tag: "span",
    theme => {
      let edge = edge.with(stroke: theme.main-color)
      let it = [$
          #align(center, diagram(
            cell-size: (1mm, 1mm),
            $J_(i) edge(delta, ->) & delta J_(i j)\
            & edge("u", dif, ->) frac(1-2 lambda, 2) ln diff_(z_(j)) f_(i j),$,
          ))\
          quad
        $]
      set text(fill: theme.main-color, size: math-size, font: math-font)
      span-frame(attrs: (class: "block-equation"), it)
    },
  )
}
where the arrow $a ->^(delta) b$ denotes $b = delta a$.
Moreover, since transition functions satisfying the condition
$
  diff_(z_(j)) f_(i j) diff_(z_(k)) f_(j k) diff_(z_(i)) f_(k i) = 1 := e^(2 i pi n_(i j k)),
$
we have:

#if get-target() == "web" {
  theme-frame(
    tag: "span",
    theme => {
      let edge = edge.with(stroke: theme.main-color)
      let it = [$
          #align(center, diagram(
            cell-size: (1mm, 1mm),
            $J_(i) edge(delta, ->) & delta J_(i j) \
            & edge("u", dif, ->) frac(1-2 lambda, 2) ln diff_(z_(j)) f_(i j) edge(delta, ->) & (1-2 lambda) i pi n_(i j k) \
            & & edge("u", dif, ->) (1-2 lambda) i pi n_(i j k) edge(delta, ->) & 0,$,
          ))\
          quad
        $]
      set text(fill: theme.main-color, size: math-size, font: math-font)
      span-frame(attrs: (class: "block-equation"), it)
    },
  )
}
where $dif$ would act as an embedding $ZZ arrow.hook Omega^(0)(U_(i j k))$ for $n_(i j k)$.
Note that our integration is over $X$ for $overline(diff) J$, then we need to include $overline(diff) J = dif J$ into the consideration, thus we have:

#if get-target() == "web" {
  theme-frame(
    tag: "span",
    theme => {
      let edge = edge.with(stroke: theme.main-color)
      let it = [$
          #align(center, diagram(
            cell-size: (1mm, 1mm),
            $0 \
            edge("u", dif, ->) omega edge(delta, ->) & dif J_(i) \
            & edge("u", dif, ->) J_(i) edge(delta, ->) & delta J_(i j) \
            & & edge("u", dif, ->) frac(1-2 lambda, 2) ln diff_(z_(j)) f_(i j) edge(delta, ->) & (1-2 lambda) i pi n_(i j k) \
            & & & edge("u", dif, ->) (1-2 lambda) i pi n_(i j k) edge(delta, ->) & 0,$,
          ))\
          quad
        $]
      set text(fill: theme.main-color, size: math-size, font: math-font)
      span-frame(attrs: (class: "block-equation"), it)
    },
  )
}
where $delta$ is the restriction of a smooth form to the intersection of patches, i.e. $delta: omega |-> omega|_(U_(i))$, for $omega in Omega^(2)(X)$.

Using the diagram above, we could replace the ill-defined integration of $overline(diff) J$ over $X$ by the well-defined integration of $dif J_(i)$ over each patch $U_(i)$, then by the globally well-defined $2$-form $omega in Omega^(2)(X)$.

Moreover, the diagram above hints that, the integration of $omega$ over $X$ would descend to the sum of $(1- 2 lambda) i pi n_(i j k)$ over all $U_(i j k)$.
To see this, we consider the nerve of cover $cal(U)$, which is a simplicial complex constructed from $cal(U)$.
See the figure below for an example of nerve of cover (and its dual).
#image_viewer(
  path: "../assets/u1_grav_nerve.png",
  desc: [Nerve of cover and its dual],
  dark-adapt: true,
  adapt-mode: "invert-no-hue",
)



Therefore, the integral of $overline(diff) J$ over Riemann surface $X$ gives
$
  integral_(X) overline(diff) J = (1 - 2 lambda) pi i c_(1)(L),
$
where $c_(1)(L) in H^(2)(X, ZZ)$ is the first Chern class of line bundle $K$.
Substituting $c_(1)(L) = chi(L) = 2 - 2g$, we obtain
$
  integral_(X) dif^(2) sigma thin overline(partial)_(z) j(z) = pi frac(1 - 2 lambda, 2) chi(L).
$

= Zero Modes, Riemann-Roch and Index

The zero mode equation for $b c$ ghost equation could be written as
$
  overline(diff) c = 0, quad overline(diff) b = 0.
$
We denote the number of zero modes for $b$, $c$ fields as $B$ and $C$ respectively.
It is easy to identify that $C = ker(overline(diff)_(K times.circle L^(-lambda)))$ and $B = ker(overline(diff)_(L^(lambda)))$, thus the difference of the zero modes is given by:
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
i.e., the difference of zero modes is the index of $overline(diff)$ operator acting on sections of bundle $L^(lambda)$.
Moreover, it is well-known that the difference of zero modes could be rephrased as the charge of ghost number current, which is given by the $U(1)$ generator
$
  Q := integral_(X) (c frac(delta, delta c) + b frac(delta, delta b)) = frac(1, pi)integral_(X) overline(diff) J(z) = frac(2 i, pi) integral_(X) dif^(2) z thin overline(diff)_(z) j(z),
$
the minus sign comes from the fermionic nature of $b$ field.

Recalling our previous result, this actually gives the relationship between ghost number and manifold Euler characteristic:
$
  Q = (1 - 2 lambda) chi(L) = "deg"(L^(lambda))+ 1- g,
$
Noting the equivalence between ghost number and index, we finally obtain the index theorem for elliptic operator $overline(partial)$
$
  "ind"(overline(partial)_(L^(lambda))) = (1 - 2 lambda) chi(L) = "deg"(L^(lambda)) + 1 - g,
$
Using the index expression $"ind"(overline(diff)) = h^(0)(X, cal(O)(L^(lambda))) - h^(1)(X, cal(O)(L^(lambda)))$, this is precisely the Riemann-Roch theorem:
$
  h^(0)(X, cal(O)(L^(lambda))) - h^(1)(X, cal(O)(L^(lambda))) = "deg"(L^(lambda)) + 1 - g.
$
Using the line bundle-divisor correspondence, this theorem can be transformed into the standard form found in textbooks.
//
// = Vertex Algebra Bundle
//
// Recall the discussion above, the most important part is the transition function for $J(z)$, which is given by conformal transformation $f_(i j): z_(j) |-> f_(i j)(z_(i))$.
// Locally (over the punctured plane $bb(C) - upright(p t)$), the $b c$ ghost system could be described by a vertex algebra $V_(lambda)$ generated by fields $Y(b,z)$ and $Y(c,z)$ with OPEs:
// $
//   Y(b, z)Y(c, w) ~ frac(dif z, z - w).
// $
// Moreover, while introducing the energy-momentum tensor $Y(T,z)$ and $U(1)$ current $Y(J,z)$, the additional OPEs are:
// $
//   Y(T, z)Y(J, w) = frac(1 - 2 lambda, (z - w)^(3)) dif z + frac(Y(J, w), (z-w)^(2)) + frac(diff_(z) Y(J,w), z- w) + :Y(T,z) Y(J, w): ... thin ,
// $
// 我们省略了一些不必要的 OPEs.
// While we want to glue the local vertex algebra $V_(lambda)$ into global, we have to consider how the transition function $f_(i j)$ acts on $V_(lambda)$.
