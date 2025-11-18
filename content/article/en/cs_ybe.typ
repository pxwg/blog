#import "../../../typ/templates/blog.typ": *
#import "../../../typ/packages/typst-fletcher.typ": *
#import "../../../typ/packages/physica.typ": *
#import "../../../typ/packages/ctez/src/canvas.typ": canvas
#import "../../../typ/packages/ctez/src/draw.typ"

#let title = "Chern Simons Theory and Yang-Baxter Equation"
#show: main.with(
  title: title,
  desc: [The Kontsevich integral could be found in perturbative Chern-Simons theory, which could be associated with the Yang-Baxter equation and R matrix.],
  date: "2025-11-18",
  tags: (
    blog-tags.math,
    blog-tags.physics,
    blog-tags.topology,
  ),
  lang: "en",
  translationKey: "cs_ybe",
)
#let CS = math.upright("CS")
#let wedge = math.and
#let GL = math.upright("GL")
#let Conf = math.upright("Conf")
#let Hol = math.upright("Hol")


#let string-diagram(top-conn, bottom-conn, color: color) = {
  let x = (0, 4, 8)
  let y = (3, 9)
  let height = 12

  let hline(conn, y-level) = {
    let (x1, x2) = if conn == "12" {
      (x.at(0), x.at(1))
    } else if conn == "13" {
      (x.at(0), x.at(2))
    } else {
      (x.at(1), x.at(2))
    }

    draw.line((x1, y-level), (x2, y-level), stroke: color)
    draw.circle((x1, y-level), radius: 0.6, stroke: color)
    draw.circle((x2, y-level), radius: 0.6, stroke: color)
  }

  canvas(length: 1pt, {
    for i in (0, 1, 2) {
      draw.line((x.at(i), 0), (x.at(i), height), stroke: color)
    }
    hline(top-conn, y.at(1))
    hline(bottom-conn, y.at(0))
  })
}

#let equation-frame(content) = {
  let target = get-target()
  if target == "web" or target == "html" {
    theme-frame(
      tag: "div",
      theme => {
        let edge = edge.with(stroke: theme.main-color)
        let diagram = string-diagram.with(color: theme.main-color)

        let it = [$
            #{ if type(content) == function { content(diagram) } else { content } }
          $]
        set text(fill: theme.main-color, size: math-size, font: math-font)
        span-frame(attrs: (class: "block-equation"), it)
      },
    )
  } else {
    if type(content) == function {
      content(string-diagram.with(color: white))
    } else {
      content
    }
  }
}

= Chern-Simons Theory

Chern-Simons theory is a topological version of Yang-Mills theory defined on a three-dimensional manifold $X$.
In this case, the gauge connection $A$ takes values in the Lie algebra $frak(g)$ of the gauge group $G$, and the Chern-Simons action is given by:
$
  CS_(X)[A] = integral_(X) tr(A d A + 2/3 A^(3)),
$
where $A$ is a connection 1-form on a principal $G$-bundle over $X$.
In physical literature, people often consider the Chern-Simons action with a coupling constant $k$:
$
  S^(k)_(CS)[A] = k / (4 pi) CS_(X)[A].
$
where $k$ is quantized to ensure gauge invariance at the quantum level.
Formally, using the path integral formalism, the partition function of Chern-Simons theory is formally given by:
$
  Z^(k)_(CS)(X) = integral d mu_(X)[A] thin e^(i S^(k)_(CS)[A]),
$
i.e., integrating over the quotient space of the space of all connections in $G$-bundles over $X$ modulo gauge transformations.

At the perturbative level, one can expand the partition function around flat connections $A_0$ satisfying $F_(A_0) = 0$, which is the classical equation of motion derived from the Chern-Simons action.

== Wilson Loops

The gauge-invariant observables in Chern-Simons theory are _Wilson loops_, which are defined with data $(K, rho)$, where $K: SS^(1) arrow.hook X$ is a knot embedded in $X$, and $rho: G -> GL(V)$ is a representation of the gauge group $G$ on a vector space $V$, and could be written as:
$
  W_(K)(rho) = tr_(rho) cal(P) exp(integral_(K) i A),
$
where $cal(P) exp$ denotes the path-ordered exponential along the knot $K$.

In our previous blog about #link("../anyon_cs/")[anyons], such Wilson loop observable could be interpreted as the world line of a particle moving in $X$ and carrying some charge under the gauge group $G$.
Where the charge of this particle is labeled by the representation $rho$.

#remark(
  [In physical point of view, the Wilson loop could be interpreted as following:
    - $K$ with some proper restriction (Morse knot) $<=>$ world line of a particle moving in $X$.
    - $rho$ $<=>$ charge of this particle under the gauge group $G$.
    Where Morse knot means the height function (w.r.t. some fixed direction, which is time direction in physics) restricted to the knot is a Morse function.
  ],
)

The quantum expectation value of a Wilson loop could be formally defined as:
$
  angle.l W_(K_1)(rho_1) ... W_(K_(n))(rho_(n)) angle.r = frac(1, Z_(CS)(X)) integral d mu_(X)[A] thin e^(i S_(CS)[A]) W_(K_1)(rho_1) ... W_(K_(n))(rho_(n)).
$
As a remarkable fact, due to the work of #link("https://link.springer.com/article/10.1007/BF01217730")[Witten], these expectation values yield topological invariants (Jones polynomial) of the knots and links in $X = SS^(3)$.

Witten's approach uses non-perturbative methods, relating Chern-Simons theory to conformal field theory (Wess-Zumino-Witten theory) on the boundary of $X$, and employing surgery techniques to compute these invariants.

A natural question is: can we recover these knot invariants using perturbative methods?
At this level, an natural expectation is, the result would (at least formally) correspond to the Taylor coefficients of some knot polynomial invariants, and each coefficient could be a new knot invariant.
In this blog, we would see that this is indeed the case.

= Kontsevich Integral from Chern-Simons Theory

From now on, we assume $X = RR times Sigma$, where $Sigma$ is a Riemann surface and $RR$ denotes the time direction.
In this case, the Morse knots could be defined with respect to the height function along the $RR$ direction.

We also choose a set of bases ${t_(a)}$ for gauge Lie algebra $frak(g)$, such that $tr(t_(a) t_(b)) = delta_(a b)$, $[t_i, t_j] = f_(i j)^(k) t_(k)$.
Then the gauge connection $A$ could be expressed as $A = A^(a) t_(a)$, where $A^(a) in Omega^(1)(X)$ are ordinary 1-forms on $X$ (after choosing a reference trivialization of the principal $G$-bundle).

To perform perturbative expansion, we need to fix a gauge.
In this case, a natural gauge fixing condition could be realized following.
First, using the complex structure on $Sigma$, we could introduce complex coordinates $(z, overline(z))$ on $Sigma$.
Then the gauge connection $A$ could be decomposed as:
$
  A(z, overline(z), t) = A_t d t + A_z d z + A_(overline(z)) d overline(z).
$
We shell impose the _axial gauge_ condition (a.k.a _holomorphic gauge_) $A_(overline(z)) = 0$.
Thus, the gauge connection reduces to $A(z, t) = A_(0) d t + A_(z) d z$, and the Chern-Simons action simplifies to:
$
  CS_(X)[A] := integral_(X) A overline(diff)_(t) A,
$
where $overline(diff)_(t) := d t overline(partial)$.
Under this gauge fixing, the path integral would be reduced to a purely Gaussian integral.

To using the perturbative method, we need to compute the propagator (two-point correlation function) of the gauge field $A$.
At the axial gauge, the propagator could be computed as:
$
  angle.l A_(i)^(a)(z_1, t_1) A_(j)^(b)(z_2, t_2) angle.r = delta^(a b) frac(1, i k) frac(d z_1 - d z_2, z_1 - z_2) delta(t_1 - t_2).
$

Thus, the expectation value of Wilson loops could be computed using Wick's theorem.
To compute this expectation value, we choose a Morse knot $K$ embedded in $X$ and a parameterization $gamma: [0, 1] arrow.hook K subset X$ of the knot.
Then the Wilson loop observable could be expanded as:
$
  W_(K)(rho) = 1 + sum_(n=1)^(oo) i^(n) tr_(rho) integral_(0 <= t_1 <= ... <= t_n <= 1) A(gamma(t_1)) ... A(gamma(t_n)),
$
using the decomposition of the gauge field $A = A^(a) t_(a)$, we could rewrite this as:
$
  W_(K)(rho) & = 1 + sum_(n=1)^(oo) i^(n) sum_(a_1, ..., a_n) tr_(rho)(t_(a_1) ... t_(a_n)) integral_(0 <= t_1 <= ... <= t_n <= 1) A^(a_1)(gamma(t_1)) ... A^(a_n)(gamma(t_n)).
$
Thus, the expectation value could be computed with:
$
  angle.l A^(a_1)(z(t_1), t_1) ... A^(a_(2n))(z(t_(2n)), t_(2n))angle.r = (frac(1, i k))^(n) tr_(rho) sum_(P) (-1)^(\# arrow.b P) wedge.big_(l in P) frac(d z_(l_1) - d z_(l_2), z_(l_1) - z_(l_2)) delta(t_(l_1) - t_(l_2)),
$
where $P$ is a pairing of the set ${1, ..., 2n}$, each pair $l in P$ consists of two elements $(l_1, l_2)$, and $\# arrow.b P$ denotes the number of arcs that are oriented downwards when equipped with the inherited orientation from $K$.

After integrating out the delta functions, the linked vertex would live at a same time slice along the $RR$ direction.
Thus, the expectation value of the Wilson loop could be expressed as:
$
  angle.l W_(K)(rho) angle.r = sum_(n=0)^(oo) frac(1, k^(n)) tr_(rho)Phi_(n)(K),
$
where $Phi_(n)(K)$ is called the _Kontsevich integral_ of the knot $K$, which could be expressed as:
$
  Phi_(n)(K) = sum_(P) wedge.big_(l in P) (-1)^(\# arrow.b P) integral_(0 <= t_1 <= ... <= t_(n) <= 1) frac(d z_(l_1) - d z_(l_2), z_(l_1) - z_(l_2)) Omega_(l).
$
where $Omega_(l) = rho(t_(l_1)) times.circle rho(t_(l_2))$ is an double insertion of Lie algebra elements at the points $gamma(t_(l_1))$ and $gamma(t_(l_2))$ on the knot, which could be read from "linking" the knot at these two points with weight $Omega_(l)$.

It is not hard to see that, the definition of $Phi_(n)(K)$ is (the non-abelian generalization of) the time evolution operator we constructed in the anyon system discussed in #link("../anyon_cs")[previous blog].
So, you may think that the Kontsevich integral could be interpreted as the time evolution operator of some anyon system moving along the world line $K$ in the presence of statistics interaction.

#remark(
  [Well, there is an additional factor $(-1)^(\# arrow.b P)$ in the definition of $Phi_(n)(K)$, which is absent in the anyon system.
    This is because, in the anyon system, the height function should have no critical points along the world line, thus, such factor is always trivial.
    Thus, in this sense, Chern-Simons theory includes the "anti-anyon" effect naturally, which is absent in the simple anyon system we constructed above.

    An interesting question is, could we construct some anyon system that includes such "anti-anyon" effect?
  ],
)

== Example: R-matrix from Kontsevich Integral

We consider a simple braiding configuration of two strands, which is a simple Morse knot embedded in $RR times CC$.

The intersection of two strands at a time slice would become two distinct points $z_1, z_2$ in $CC$.
Using the Kontsevich integral construction, the only nontrivial contribution comes from the $n$-th copy of the gauge connection over these two points, which yields #footnote([This is the simplest case of the so-called connected diagram expansion in quantum field theory.]):
$
  angle.l W_(K)(rho) angle.r = tr_(rho) sum_(n=0)^(oo) frac(1, k^(n)) frac(1, n!) (Phi_(1)(K))^(n) ,
$
where $Phi_1(K)$ could be computed as:
$
  Phi_1(K) = integral.cont frac(d z, z) Omega = 2 pi i Omega,
$
thus, the expectation value could be expressed as:
$
  angle.l W_(K)(rho) angle.r = tr_(rho) exp(frac(2 pi i, k) Omega),
$
which is exactly (before taking the trace) the quantum _R-matrix_ acting on the tensor product representation $rho^(times.circle 2): frak(g) times.circle frak(g) -> GL(V times.circle V)$.

// Axial Gauge -> Kont. integral -> KZ connection

= Knizhnik Zamolodchikov Connection

Now we consider the physical interpretation of the expectation value we constructed above.
To achieve this goal, let us consider a (seemly) independent problem arise from conformal field theory.

In the studying of conformal field theory with gauge symmetry, Knizhnik and Zamolodchikov discovered a remarkable differential equation satisfied by the correlation functions of primary fields in the Wess-Zumino-Witten (WZW) model.

Consider $n$ distinct points ${z_1, ..., z_n}$ in the complex plane $CC$, and associate to each point $z_i$ a representation $rho_i: frak(g) -> GL(V_i)$ of the Lie algebra $frak(g)$.
The Knizhnik-Zamolodchikov (KZ) equation is a system of first-order differential equations for a function $F: Conf_(n)(CC) -> V_1 times.circle ... times.circle V_n$, where $Conf_(n)(CC) = {(z_1, ..., z_n) in CC^(n) | z_i != z_j, forall i != j}$ is the configuration space of $n$ distinct points in $CC$:
$
  (diff F) / (diff z_i ) - 1 / (k + h^(or)) sum_(i > j) Omega_(i j) / (z_i - z_j) F = 0, thin forall i = 1, ..., n,
$
where $h^(or)$ is the dual Coxeter number of the Lie algebra $frak(g)$, and $Omega_(i j)$ is the _Casimir element_ acting on the $i$-th and $j$-th factors of the tensor product $V_1 times.circle ... times.circle V_n$, defined as:
$
  Omega_(i j) = sum_(a) rho_i (t_(a)) times.circle rho_j (t_(a)).
$

By definition, the KZ equation describes a local system over the configuration space $Conf_(n)(CC)$, which could be interpreted as a flat connection $nabla_("KZ")$.

The proof of flatness is a direct computation.
However, there are some VERY important consequences of this flatness, so I highly recommend you to read it.

#proof(
  [
    Since $(d z)/z$ is already a closed form, we only need to check that $A_("KZ") wedge A_("KZ") = 0$, where $A_("KZ") = 1 / (k + h^(or)) sum_(i < j) Omega_(i j) d log(z_i - z_j)$.
    We denote $g_(i j) = d log(z_(i) - z_(j))$, we have an important identity (Arnold's identity):
    $
      g_(i j) wedge g_(j k) + g_(j k) wedge g_(k i) + g_(k i) wedge g_(i j) = 0.
    $
    Thus, the verifying of $A_("KZ") wedge A_("KZ") = 0$ could be reduced to checking the following identity:
    $
      [Omega_(i j), Omega_(i k) + Omega_(j k)] = 0,
    $
    which is essentially the _classical Yang-Baxter equation_, could be verified directly using the definition of $Omega_(i j)$ and the Lie algebra relations.
  ],
  title: "Proof of Flatness",
  collapsed: false,
)

A natural question is: what is the monodromy of this local system?
We shell consider the case $n=2$ first, which could be reduced to a single ordinary differential equation:
$
  frac(diff F, diff z) - frac(1, planck.reduce) Omega/z F = 0.
$
The solution could be expressed as $F(z) = z^(frac(1, planck.reduce) Omega) C$.
After winding $z$ around the origin once, i.e., $z |-> e^(2 pi i) z$, the solution would transform as:
$
  F(z) |-> e^(2 pi i frac(1, planck.reduce) Omega) F(z),
$
thus, the monodromy matrix is given by $M = e^(2 pi i frac(1, planck.reduce) Omega)$.
Which is exactly the R-matrix we found from the perturbative Chern-Simons theory!#footnote([Well, you may argue that there is a (slight) difference of a factor $h^(or)$ in the definition of $planck.reduce$ at the case of CS and KZ respectively. However, since the perturbative expansion is done at large $k$ limit (small $planck.reduce$), this difference could be ignored. Also, it is quite interesting to restore this factor $h^(or)$ from the perturbative CS theory point of view, which I don't know how to do so.])

In fact, this is not a coincidence.
Due to the work of Drinfeld and Kohno, the monodromy representation of the KZ connection is equivalent to the representation of the braid group obtained from the R-matrix of the corresponding quantum group.

Another natural question is: what about the general case with $n$ points?
Since the KZ connection is flat, the monodromy is equivalent to the holonomy of this connection, and such holonomy could be rephrased as:
$
  Hol_(nabla_("KZ"))(gamma) = cal(P) exp(integral_(gamma) A_("KZ")),
$
where $A_("KZ") = 1 / (k + h^(or)) sum_(i < j) Omega_(i j) d log(z_i - z_j)$.
Such a holonomy could be expanded and computed directly:
$
  Hol_(nabla_("KZ"))(gamma) = sum_(m=0)^(oo) frac(1, m!) integral_(0 <= t_1 <= ... <= t_m <= 1) A_("KZ")(gamma(t_1)) ... A_("KZ")(gamma(t_m)).
$
After plugging in the expression of $A_("KZ")$, the holonomy could be expressed as:
$
  Hol_(nabla_("KZ"))(gamma) = sum_(m=0)^(oo) frac(1, (k + h^(or))^(m)) sum_(P) wedge.big_(l in P) integral_(0 <= t_1 <= ... <= t_m <= 1) frac(d z_(l_1) - d z_(l_2), z_(l_1) - z_(l_2)) Omega_(l),
$
while interpreting $t$ as the time direction, this is exactly the Kontsevich integral we constructed from perturbative Chern-Simons theory (after taking $k >> h^(or)$ limit).

Moreover, we can conclude that, the expectation value of Wilson loops in perturbative Chern-Simons theory is the (formal) Dyson series expansion of the KZ connection.

= Yang-Baxter Equation from Chern-Simons Theory

Instead of using KZ connection and its Dyson formula to hand-waving argue that Chern-Simons theory yields solutions to the Yang-Baxter equation, we would give a more direct argument from the compactified configuration space.
Such a construction firstly introduced by Kontsevich in his work on the deformation quantization of Poisson manifolds.

== Invariance of Kontsevich Integral

We first return to the definition of the Kontsevich integral from perturbative Chern-Simons theory:
$
  Phi_(n)(K) = sum_(P) wedge.big_(l in P) (-1)^(\# arrow.b P) integral_(0 <= t_1 <= ... <= t_(n) <= 1) frac(d z_(l_1) - d z_(l_2), z_(l_1) - z_(l_2)) Omega_(l).
$
This construction could be reinterpreted with Feynman diagram.
To achieve this goal, we note that:
- Coordinates ${t_(i)}$ denotes some points on $SS^(1)$ (or $RR^(1)$)
- Pairing $P$ could be interpreted as a set of _chords_ connecting these points on $SS^(1)$ (or $RR^(1)$)
The first observation introduces the vertices in the Feynman diagram, while the second observation introduces the edges (propagators) in the Feynman diagram.
Thus, the chord diagram could be naturally embedded with Feynman rules.

#remark(
  [In the world of chord diagrams, the vertices in Feynman diagram are called _string_, while the edges are called _chords_.
  ],
)

#image_viewer(
  path: "../assets/cs_ybe_1.png",
  desc: [Chord diagram over $SS^1$.],
  dark-adapt: true,
  adapt-mode: "invert-no-hue",
)

It is not hard to imagine that, since the Kontsevich integral is constructed from the perturbative expansion of Chern-Simons theory, it should be invariant under isotopy of the knot $K$.

However, such naive expectation is not true under an arbitrary isotopy of the knot $K$.
For example, consider a isotopy which would create or annihilate a pair of critical points in the height function along the knot $K$, the Kontsevich integral would not be invariant under such isotopy.

If we restrict to isotopies that preserve the Morse nature of the knot $K$, the Kontsevich integral would be invariant under such isotopies.

Any deformation of a knot within the class of Morse knots can be approximated by a sequence of deformations of three types:
- Orientation- preserving reparametrizations, which is trivial to check the invariance of the Kontsevich integral.
- Horizontal deformations: preserves all horizontal planes ${t = "const"}$ and leaves all the critical points (together with some small neighbourhoods) fixed.
- Movements of critical points.

Now we focus on last two types of deformations.

=== Horizontal Deformations

The horizontal deformations could be viewed as an isotopy of a tangle which fixes the boundary points.
Consider two tangles $T_(0)$ and $T_(1)$, which are related by a horizontal deformation $T_(lambda)$, $lambda in [0, 1]$.

The Kontsevich integral over $T_1$ and $T_0$ could be related with the integration over the boundary of the parameter space $Delta = Delta_(0) times [0, 1]$, where $Delta_(lambda) := {0<t_1<...<t_(n)<1} times {lambda}$ is the standard $n$-simplex over $[0,1]$ at fixed $lambda$.
By Stokes theorem, we have:
$
  integral_(partial Delta) omega = integral_(Delta) d omega -->^(d omega = 0) 0,
$
where $partial Delta = Delta_(1) - Delta_(0) + ...$, and $...$ denotes the contributions from the (codimension $1$) boundary strata characterized by some two points collapsing configuration, i.e.:
$
  integral_(Delta_(1)) omega - integral_(Delta_(0)) omega + integral_(diff Delta times [0,1]) omega = 0.
$
Using the Fubini's theorem, we only need to check the contributions from $diff Delta$ to verify the invariance of the Kontsevich integral under horizontal deformations, i.e., we need to check that the contributions from $diff Delta$ would vanish.

There are four types of such collapsing configurations:
- Time plane hits a critical point.
- Two chords end at two same points.
- Two chords' endpoints belong to four different strings.
- Two chords' endpoints belong to three different strings.

*The first type* of boundary strata would not contribute to the integral, since the integrand form would vanish at such boundary.

*The second type* of boundary strata would also not contribute to the integral, since the integrand form would vanish at such boundary due to the antisymmetry of the wedge product:
$
  (d z_(k) - d z'_(k)) wedge (d z_(k) - d z'_(k)) = 0,
$
while $z_(k) = z_(k+1)$ and $z'_(k) = z'_(k+1)$.

*The third type* of boundary strata would not be naively zero.
We denote the four different strings as $1, 2, 3, 4$, and the two collapsing chords, for example $(1, 3)$ and $(2, 4)$, denoted by their end-strings.

The possible collapsing configurations could be constructed by the following two ways:
- $k$ chord is $(1,3)$ and $k+1$ chord is $(2,4)$.
- $k$ chord is $(2,4)$ and $k+1$ chord is $(1,3)$.
And there are two additional chord connecting $(1,2)$ and $(3,4)$ respectively.
Thus, the contributions from these two collapsing configurations could be expressed as:
$
  (1,2) wedge (3,4) wedge (d z_(k) - d z'_(k)) / (z_(k) - z'_(k)) wedge (d z_(k+1) - d z'_(k+1)) / (z_(k+1) - z'_(k+1)) + (1,2) wedge (3,4) wedge (d z_(k+1) - d z'_(k+1)) / (z_(k+1) - z'_(k+1)) wedge (d z_(k) - d z'_(k)) / (z_(k) - z'_(k)) = 0,
$
(where $D_(p)$ for such configuration is same) thus, the third type of boundary strata would also not contribute to the integral.

*The last type* of boundary strata is the most interesting one.
We could construct such collapsing configurations by the following $6$ ways by traversing all linking situations:
#equation-frame(
  diagram => {
    [$
        mat(
          (-1)^↓ #diagram("12", "23") " " omega_12 wedge omega_23,
          + (-1)^↓ #diagram("12", "13") " " omega_12 wedge omega_13;
          + (-1)^↓ #diagram("13", "12") " " omega_13 wedge omega_12,
          + (-1)^↓ #diagram("13", "23") " " omega_13 wedge omega_23;
          + (-1)^↓ #diagram("23", "12") " " omega_23 wedge omega_12,
          + (-1)^↓ #diagram("23", "13") " " omega_23 wedge omega_13;
          delim: #none
        ) "."
      $
    ]
  },
)

using the fact that $omega_(i j) = omega_(j i)$, the equation above is identified with Anord's identity:
$
  omega_(12) wedge omega_(23) + omega_(23) wedge omega_(13) + omega_(13) wedge omega_(12) = 0,
$
thus, the last type of boundary strata would also not contribute to the integral.
Therefore, we conclude that:
#theorem(
  [the Kontsevich integral is invariant under horizontal deformations of the Morse knot $K$.],
)

=== Movements of Critical Points


== Yang-Baxter Equation

Yang-Baxter equation is

// R-matrix from perturbative CS theory
