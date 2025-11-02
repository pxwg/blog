#import "../../../typ/templates/blog.typ": *
#import "../../../typ/packages/typst-fletcher.typ": *
#import "../../../typ/packages/physica.typ": *

#let title = "Chern Simons Theory From Anyons"
#show: main.with(
  title: title,
  desc: [An introduction to Chern-Simons theory through the study of anyons in two-dimensional space, whose Schrödinger equation is Knizhnik-Zamolodchikov equation.],
  date: "2025-11-02",
  tags: (
    blog-tags.math,
    blog-tags.physics,
    blog-tags.topology,
  ),
  lang: "en",
  translationKey: "anyon_cs",
)
#let CS = math.upright("CS")
#let wedge = math.and
#let GL = math.upright("GL")
#let Conf = math.upright("Conf")
#let Hol = math.upright("Hol")


We could derive the Chern-Simons theory naturally from the study of anyons with fractional statistics in two-dimensional space.
The time evolution of such anyon system could be expressed as a Berry phase, which is closely related to the Knizhnik-Zamolodchikov connection arise from conformal field theory.

As an introduction, the discussion below is intuitive and informal.
However, since this story is quite simple (but deep), it is easy to make everything rigorous and precise.

= Anyons with Fractional Statistics

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
Such a equation is exactly the famous (Abelian, two bodies) _Knizhnik-Zamolodchikov equation_ arise from conformal field theory!
And the associated KZ connection could be interpreted as the gauge connection $A$ we introduced above, which describes the statistics interaction between anyons.

While generalizing to $n$ anyons, the gauge connection could be expressed as:
$
  A_(z)^(i) = frac(1, k) sum_(j != i) Omega_(i j) / (z_i - z_j),
$
where $Omega_(i j) = q_(i) q_(j)$, and above recipe could be repeated straightforwardly, and finally yield the _Knizhnik-Zamolodchikov equation_ for $n$ bodies.

= Time Evaluation

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

Such expression (in non-Abelian case with some proper regularization) is #link("https://ncatlab.org/nlab/show/Kontsevich+integral")[Kontsevich's integral formula] for the _link invariant_, which is the Taylor coefficient of some link polynomial (for example, the Jones polynomial), called the #link("https://ncatlab.org/nlab/show/universal+Vassiliev+invariant")[_universal Vassiliev invariant_].

= Abelian Chern-Simons Theory

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
  S_("anyon")[A, z] = integral_(RR) [A_z (z(t)) dot(z)(t) + A_(0) (z(t)) ] thin d t,
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

= Some Words about CS-WZW Correspondence

Though we won't discuss the non-perturbative Chern-Simons theory in detail, it is still worth mentioning some important results from Witten's work.

We've already know that, the wave function of the anyon system satisfies the Knizhnik-Zamolodchikov equation.
Such equation arises naturally in the Wess-Zumino-Witten (WZW) model, which is the equation for the conformal blocks (which could be interpreted as local correlation functions) of the WZW model.

On the other hand, the wave function of Chern-Simons theory could be interpreted as the anyon wave function we constructed above.
Thus, the CS-WZW correspondence could be interpreted as
$
  Psi_(CS)[X, {K_(i), rho_(i)}] <--> angle.l product_(i) V_(K_(i))(rho_(i)) angle.r_("WZW", partial X),
$
where $V_(K)(rho)$ denotes the vertex operator insertion at the point where the line $K$ intersects the boundary $partial X$ in the WZW model, and ${K, rho}$ denotes a Wilson line $K$ colored by the representation $rho$ of the gauge group.
Here $rho$ plays the role of the charge $q$ we introduced above.
