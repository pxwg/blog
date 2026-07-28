#import "../../../typ/templates/blog.typ": *
#import "../../../typ/packages/physica.typ": *

#let wedge = math.and
#let title = "Kepler's Problem as Geodesic Flow on S³"
#show: main.with(
  title: title,
  desc: [The cotangent lift of stereographic projection identifies geodesic flow on $SS^3$ with the regularized negative-energy Kepler flow.],
  date: "2026-07-28",
  tags: (
    blog-tags.math,
    blog-tags.physics,
    blog-tags.topology,
  ),
  lang: "en",
  translationKey: "kepler_s3",
)

The Kepler problem is usually approached through its first integrals. Energy and angular momentum reduce the motion to a plane, where the orbit can be calculated in polar coordinates. This is an effective way to solve the problem, but it is not the only geometry hidden in it.

For negative energy, the angular momentum and the Runge--Lenz vector reveal an $op("SO")(4)$ symmetry. We will not derive their complete algebra here. Instead, we use this symmetry as a clue: $op("SO")(4)$ is the rotation group of $RR^4$ and the orientation-preserving isometry group of the round three-sphere $SS^3$. This suggests a natural question: can the negative-energy Kepler problem be understood as free motion on $SS^3$?

Following #link("https://doi.org/10.1002/cpa.3160230406")[Moser's regularization], we will construct this correspondence directly.
This construction identifies the regularized Kepler flow with the geodesic flow on $SS^3$ and lets us recover Kepler ellipses from great circles.

= Stereographic Projection of the Three-Sphere

Write a point of $RR^4$ as $(xi_0, xi_(perp)) in RR times RR^3$, and let
$
  SS^3
  = {(xi_0, xi_(perp)) in RR times RR^3
    | xi_0^2 + norm(xi_(perp))^2 = 1}.
$
We denote the north pole by $N=(1,0)$. Stereographic projection from $N$ gives a coordinate chart
$
  sigma_N: SS^3 - {N} -> RR^3,
  quad
  x = sigma_N (xi_0, xi_(perp))
  = frac(xi_(perp), 1 - xi_0).
$
Its inverse is
$
  xi_0
  = frac(norm(x)^2 - 1, 1 + norm(x)^2),
  quad
  xi_(perp)
  = frac(2x, 1 + norm(x)^2).
$
Thus, $SS^3$ is the one-point compactification of $RR^3$: the omitted north pole appears at $norm(x) -> oo$.

The round metric pulls back to a conformal multiple of the Euclidean metric,
$
  g_("rd")
  = frac(4, (1 + norm(x)^2)^2)
  sum_(i=1)^3 (dif x_i)^2,
$
and its co-metric is
$
  g_("rd")^(-1)
  = frac((1 + norm(x)^2)^2, 4)
  sum_(i=1)^3 partial_(x_i)^2.
$
For a covector $y in T_x^* RR^3$, the free-particle Hamiltonian of the round sphere is therefore
$
  F(x,y)
  := frac(1, 2) g_("rd")^(-1) (y,y)
  = frac((1 + norm(x)^2)^2, 8) norm(y)^2.
$
The unit-speed geodesic flow lives on the level set $F=1/2$.


The base projection alone is not yet a map of dynamical systems: the Kepler problem lives in phase space. We need the cotangent lift, whose local coordinates are $(x,y)$. The unexpected part of the construction will be that $x$ corresponds to the Kepler momentum, while the Kepler position becomes the conjugate covector $y$.

= The Negative-Energy Kepler Surface

After reduction by the center-of-mass motion, the three-dimensional Kepler problem has phase space
$
  cal(P) = T^* (RR^3 - {0})
$
with position $q in RR^3 - {0}$, momentum $p in RR^3$, and Hamiltonian
$
  H(q,p)
  = frac(1, 2) norm(p)^2 - frac(1, norm(q)).
$
The collision locus $q=0$ is excluded, and the Hamiltonian vector field becomes singular as a trajectory approaches it.

After rescaling the energy, it is enough to study the normalized surface $Sigma_(-1\/2)$. Its energy equation is
$
  -frac(1, 2)
  = frac(1, 2) norm(p)^2 - frac(1, norm(q)),
$
or equivalently
$
  frac((1 + norm(p)^2)^2, 4) norm(q)^2 = 1.
$

Now introduce the canonical transformation
$
  Phi(q, p)=(-p,q)=:(x,y).
$
The normalized energy condition becomes
$
  frac((1 + norm(x)^2)^2, 4) norm(y)^2 = 1.
$
Comparing this equation with the spherical Hamiltonian $F$, we immediately obtain
$
  Phi(Sigma_(-1\/2))
  = {F=frac(1, 2)}
  = S^* (SS^3 - {N}).
$
Thus, the normalized Kepler energy surface is exactly the unit-speed constraint for the round sphere in stereographic cotangent coordinates.

= Matching the Flows

The equality of the energy hypersurfaces does not yet identify their parameterized flows. Let
$
  K
  := H compose Phi^(-1)
  = frac(1, 2) norm(x)^2 - frac(1, norm(y)).
$
Since $Phi$ is canonical, the pushforward of the Kepler vector field is the Hamiltonian vector field of $K$:
$
  Phi_* X_H
  = sum_(i=1)^3 [
    frac(y_i, norm(y)^3) partial_(x_i)
    - x_i partial_(y_i)
  ].
$

For the spherical free-particle Hamiltonian, using
$
  dif F = -iota_(X_F) omega,
  quad
  omega = sum_(i=1)^3 dif y_i wedge dif x_i,
$
we obtain
$
  X_F
  = sum_(i=1)^3 [
    frac((1 + norm(x)^2)^2, 4)
    y_i partial_(x_i)
    - frac(1 + norm(x)^2, 2)
    norm(y)^2 x_i partial_(y_i)
  ].
$
On the common energy hypersurface
$
  Sigma = {F=frac(1, 2)} = {K=-frac(1, 2)},
$
the constraint $(1 + norm(x)^2) norm(y)=2$ reduces this vector field to
$
  X_F|_Sigma
  = sum_(i=1)^3 [
    frac(y_i, norm(y)^2) partial_(x_i)
    - norm(y) x_i partial_(y_i)
  ]
  = norm(y) Phi_* X_H.
$
Therefore,
$
  Phi_* X_H
  = frac(1, norm(y)) X_F
  quad "on" quad Sigma.
$

If $t$ denotes Kepler time and $s$ denotes the arc-length parameter of the spherical geodesic flow, then
$
  dif t
  = norm(y) dif s
  = norm(q) dif s,
  quad
  dif s = frac(dif t, norm(q)).
$
This is the _Sundman time reparametrization_. It turns the normalized Kepler flow into the unit-speed geodesic flow on the punctured sphere.

= Collision Regularization

So far, the construction gives
$
  Sigma_(-1\/2)
  tilde.equiv
  S^* (SS^3 - {N}).
$
At fixed energy, approaching collision means
$
  q -> 0,
  quad
  norm(p) -> oo.
$
Under $x=-p$ and $y=q$, this becomes $norm(x)->oo$, precisely the missing north pole of the stereographic chart.

Adding the north pole to the base is not enough by itself. At collision, the remaining datum is the direction of the regularized trajectory. The natural completion adds the unit covector sphere
$
  S_N^* SS^3 tilde.equiv SS^2
$
over $N$. The completed energy surface is therefore
$
  hat(Sigma)_(-1\/2)
  tilde.equiv S^* SS^3
  tilde.equiv T_(1) SS^3.
$
The geodesic flow is smooth on this completed space. Great circles through $N$ give the regularized radial collision--ejection trajectories. At fixed negative energy these are the $L=0$ degenerate ellipses, not the zero-energy parabolic branch.

= From Great Circles to Kepler Orbits

The completed sphere picture gives the normalized Kepler solution explicitly. A unit-speed great circle is determined by an orthonormal pair in $RR^4$. Shift its parameter so that $psi=0$ corresponds to periapsis, and choose orthonormal vectors $e_1,e_2 in RR^3$ in the orbital plane. For $0 <= e < 1$, write
$
        xi_0 (psi) & = e cos psi, \
   xi_(perp) (psi) & = e_1 sin psi
                     - sqrt(1-e^2) e_2 cos psi, \
       eta_0 (psi) & = -e sin psi, \
  eta_(perp) (psi) & = e_1 cos psi
                     + sqrt(1-e^2) e_2 sin psi.
$
Here $xi(psi) in SS^3$, $eta=xi'$, and $psi$ is the great-circle angle. The cotangent lift of stereographic projection gives
$
  x
  = frac(xi_(perp), 1-xi_0),
  quad
  y
  = (1-xi_0) eta_(perp)
  + xi_(perp) eta_0.
$
Using $q=y$ and $p=-x$, we recover
$
  q(psi) & = (cos psi-e)e_1
           + sqrt(1-e^2) sin psi e_2, \
  p(psi) & = frac(
             -sin psi e_1
             + sqrt(1-e^2) cos psi e_2,
             1-e cos psi
           ).
$
In particular,
$
  norm(q(psi)) = 1-e cos psi,
  quad
  frac(1, 2) norm(p(psi))^2
  - frac(1, norm(q(psi)))
  = -frac(1, 2).
$
Eliminating $psi$ from the position gives
$
  (q dot e_1 + e)^2
  + frac((q dot e_2)^2, 1-e^2)
  = 1.
$
This is an ellipse of semimajor axis $1$ and eccentricity $e$, with the force center at one focus. Geometrically, $e$ also measures how close the corresponding great circle comes to the north pole: since $xi_0=e cos psi$, the minimum spherical distance $d$ from the great circle to $N$ satisfies $e=cos d$. The circular orbit has $e=0$, while the collision limit $e=1$ is a great circle through $N$.

Since $dif psi=dif s$, the Sundman relation becomes
$
  dif t
  = norm(q(psi)) dif psi
  = (1-e cos psi) dif psi.
$
Integrating from periapsis gives
$
  t-tau = psi-e sin psi.
$
Thus, the great-circle angle, the regularized time, and the eccentric anomaly are the same variable up to an additive constant. Restoring the mass $m$, coupling $kappa$, and semimajor axis $a$, the solution becomes
$
  q(psi)
  = a(cos psi-e)e_1
  + a sqrt(1-e^2) sin psi e_2,
$
with Kepler's equation
$
  sqrt(frac(kappa, m a^3)) (t-tau)
  = psi-e sin psi.
$
The scaling from the normalized energy surface then recovers every fixed negative-energy branch.

Thus, from geodesics on the three-sphere, we have reproduced and solved the negative-energy branch of Kepler's problem.
