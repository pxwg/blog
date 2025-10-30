#import "../../../typ/templates/blog.typ": *
#import "../../../typ/packages/typst-fletcher.typ": *
#import "../../../typ/packages/physica.typ": *

#let title = "Chern Simons Theory and Yang-Baxter Equation"
#show: main.with(
  title: title,
  desc: [The Kontsevich integral could be found in perturbative Chern-Simons theory, which could be associated with the Yang-Baxter equation and R matrix.],
  date: "2025-10-28",
  tags: (
    blog-tags.math,
    blog-tags.physics,
    blog-tags.algebra,
    blog-tags.topology,
  ),
  lang: "en",
  translationKey: "cs_ybe",
)
#let CS = math.upright("CS")
#let wedge = math.and
#let GL = math.upright("GL")

= Chern-Simons Theory Revisit

Chern-Simons theory is a topological version of Yang-Mills theory in three dimensions.

== Action and Partition Function

Consider a three-dimensional compact smooth manifold $X$ and a gauge group $G$ with Lie algebra $(frak(g), tr)$, where $tr$ is an invariant bilinear form on $frak(g)$, the Chern-Simons action is given by:
$
  CS_(X)[A] = integral_(X) tr(A d A + 2/3 A^(3)),
$
where $A$ is a connection 1-form on a principal $G$-bundle over $X$.
This action is invariant under gauge transformations $A |-> g^(-1) A g + g^(-1) d g$ where $g: X -> G$.

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
  W_(K)(rho) = tr_(rho) cal(P) exp(integral_(K) A),
$
where $cal(P) exp$ denotes the path-ordered exponential along the knot $K$.

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

// BV formalism, gauge fixing and perturbative expansion

= Kontsevich Integral from Chern-Simons Theory

From now on, we assume $X = RR times Sigma$, where $Sigma$ is a Riemann surface and $RR$ denotes the time direction.
In this case, the Morse knots could be defined with respect to the height function along the $RR$ direction.

We also choose a set of bases ${t_(a)}$ for gauge Lie algebra $frak(g)$, such that $tr(t_(a) t_(b)) = delta_(a b)$, $[t_i, t_j] = f_(i j)^(k) t_(k)$.
Then the gauge connection $A$ could be expressed as $A = A^(a) t_(a)$, where $A^(a) in Omega^(1)(X)$ are ordinary 1-forms on $X$ (after choosing a reference trivialization of the principal $G$-bundle).

== Axial Gauge and Perturbative Expansion

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


// Axial Gauge -> Kont. integral -> KZ connection

= Knizhnik Zamolodchikov Connection and Yang-Baxter Equation

// KZ equation <-> YBE by Drinfeld and Kohno

= Yang-Baxter Equation from Chern-Simons Theory

// R-matrix from perturbative CS theory
