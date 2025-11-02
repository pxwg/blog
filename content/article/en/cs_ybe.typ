#import "../../../typ/templates/blog.typ": *
#import "../../../typ/packages/typst-fletcher.typ": *
#import "../../../typ/packages/physica.typ": *

#let title = "Chern Simons Theory and Yang-Baxter Equation"
#show: main.with(
  title: title,
  desc: [The Kontsevich integral could be found in perturbative Chern-Simons theory, which could be associated with the Yang-Baxter equation and R matrix.],
  date: "2025-11-01",
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

= Introduction: Particles with Relative Statistics

Instead of rush to Chern Simons field theory directly, let us first consider a more physical picture.
The discussion below is intuitive and informal.
However, since this theory is quite simple, it is easy to make everything rigorous and precise.

== Anyons with Fractional Statistics

It is well-known that in three (or higher) dimensional space, there are two types of fundamental particles: bosons and fermions, which differ by their exchange statistics.
However, in two-dimensional space, there exists a more exotic type of particles called _anyons_, which exhibit fractional statistics that interpolate between bosonic and fermionic behavior.
To be briefly, when two anyons are exchanged, the wavefunction acquires a phase factor $e^(i theta)$, where $theta$ can take any value between $0$ (bosons) and $pi$ (fermions).

We can consider a system with two large mass anyons and statistic phase $theta$.
Thus, on the (for example) complex plane $CC$, the effective Lagrangian of this system could be written as:
$
  L_(theta) := sum_(i=1)^(2) p_(z)^(i) dot(z)_(i) + sum_(i=1)^(2) A_(z)^(i) dot(z)_(i) =sum_(i=1)^(2) p_(z)^(i) dot(z)_(i) + frac(theta, 2 pi i) frac(dot(z)_1-dot(z)_2, z_1 - z_2),
$
where $z_1, z_2 in CC$ denote the positions of the two anyons respectively.
Due to the residue theorem., the holonomy of this gauge connection $A ~ (d z) / z$ around one anyon would yield the desired phase factor $e^(i theta)$.

Now we consider the quantization of this system.
Note that we have already fixed a gauge (the holomorphic gauge) for this gauge connection $A$, and the original theory has a gauge redundancy.
Thus, the associated Schrödinger equation could arise from the constraint equation:
$
  (p_(z)^(i) + A_(z)^(i)) psi(z_1, z_2) = 0, quad p_(overline(z))^(i) psi(z_1, z_2) = 0, thin forall i = 1, 2.
$
Performing the canonical quantization $p_(z)^(i) = - i diff_(z_(i))$, and switch to a new coordinate $z = z_1-z_2$, such equations could be written as:
$
  (diff_(z) - frac(theta, 2 pi) frac(1, z)) psi(z, overline(z)) = 0, quad diff_(overline(z)) psi(z, overline(z)) = 0.
$
The second equation implies that $psi$ is holomorphic in $z$, and the first equation could be solved directly, yielding:
$
  psi(z_1, z_2) = C (z_1 - z_2)^(theta / (2 pi)),
$
which is a multi-valued function on $CC$ with a branch cut at $z_1 = z_2$, and the monodromy around this branch cut is exactly the desired phase factor $e^(i theta)$.

A natural assumption is assume that such wave function would return to itself while winding $k$ times.
Thus, the statistic phase $theta$ is quantized as $theta = 2 pi / k$, where $k in ZZ_(>0)$ (the charges $q$ would be absorbed into $U(1)$ representation), which make the wave function become:
$
  psi(z_1, z_2) = C (z_1 - z_2)^(1 / k).
$
Such a equation is exactly the famous _Knizhnik-Zamolodchikov equation_ arise from conformal field theory!
And the associated KZ connection could be interpreted as the gauge connection $A$ we introduced above, which describes the statistics interaction between anyons.

While generalizing to $n$ anyons, the gauge connection could be expressed as:
$
  A_(z)^(i) = frac(1, k) sum_(j != i) Omega_(i j) / (z_i - z_j),
$
where $Omega_(i j) = q_(i) q_(j)$, and above recipe could be repeated straightforwardly.

== Time Evaluation

Now we consider the time evolution of such anyon system.
Note that the Hamiltonian of this system is trivial $H = 0$, thus, the time evolution would be fully determined by the Berry phase arise from the gauge connection $A$.

Thus, the only thing we need is to consider $U(t_(b), t_(a)) := cal(T) exp(i integral z^(*)(A_z) thin d t)$, where $z: t -> RR^(2)$ is the world line of the anyon, and $cal(T) exp$ denotes the time-ordered exponential.
Such time evolution operator could be expanded as a Dyson series:
$
  U(t_(b), t_(a)) = 1 + sum_(n=1)^(oo) i^(n) frac(1, n!) integral_(t_(a) <= t_1 <= ... <= t_n <= t_(b)) A_z (z(t_1)) ... A_z (z(t_n)) thin d t_1 ... d t_n := 1 + sum_(n=1)^(oo) (frac(i, k))^(n) cal(A)_(n).
$
Plugging the definition of the gauge connection $A_z = frac(1, k) sum_(i < j) 1 / (z_i - z_j)$ into the above equation, we could rewrite the time evolution operator as:
$
  cal(A)_(n) = sum_(P) wedge.big_(l in P) integral_(t_(a) <= t_1 <= ... <= t_n <= t_(b)) frac(d z_(l_1) - d z_(l_2), z_(l_1) - z_(l_2)) Omega_(l),
$
where $P$ is a pairing of the set ${1, ..., n}$, each pair $l in P$ consists of two elements $(l_1, l_2)$, and $Omega_(l) = q_(l_1) q_(l_2)$ is an double insertion of charges at the points $z(t_(l_1))$ and $z(t_(l_2))$ on the world line, could be written as $Omega_(i j) := q_(i) q_(j)$, which in fact, labels the $U(1)$ representation.

== Chern-Simons Theory

Now we consider the field theory description of such anyon system.
The effective field theory that describes the low-energy behavior of anyons is the _Chern-Simons theory_, which is a topological quantum field theory defined in three-dimensional spacetime.
The Abelian Chern-Simons action is given by:
$
  CS_(X)[A] = frac(k, 4 pi) integral_(X) A d A,
$
under the holomorphic gauge $A = A_t d t + A_z d z$, the Chern-Simons action reduces to:
$
  CS_(X)[A] := frac(k, 4 pi) integral_(X) A overline(diff)_(t) A,
$
where $overline(diff)_(t) := d t overline(partial)$.
And the anyon Lagrangian would be introduced into this action with minimal coupling, which could be expressed as:
$
  S_("anyon")[A, z] = integral_(RR) A_z (z(t)) dot(z)(t) thin d t.
$
which is essentially the Wilson line observable in Chern-Simons theory, where the time is a natural parameter along the world line of the anyon.

In order to obtain the effective action of this theory, we need to integrate out the gauge field $A$.
Since the Chern-Simons action is quadratic in $A$, such integration could be performed exactly.
Note that, under the holomorphic gauge, correlation function (propagator) of the gauge field $A$ could be computed as:
$
  angle.l A_(i)(z_1, t_1) A_(j)(z_2, t_2) angle.r = frac(1, i k) frac(d z_1 - d z_2, z_1 - z_2) delta(t_1 - t_2).
$
After performing the Gaussian integration, the effective action could be expressed as:
$
  S_("eff")[z] = frac(1, k) integral_(RR) frac(d z(t) - d z(t), z(t) - z(t)) (dot(z)(t) - dot(z)(t)) thin d t = integral_(RR) L_(2pi \/ k) thin d t,
$
which is exactly the anyon Lagrangian we constructed above!
Thus, we can conclude that, the Chern-Simons theory provides a natural field theory description of anyons with fractional statistics we constructed above.

=== Non-Abelian Generalization

Since the Abelian Chern-Simons theory describes only $U(1)$ gauge group, a natural generalization of this construction is to consider non-Abelian gauge group $G$.
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

In our discussion of anyons, such Wilson loop observable could be interpreted as the world line of a particle moving in $X$ and carrying some charge under the gauge group $G$.
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


== Some Words about CS-WZW Correspondence

Though we won't discuss the non-perturbative Chern-Simons theory in detail, it is still worth mentioning some important results from Witten's work.

We've already know that, the wave function of the anyon system satisfies the Knizhnik-Zamolodchikov equation.
Such equation arises naturally in the Wess-Zumino-Witten (WZW) model, which is the equation for the conformal blocks (which could be interpreted as local correlation functions) of the WZW model.

On the other hand, the wave function of Chern-Simons theory could be interpreted as the anyon wave function we constructed above.
Thus, the CS-WZW correspondence could be interpreted as the equivalence between the wave function of Chern-Simons theory in the bulk (three dimensional spacetime), and the conformal blocks of the WZW model on the boundary (boundary of the spacetime).

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

It is not hard to see that, the definition of $Phi_(n)(K)$ is (the non-abelian generalization of) the time evolution operator we constructed in the anyon system above.
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
Using the Kontsevich integral construction, the only nontrivial contribution comes from the $n$-th copy of the gauge connection over these two points, which yields:
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

= Knizhnik Zamolodchikov Connection and Yang-Baxter Equation

Now we consider the physical interpretation of the expectation value we constructed above.
To achieve this goal, let us consider a (seemly) independent problem arise from conformal field theory.

== Knizhnik-Zamolodchikov Connection

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

== Yang-Baxter Equation

Now we come back to the topological implication of the KZ connection.

// KZ equation <-> YBE by Drinfeld and Kohno

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
Thus, the diagram above could be reinterpreted as a _chord diagram_ with $n$ chords.

#image_viewer(
  path: "../assets/cs_ybe_1.png",
  desc: [Chord diagram over $SS^1$.],
  dark-adapt: true,
  adapt-mode: "invert-no-hue",
)

The integration region $Delta = {(t_1, ..., t_n) : t_1 <= ... <= t_n}$ is an $n$-simplex over $SS^(1)$ (or $RR^(1)$), which can naturally be extended to the standard configuration space of $n$ distinct points on $SS^(1)$ (or $RR^(1)$), with the only cost being the inclusion of a permutation factor $n!$:
$
  Phi_(n)(K) = frac(1, n!) sum_(P) wedge.big_(l in P) integral_(Conf_(n)(SS^(1))) frac(d z_(l_1) - d z_(l_2), z_(l_1) - z_(l_2)) Omega_(l) := frac(1, n!) integral_(Conf_(n)(SS^(1))) omega_(l),
$
which could be canonically compactified to the Fulton-MacPherson compactification $overline(Conf)_(n)(SS^(1))$.
In the case of one-dimensional manifold, such compactification would only add boundary strata characterized by $ZZ_2$, which corresponds to the possibility of two points colliding together.

Now we consider the variation of the Kontsevich integral under isotopy of the knot $K$.
Such an infinitesimal variation could be realized as some vector field $v$ over the configuration space $Conf_(n)(SS^(1))$.
Using the Cartan's magic formula, the variation could be computed as:
$
  delta Phi_(n)(K) = frac(1, n!) integral_(overline(Conf)_(n)(SS^(1))) L_v omega = frac(1, n!) integral_(overline(Conf)_(n)(SS^(1))) d i_v omega = frac(1, n!) integral_(partial overline(Conf)_(n)(SS^(1))) i_v omega,
$
where we used the fact that $omega$ is closed under $d$.


== Yang-Baxter Equation Revisited

// R-matrix from perturbative CS theory
