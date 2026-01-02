#import "../../../typ/packages/physica.typ": *
#import "../../../typ/templates/blog.typ": *

//----------------------basic info ----------------------//

#let title = "Sewing Chiral RCFTs"
#let desc = "Constructing higher genus rational conformal field theories from local ones via sewing procedure."
#let author = "Xinyu Xiang"
#let date = "2026-01-02"

#show: main.with(
  title: title,
  desc: desc,
  date: date,
  lang: "en",
  translationKey: "global_rcft",
  tags: (
    blog-tags.math,
    blog-tags.physics,
    blog-tags.topology,
    blog-tags.algebra,
    blog-tags.abstract-nonsense,
  ),
)

//-----------------------symbols----------------------//

#let sym = "Sym"
#let Map = "Map"
#let wedge = math.and
#let Hom = "Hom"
#set math.mat(delim: "[")

//---------------------main project---------------------//

Given a local RCFT defined on a punctured sphere $bb(S)^(2)({p_1, z_1},...,{p_(n), z_(n)})$, we want to construct such a theory on a higher genus Riemann surface $Sigma_(g)({p_1, z_1},...,{p_(n), z_(n)})$, where ${p_(n), z_(n)}$ denotes the puncture at point $p_(n)$ with local coordinate $z_(n)$, which satisfies $z(p)=0$.

There is a standard way to obtain a higher genus Riemann surface from some punctured spheres, so-called factorization, or sewing procedure.
Thus, the main idea is:

- First, find a factorization of the target Riemann surface $Sigma_(g)({p_1, z_1},...,{p_(n), z_(n)})$.
- Define local RCFTs on each of the pants, i.e. $bb(S)^(2)({p_i, z_i}, {p_j, z_j}, {p_k, z_k})$.
- Find an associative sewing operation for local RCFTs, which is compatible with the sewing of Riemann surfaces.

The data above could be summarized as:
$
  Z: [(Sigma_(g_1), Sigma_(g_2)) -> Sigma_(g_1 + g_2)] => [(Z(Sigma_(g_1)) , Z(Sigma_(g_2))) -> Z(Sigma_(g_1 + g_2))],
$
where $Z$ denotes the RCFT defined on the corresponding Riemann surface, corresponding to the higher genus partition functions.

Since there are various factorizations for a given Riemann surface, we also need to show that the final RCFT defined on $Sigma_(g)({p_1, z_1},...,{p_(n), z_(n)})$ is independent of the choice of pants decomposition.
Which could be related to the constrains for $Z$ above, corresponding to the Moore-Seiberg data in the rational CFT and mapping class group actions on the Riemann surfaces.

= Introduction: Gluing in QFT

This is an elementary part which is well-known in QFT at least in the level of "philosophy".

#remark[
  Writing down such procedures in a rigorous way is not easy, and only succeed in some special cases, e.g., topological QFTs, and rational CFTs which is our main focus here.
]

Consider a QFT defined on a manifold $M$ with boundary $partial M$, the path integral could be written as:
$
  Z(M, phi(partial M)) = integral_(Gamma(M, X))^(phi|_(partial M) = phi(partial M)) cal(D)[phi] e^(-S[phi]),
$
which is a functional of the boundary field configuration $phi(partial M)$.
Thus, if we have two manifolds $M$ and $N$ with isomorphic boundaries $partial M equiv partial N$, we could glue them together to form a new manifold $M union.sq_(partial M equiv partial N) N$ with inverse boundary operations:
$
  Z(M union.sq_(partial M equiv partial N) N) = integral_(Gamma(partial M, X)) cal(D)[phi(partial M)] Z(M, phi(partial M)) overline(Z)(N, phi(partial M)),
$
where we sum over all the possible boundary field configurations $phi(partial M)$, and $overline(Z)(N, phi(partial M))$ denotes the complex conjugate of $Z(N, phi(partial M))$, since the orientation of $partial N$ is opposite to that of $partial M$.

= Sewing an RCFT

We first review the sewing procedure for Riemann surfaces, then discuss how local RCFTs behave under such operations.

== Sewing Riemann Surfaces

Consider two punctures ${p_i, z_i}$ and ${p_j, z_j}$ on (some) Riemann surfaces.
A sewing operation would glue these two punctures together to form a new Riemann surface $Sigma'$.

#example[
  - If the two punctures are on different Riemann surfaces $Sigma_(g_1)$ and $Sigma_(g_2)$, the new Riemann surface would be written as $Sigma'_(g_1 + g_2, n_1+n_2-2) = Sigma_(g_1, n_1) oo^(i)_(j) Sigma_(g_2, n_2)$.
  - If the two punctures are on the same Riemann surface $Sigma_(g)$, the new Riemann surface would be written as $Sigma'_(g+1, n-2) = 8^(i)_(j)Sigma_(g, n)$.

  In the notation above, the RCFT partition functions $Z: Sigma_(g,n) -> Z(Sigma_(g,n))$ should be compatible with the sewing operations, for example:
  $
    Z: Sigma_(g_1, n_1) oo^(i)_(j) Sigma_(g_2, n_2) => Z(Sigma'_(g_1 + g_2, n_1+n_2-2)),
  $
  would define a higher genus RCFT partition function from two lower genus ones.
  We will discuss more details in the next section.
]

In this procedure:

- Punctures $p_(i)$ and $p_(j)$ would be identified and finally removed.
- The local coordinates $z_i$ and $z_j$ would satisfy the relation $z_i z_j = q$, where $q$ is a complex parameter with $|q| < 1$.

#remark[
  $q$ is called the _sewing parameter_, which controls the complex structure of the new Riemann surface $Sigma'$, and related to the Fenchel–Nielsen coordinates $(l,theta)$ by $q = e^(-(l + i theta))$ in the Teichmüller space.

  If there are some other sewing operations happening at the same time, we would have multiple sewing parameters $q_1, q_2, ...$, which form a coordinate system ${q_(i)}$.
]

The second step could be understood as follows:
- Cutting out small disks $|z_i| < |q|^(1/2)$ and $|z_j| < |q|^(1/2)$ around the punctures.
- Identifying the boundary $|q|^(1/2) <= |z_i| < 1$ and $|q|^(1/2) <= |z_j| < 1$ via the relation $z_i z_j = q$.

== Modularity and Mapping Class Group

A Fenchel–Nielsen coordinate system ${q_(i)}$ corresponds to a factorization of the Riemann surface.
However, there are various factorizations for a given Riemann surface, thus various coordinate systems ${q_(i)}$ in the Teichmüller space.

=== Modularity: Sewing a Double Punctured Sphere

Consider sewing two punctures $p$ and $q$ on a double punctured sphere $bb(S)^(2)({p, z}, {p', w})$, the resulting Riemann surface is a torus (well-known fact).
We assume $p$ and $p'$ are two poles of the sphere, and the local coordinates $z$ and $w$ are related by $z w = q$.

Using the transition function of two charts on the sphere, we could write $w = 1/z$, thus the sewing relation could be written as and identification $z ~ q z$.
Under this identification, the complex plane $bb(C)$ becomes a torus $bb(T) = bb(C)^(*) \/ (z ~ q z) tilde.equiv bb(C) \/ (bb(Z) + tau bb(Z))$, where $q = e^(2 pi i tau)$, $tau in bb(H)$.

The change of sewing could be identified with changing the way to cut the torus into a double punctured sphere, which is identified with changing the basis of the homology group $H_1(bb(T), bb(Z))$ (A-cycle and B-cycle).
The homology basis has a natural symplectic structure given by the intersection number, thus the change of basis should preserve such structure, i.e., an action of the symplectic group $"Sp"(2, bb(Z)) equiv "SL"(2, bb(Z))$.

Thus, the different sewing operations on the double punctured sphere correspond to different coordinate systems $q = e^(2 pi i tau)$ and $q' = e^(2 pi i tau')$ on the Teichmüller space of the torus, which are related by the modular group $"SL"(2,bb(Z))$ action.

=== Mapping Class Group

Higher dimensional generalization of the modular group is the mapping class group of Riemann surfaces.
Point is: Different sewing operations correspond to the different ${q_(i)}$ coordinate systems in the Teichmüller space, which are related by the action of the mapping class group $"MCG"_(g,n)$, which is $"SL"(2,bb(Z))$ in the torus case.

#remark[
  Well-defined RCFT on a higher genus Riemann surface should be independent of the choice of factorization, thus independent of the choice of sewing operations.
  Which leads to some constrains on the RCFT partition functions under the action of the mapping class group we will discuss later.
]

=== Elementary Moves for Sewing Operations

A sewing procedure could be decomposed into a sequence of elementary sewing operations, which correspond to:

- Self twisting $Sigma'_(g, n) = T^(i) Sigma_(g,n)$.
- Self sewing $Sigma'_(g+1, n-2) = 8^(i)_(j) Sigma_(g,n)$.
- Sewing two different Riemann surfaces $Sigma'_(g_1 + g_2, n_1+n_2-2) = Sigma_(g_1, n_1) oo^(i)_(j) Sigma_(g_2, n_2)$.

And the resulting Riemann surface could be obtained by a sequence of compositions of these elementary sewing.

There are various ways to go from a given factorization to another one, which correspond to different sequences of elementary sewing operations.
There is a result by Hatcher and Thurston that classifies these relations:

#theorem(title: "Hatcher-Thurston")[
  Any two factorizations of a Riemann surface could be related by a sequence of the following elementary moves:

  - _F-move_: Change the way to cut a four punctured sphere into two three punctured spheres.
  - _S-move_: Change the way to cut a one punctured torus into a double punctured sphere.

  Satisfying some relations (pentagon relation, hexagon relation, ...)
]

Thus, to obtain two consistent sewing operations from a given factorization to another one, we only need to check the consistency under these elementary moves.
The relations such as pentagon relation and hexagon relation shows that, all the different ways to go from a given factorization to another one are consistent.

== Sewing Local RCFTs

Using the construction above, the theory has a strong flavor of our naive picture of path integral gluing in QFT, i.e., summing over the states living on the boundary circles:
$
  Z(Sigma) = sum_(alpha) Z(Sigma_1, phi_alpha) * Z(Sigma_2, phi_alpha),
$
where $phi_alpha$ denotes the boundary local field configurations.
In CFT:
- Using state-field correspondence, the boundary local field configurations are identified with the states in the Hilbert space $H$ attached to the boundary circle.
- Boundary field configurations could be written as linear combinations of primary fields and their descendants:
  $ cal(L)_(-n) phi_(i)(z) := L_(-n_1) ... L_(-n_(N)) phi_(i)(z), $ where ${phi_(i)}$ is the set of primary fields, and ${L_(n)}$ are the Virasoro generators (we only consider chiral part here for simplicity).
- RCFT restricts the dimensional of the Hilbert space $H$ to be finite, thus we could select a finite basis ${phi_(i)}$ for the primary fields.
// #align(center)[
//   #figure(
//     image("./fig/pants_feynamn.jpeg", width: 200pt),
//     caption: [Attaching modules to the boundaries (punctures), which could be written as a "dual diagram", looks like Feynman diagram.],
//   )
// ]
#image_viewer(
  path: "../assets/global_rcft_pants_feynamn.png",
  desc: "Attaching modules to the boundaries (punctures), which could be written as a 'dual diagram', looks like Feynman diagram.",
  dark-adapt: true,
  adapt-mode: "invert-no-hue",
)

Thus, we could select a finite basis for the states living on the boundary circles ${ket(i\, n)}$, where $i$ labels the primary fields, and $n$ labels the descendants.
Consider sewing $M$ with puncture $p$ and $N$ with puncture $q$, the boundary state could be written as:
$
  ket(Phi_(M)) := sum_(i, n) A_(i\, n) ket(i\, n), quad bra(Phi_(N)) := sum_(j, m) B_(j\, m) bra(j\, m),
$
where the coefficients $A_(i\, n)$ and $B_(j\, m)$ could be written as some correlation functions involving the corresponding fields:
$
  A_(i,n) = angle.l O_1...O_(K) cal(L)_(-m)phi_(i)(p) angle.r_(M), quad B_(j,m) = angle.l cal(L)_(-m) phi_(j)(q) O_(K+1)...O_(K+L) angle.r_(N),
$
where we used state-operator correspondence to relate the states and local fields, here the puncture is understood as infinite past or future in the radial quantization.

The gluing procedure leads to a two punctured sphere, whose end points are inserted with the boundary states generated by descendants of primary fields.
Thus, the partition function on such sphere $bb(S)^(2)({p, z}, {q, w})$ is#footnote[Here we assume $q=1$ for simplicity, if we consider general sewing parameter $q$, we need to insert an additional factor $q^(L_0 - c/24)$ to take care of the change of complex structure.]:
$
  delta_(i j) M_(m n)^((i)) := angle.l cal(L)_(-m) phi_(i)(z=0) cal(L)_(-n) phi_(j)(w=0) angle.r_(bb(S)^(2)({p, z}, {q, w})),
$
thus, the amplitude from sewing $M$ and $N$ could be written as:
$
  bold(1) := sum_(i, m, n) ket(i\, n) (M^((i)))^(-1)_(m n) bra(i\, m),
$
(here we assume that $M$ is positive definite). Inserting this into the correlation functions on $M$ and $N$, we obtain the sewn chiral correlation function:
$
  angle.l O_1...O_(K+L) angle.r_(M oo^(p)_(q) N)
  := sum_(i, m, n) angle.l O_1...O_(K) cal(L)_(-m)phi_(i)(p) angle.r_(M) (M^((i)))^(-1)_(m n) angle.l cal(L)_(-m) phi_(i)(q) O_(K+1)...O_(K+L) angle.r_(N)
$

#proposition[The correlation functions defined above satisfy the properties of chiral correlation functions (Ward identity), thus defines a local RCFT on the sewn Riemann surface.]

#remark[
  Consider $K=L=2$ case and assume the inserted operators are primary fields $phi_1, ..., phi_(4)$, then the sewn four-point chiral correlation function could be written as:
  $
    angle.l phi_1 phi_2 phi_3 phi_4 angle.r_(M oo^(p)_(q) N) = sum_(i) (sum_(m,n) angle.l phi_1 phi_2 cal(L)_(-m)phi_(i)(p) angle.r_(M) (M^((i)))^(-1)_(m n) angle.l cal(L)_(-m) phi_(i)(q) phi_3 phi_4 angle.r_(N)).
  $
  Using the OPE:
  $
    phi_1(z) phi_2(w) = sum_(i) C_(12)^(i) (z-w)^(h_i - h_1 - h_2) phi_(i)(w) + ...,
  $
  and Wick contraction, we could rewrite the expression above as $ angle.l phi_1 phi_2 phi_3 phi_4 angle.r_(M oo^(p)_(q) N) = sum_(i) C_(12)^(i) C_34^(i) cal(F)_(i)(q), $
  which is exactly the conformal block expansion of the four-point chiral correlation function on the sewn sphere.
  The four points sphere could be understood as sewing two three-point spheres $bb(S)^(2)({p_1, z_1}, {p_2, z_2}, {p, z})$ and $bb(S)^(2)({q, w}, {p_3, z_3}, {p_4, z_4})$ together at punctures $p$ and $q$.

  In the notation above, we can easily see that ${cal(F)_(i)}$ forms a basis of the conformal blocks on the four-point sphere.
]

Now we focus on the primary fields correlator.
Due to the state-operator correspondence, a primary field would correspond to a highest weight state, thus form a subspace in the Hilbert space $V_(h)$.
In this case, the setup for our sewing operation could be summarized as:

- Consider sewing two Riemann surfaces $M$ and $N$ at punctures $p$ and $q$.
- On each puncture, we attach a vector space $V_(h)$ spanned by the primary field $phi_(h)$ and its descendants.

The second part corresponds to choosing a module $V_(h)$ of our chiral algebra $V$ (or vertex operator algebra if you like) to attach to the sewing punctures.

#remark[
  In general, the irreducible modules of an arbitrary conformal vertex operator algebra cannot be labeled by primary fields only, since there could be some logarithmic modules.

  However, in rational CFT case, there is a one-to-one correspondence between primary fields and irreducible modules.
  Which hints that the representation category of rational vertex operator algebra is semisimple.
]

Reviewing our previous discussion, we have:

#proposition[
  Given a factorization of a Riemann surface $Sigma_(g)({p_1, z_1},...,{p_(n), z_(n)})$, we have a basis of $cal(B)(V_h_1, ..., V_(h_(n)))$.
  The construction of such basis is:
  - Consider the pants decomposition of the Riemann surface $Sigma_(g)({p_1, z_1},...,{p_(n), z_(n)})$, which would give a set of three-point spheres $bb(S)^(2)({p_i, z_i}, {p_j, z_j}, {p_k, z_k})$.
  - On each sphere, two of the punctures are attached with the external modules $V_(h_i)$ and $V_(h_j)$, while the third puncture, called sewing puncture, is attached with an internal module $V_(h_k)$.
  - Sewing procedure would glue the sewing punctures on different spheres together, and sum over the choice of internal modules ${V_(h_k)}$.
  - Thus, the basis of $cal(B)(V_h_1, ..., V_(h_(n)))$ could be labeled by the choice of internal modules ${V_(h_k)}$ on the sewing punctures, i.e., ${F_({i_(k)})}$ where $i_(k)$ labels the internal module $V_(h_(i_k))$ on the $k$-th sewing puncture.
]

We need to check that the conformal blocks constructed above indeed form a basis of the space of conformal blocks $cal(B)(V_h_1, ..., V_(h_(n)))$.
We will do this in the next section.

#remark[
  Back to four point sphere case, the conformal block basis ${cal(F)_(i)}$ we obtained above is exactly the one given by the proposition, where there is only one sewing puncture attached with internal module $V_(h_(i))$.
]

== An-Aside: Three Point Sphere Conformal Blocks and Intertwining Operators

The conformal blocks on three point sphere $bb(S)^(2)({p_1, z_1}, {p_2, z_2}, {p_3, z_3})$ is related to the fusion rules of the modules attached to the punctures:
$
  phi_(i) times phi_(j) = sum_(k) N_(i j)^(k) phi_(k) -->^"State-Field" V_(h_(i)) times.circle V_(h_(j)) => sum_(k) N_(i j)^(k) V_(h_(k)),
$
which lead us to consider the intertwining operators among the modules:
$
  Phi^(i)_(j k)(z) in Hom(V_(h_(i)) times.circle V_(h_(j)), V_(h_(k))){z}: = V^(i)_(j k){z},
$
where $Phi^(i)_(j,k)(z)$ have conformal weight $h_(i)$, mapping (intertwining) the module $V_(h_(j))$ to $V_(h_(k))$.
If there are various intertwining operators of the same type, we denote them by $Phi^(i, alpha)_(j k)(z)$ where $alpha = 1, ..., N_(i j)^(k)$, thus the three point sphere conformal blocks could be written as:
$
  cal(B)_(0,3)(V_(h_(i)), V_(h_(j)), V_(h_(k))) = "Span"{Phi^(i, alpha)_(j k)(z)}_(alpha = 1)^(N_(i j)^(k)).
$
In the language of intertwining operators, the sewing operation which leads to the four point sphere conformal blocks $cal(B)(V_(h_i), V_(h_(j)), V_(h_(k)), V_(h_l))$
could be written as:
$
  sum_(p) bra(l) Phi^(j)_(i p)(z_1) Phi_(p l)^(k)(z_2) ket(i),
$
where $V_(p)$ is the internal module attached to the sewing puncture, and the factorization above corresponds to the s-channel Feynman diagram $(i j)k -> l$.

= Consistency Conditions

At the previous section, we have defined a sewing operation for local RCFTs, which is associated with the sewing of Riemann surfaces, and the gluing procedure in QFT.

However, such a construction is just "a" construction, to make it become "a consistent" construction of higher genus RCFTs from lower genus ones, we need to check some consistency conditions:

- Check the RCFT chiral correlator we defined is indeed a chiral correlator.
- There are various factorizations for a given Riemann surface, we need to show that the final RCFT defined is independent of the choice of pants decomposition.
- There are various way from a given factorization to another one, we need to check the consistency of these different ways.

The first point is the inner constrain for RCFT itself, where we have already mentioned it before, and second point is the outer constrain from the geometry of Riemann surfaces, corresponding to the mapping class group actions.

== Different Sewing Operations:

=== Gives Same Theory

A physical field theory defined on a Riemann surface should be independent of the choice of factorization of the surface, thus independent of the choice of sewing operations.

Recall our previous construction of conformal block basis from a given factorization, different factorizations would give different bases of the space of conformal blocks $cal(B)(V_(h_1), ..., V_(h_(n)))$.
What we need is to show that these different bases actually span the same space.

#theorem[
  ${F_({i_(k)})}$ we constructed from a given factorization of the Riemann surface $Sigma_(g)({p_1, z_1},...,{p_(n), z_(n)})$ satisfy:
  - They are Linearly independent.
  - They span the vector space of conformal blocks $cal(B)_(g,n)(V_h_1, ..., V_(h_(n)))$.
]

#proof[
  We only prove the four-point sphere block $cal(B)_(0,n)$ case here, the general case could be proved similarly by induction on the number of sewing operations.

  *Spanning.*
  Let $F in cal(B)_(0,4)(V_1, V_2, V_3, V_4)$. Cut the sphere along the circle
  separating ${1,2}$ from ${3,4}$. By state--field correspondence, insert the
  resolution of identity on the chiral state space:
  $
    bold(1) = plus.circle.big_(p in cal(I)) bold(1)_(V_p),
    quad
    bold(1)_(V_p) = sum_(m,n) ket(p\,n) (M^(p))^(-1)_(m n) bra(p\, m).
  $
  This yields a factorized expression of $F$ as a sum of contractions of two
  three-point blocks with an intermediate module $V_p$. Expanding those
  three-point blocks in the chosen bases ${psi^(12)_p}_alpha$ and
  ${psi^(34)_(p)}_beta$, we obtain
  $
    F = sum_(p, alpha, beta) c_(p, alpha, beta) cal(F)_(p, alpha, beta),
  $
  hence ${cal(F)_(p, alpha, beta)}$ spans $cal(B)_(0,4)$.

  *Linear independence.*
  Define a "cut map"
  $
    "Cut": cal(B)_(0,4)(V_1, V_2, V_3, V_4)
    -> plus.circle.big_(p in cal(I))
    cal(B)_(0,3)(V_1, V_2, V_p) times.circle cal(B)_(0,3)(V_p^or, V_3, V_4)
  $
  by cutting along the same circle and projecting onto the intermediate sectors
  using the non-degenerate two-point pairing $M^(p)$ (equivalently, using the
  inverse Gram matrix $(M^(p))^(-1)$ to extract coefficients of inserted
  descendants). One checks directly from the sewing construction that
  $
    "Cut" circle "Glue" = "Id".
  $
  Therefore $"Glue"$ is injective.
  Since the elements
  $(psi^(12)_p)_alpha times.circle (psi^34_(p))_beta$ are linearly independent in the
  direct sum, their images $cal(F)_(p, alpha, beta)$ are linearly independent in
  $cal(B)_(0,4)$.
]

Thus, different factorizations give different bases of the same space of conformal blocks $cal(B)(V_(h_1), ..., V_(h_(n)))$.
Which shows that our sewing operation for local RCFTs is consistent with the geometry of Riemann surfaces.

=== Consistent under Sewing Parameter Change: Elementary Moves

While different factorizations give rise to different bases of the space of conformal blocks, the change of basis must be independent of the chosen sequence of elementary sewing operations.

Like what we have mentioned before, to check such consistency, we only need to check the elementary moves given by Hatcher-Thurston theorem, i.e., F-move and S-move.

Such move would lead to a change of basis of the space of conformal blocks, we denote such change of basis by some matrices.

#remark[
  From now, $Phi(z)$ denotes a chiral field inserted at point with local coordinate $z$.
]

==== F-Move

F-move corresponds to changing the way to cut a four punctured sphere into two three punctured spheres, i.e., consider $bb(S)^(2)(p_(i), p_(j), p_(k), p_(l))$, F-move would correspond to exchanging $(l k) j ->^(p) i$ and $l(j k) ->^(q) l$ channel.
Here, $p$ $q$ denote the internal modules attached to the sewing punctures.

Thus, F-move would lead to a change of basis of the space of four-point conformal blocks, i.e. ${Phi_(i p)^(j) Phi_(p l)^(k)}_(p)$ and ${Phi_(j q)^(k) Phi_(i l)^(q)}_(q)$, which could be written as:
$
  Phi_(i p)^(j)(z_1) Phi_(p l)^(k)(z_2) = sum_(q) F_(p q)mat(j, k; i, l) sum_(Q in V_(h_(q))) Phi^(q)_(i l)(Q)(z_2) bra(Q) Phi^(j)_(q k)(z_(12)) ket(k).
$
where the matrix $F_(p q)mat(j, k; i, l): V^(i)_(q l) times.circle V^(q)_(j k) -> V^(i)_(j p) times.circle V^(p)_(k l)$ is called the _F-matrix_, and column $[j, k]$ denotes the fusion of modules $V_(h_(j))$ and $V_(h_(k))$, and row $[i, l]$ denotes the initial modules $V_(h_(i))$ and outer module $V_(h_(l))$.

#remark[
  If we consider the trivial modules, such F-move would reduce to the OPE associativity relation.
]

==== S-Move

The S-move corresponds to changing the way to cut a one punctured torus into a double punctured sphere, i.e., consider $bb(T)^(2)({p,z})$, S-move would correspond to exchanging the A-cycle and B-cycle cutting.

We assume the puncture $p$ is attached with module $V_(h_(i))$.

The _A-cycle_ cutting corresponds to cutting the torus into a double punctured sphere $bb(S)^(2)({p, z}, {q, w})$, where the punctures $p$ and $q$ are attached with modules $V_(h_(j))$ and $V_(h_(j^or))$ respectively.
Thus, the intertwining operator could be written as $Phi^(i)_(j j)(z)$, and the conformal block space could be written as:
$
  cal(B)_(1,1)(V_(h_(i))) = "Span"{bra(j) Phi^(i)_(j j)(z) ket(j)}_(j in cal(I)) := plus.circle.big_(j in cal(I)) V^(j)_(i j).
$
And the partition function on the torus could be written as:
$
  Z_(j)^(i)(bb(T)^(2)({p,z}), beta) = Tr (q^(L_(0) - c/24) Phi_(j j)^(i)(beta)(z) (dif z)^(h_(i))),
$
where $beta$ (a primary state) denotes the boundary filed configuration at the puncture $p$.

The _B-cycle_ cutting corresponds to cutting the torus into a double punctured sphere $bb(S)^(2)({p, z}, {q', w})$, where the punctures $p$ and $q'$ are attached with modules $V_(h_(k))$ and $V_(h_(k^or))$ respectively.

Thus, though the cutting are different, both of them give a basis of the same space of conformal blocks $cal(B)_(1,1)(V_(h_(i))):= plus.circle.big_(j in cal(J)) V^(i)_(i j)$, thus the only difference is the change of basis, which could be written as:
$
  S(i) : plus.circle.big_(j in cal(J)) V^(i)_(i j) -> plus.circle.big_(k in cal(K)) V^(i)_(i k).
$

==== Braiding Move

Unlike the punctured space case, conformal blocks on Riemann surfaces carries some important analytical structure, which leads to some nontrivial monodromy, and thus braiding operations.

The braiding move corresponds to exchanging two punctures on the Riemann surface, which leads to a map:
$
  Phi_(i q)^(j)(z_2) Phi_(q l)^(k)(z_1) ->^B Phi_(i p)^(k)(z_1) Phi_(p l)^(j)(z_2),
$
The full correlator function should be invariant under such braiding operation, thus the chiral part should transform linearly under such operation:
$
  Phi_(i q)^(j)(z_2) Phi_(q l)^(k)(z_1) = sum_(p) B_(p q)mat(j, k; i, l) Phi_(i p)^(j)(z_1) Phi_(p l)^(k)(z_2),
$
where the matrix $B_(p q)mat(j, k; i, l): V^(i)_(j p) times.circle V^(p)_(k l) -> V^(i)_(j q) times.circle V^(q)_(k l)$ is called the _braiding matrix_.

==== Twisting Move

The twisting move corresponds to twisting a puncture on the Riemann surface by $2 pi$ (Dehn twist), which leads to a map:
$
  T_(i): Phi_(i p)^(j)(z) -> Phi_(i p)^(j)(e^(2 pi i) z):= e^(2pi i (h_(i) - frac(c, 24))) Phi_(i p)^(j)(z).
$
=== Consistent under Sewing Parameter Change: Moore-Seiberg Equations

We have discussed the elementary moves (F and S move) leading to different sewing operations, which give rise to linear transformations $(F, S, B, T)$ on the space of conformal blocks.

Now we need to check the consistency of these transformations.

Firstly, as we mentioned before, different sequences of elementary moves from a given factorization to another one should give the same transformation on the space of conformal blocks.

Moreover, since we attach some RCFT data on these Riemann surfaces, these transformations should be compatible with the RCFT data.
Thus, our consistency conditions could be summarized as:

- Consistency of local RCFT data.
- Monodromy of conformal blocks form representations of the mapping class group.
- Different paths of the elementary moves relate same basis of conformal blocks.

Such consistency conditions are called the _Moore-Seiberg_ equations, or _Duality_ identities.

On _genus zero Riemann surfaces_, we have the following Moore-Seiberg equations:
- Pentagon relation for the F-move.
- Hexagon relation for the B-move and F-move.

// #grid(
//   columns: (1fr, 1fr),
//   align: center + horizon,
//   [
//     #figure(
//       image("./fig/pent.png", width: 200pt),
//       caption: [Pentagon Relation],
//     )
//   ],
//   [
//     #figure(
//       image("./fig/hex.png", width: 200pt),
//       caption: [Hexagon Relation],
//     )
//   ],
// )
#image_gallery(
  paths: ("../assets/global_rcft_pent.png", "../assets/global_rcft_hex.png"),
  dark-adapt: true,
  adapt-mode: "invert-no-hue",
)

From these relations, $B$ satisfies the Yang-Baxter equation.

Moreover, we have some modularity conditions for the S-move on _genus one Riemann surfaces_:
- $S^(2)(j) = plus.minus C e^(i pi h_(j))$, where $C$ is the charge conjugation matrix.
- $(S T)^(3) = S^(2)$ and some other relations coming from the modular group $"SL"(2, bb(Z))$.
- Other genus one relations, e.g., $S a S^(-1) = b$.

You may wander would there be some higher genus Moore-Seiberg equations?
The answer is yes, however, as we will see in the next section, all these higher genus consistency conditions could be derived from the genus zero and one Moore-Seiberg equations, i.e., the independent consistency conditions are just these we mentioned above.

== Completeness of the Consistency Conditions

It seems that we can construct infinitely many consistency conditions from various sewing operations on Riemann surfaces.

However, there is a result by Moore and Seiberg that shows that all these consistency conditions could be derived from a finite set of them, i.e., the Moore-Seiberg equations we mentioned before.

=== Abstract Nonsense Explanation

The simplest way to see this is using some "abstract nonsense" from category theory.

Note that the data $(F, S, B, T)$ we discussed above actually form a tensor category, or more precisely, a modular tensor category, using the MacLane's coherence theorem, such finite set of consistency conditions could be understood as the coherence conditions for the modular tensor category, thus all the other consistency conditions could be derived from them, i.e., the diagrams constructed from these data commute.

=== Geometric Explanation: Mapping Class Group Representations

However, the geometric meaning of such consistency might be more "physical", and related to the mapping class group actions on the Riemann surfaces.

The sewing procedures and the translations between them could be captured by a complex so-called the duality complex, where:

- Vertices: A basis of conformal blocks space.
- Edges: An elementary move ($F$, $B$, $T$, $S$ matrix) between two factorizations.

What we want to prove is that, all the loops in such complex are contractible while Moore-Seiberg equations are satisfied.

First, the pentagon relation of $F$ matrix can be used to transform any vertex to a standard form, called the _Multiperipheral Basis_.

// #align(center)[
//   #figure(
//     image("./fig/mp_basis.png", width: 200pt),
//     caption: [Multiperipheral Basis of Conformal Blocks],
//   )
// ]
#image_viewer(
  path: "../assets/global_rcft_mp_basis.png",
  desc: "Multiperipheral Basis of Conformal Blocks",
  dark-adapt: true,
  adapt-mode: "invert-no-hue",
)

Now, the only remaining edges are related to $B$, $T$, and $S$ moves.
Thus, such operations could be identified with the elements of the mapping class group $"MCG"_(g,n)$.

#fact[$"MCG"_(g,n)$ is finitely presented.]

Using this fact, every large loop in the duality complex could be decomposed into a sequence of smaller loops, each of which corresponds to a relation in the mapping class group:

- Braiding loop, which is contactable due to the hexagon relation of $B$ and $F$ matrix (Yang-Baxter equation).
- Dehn twist relations, which is contractible due to the modularity relations of $S$ and $T$ matrix.

Thus, all the loops in the duality complex are contractible while the Moore-Seiberg equations are satisfied.
