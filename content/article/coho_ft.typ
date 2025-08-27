#import "../../typ/templates/blog.typ": *
#let title = "Cohomological Field Theory"
#show: main.with(
  title: title,
  desc: [A brief introduction to cohomological field theory under the $L_oo$ BV construction, which is the mathematical foundation of Witten's original consideration of Donaldson's theory (The first part about L-infinity BV is finished).],
  date: "2025-08-17",
  tags: (
    blog-tags.physics,
    blog-tags.quantum-field,
  ),
)

*Warning*: Typst html output is experimental and may not work as expected. For example, the non-file/non-URL links would not work properly.

= $L_oo$ BV Construction
Locally, we can identify the BV algebra with $L_oo$ algebra
$( V , {mu_i}_n )$ with cyclic structure $omega$ (c.f.
@jurco_l_infty-algebras_2019), whose degree $0$ form could be viewed as
the physical field and $mu_1$ could be interpreted as linear operator
arose from free field equation of motion, and the higher bracket $mu_n$
need to satisfying the homotopic Jacobian identity and make the
classical equation of motion become MC equation.

The cyclic structure could be viewed as locally shifted $- 1$ symplectic
form, which is a non-degenerate pairing
$omega : V times.circle V arrow.r bb(R)$ , which satisfies the cyclicity
condition under Koszul sign rule
$
  omega ( mu_n ( a_1 , dots.h , a_n ) , a_(n + 1) ) = ( - 1 )^(lr(|a_0|) ( lr(|a_1|) + dots.h + lr(|a_n|) )) omega ( a_(n + 1) , mu_n ( a_1 , dots.h , a_n ) ) ,
$
where $lr(|a_i|)$ is the degree of the element $a_i$.

A useful construction is to collect all the (descended) fields into a
'superfield' $Phi$ , which means we essentially working on
$S^c V = xor.big_i V^(and n)$ with Koszul sign rule, while the bracket
could be defined as $B = mu_1 + dots.h.c$ which satisfies $B^2 = 0$ i.e.
a coderivation over $S^c V$.

The action of $B$ is understood below: Consider projections
$pi_n : S^c V arrow.r V^(and n)$, thus $b_n$ could be defined as the
part of $pi_1 B$ which acts on $V^(and n)$. The homotopic Jacobian
identity could be identified as $B^2 = 0$.

Using the superfield $Phi$ and local shifted $- 1$ symplectic pairing
$omega$ , the BV action could be defined as
$
  S = omega (pi_1 B times.circle I) : S^c V times.circle S^c V arrow.r bb(R) ,
$
$
  Phi mapsto sum_i frac(1, ( i + 1 ) !) omega (Phi , mu_i ( Phi , dots.h.c , Phi )) ,
$
whose Euler-Lagrangian equation of motion after projecting to $V$ is
indeed the classical equation of motion i.e. the MC equation over $L_oo$
algebra $V$.

We shall consider $d$ dimensional Yang-Mills theory as an example, whose
'physical' fields is the connection
$A in Omega_(frak(g))^1 ( X ) [ 1 ]$ whose $L_oo$ degree is $0$. One
shell introduce the ghost field
$psi in Omega_(frak(g))^0 ( X ) [ 1 ]$, anti-field
$A^(star) in Omega_(frak(g))^(d - 1) ( X ) [ 1 ]$ and the anti-ghost
field $psi^(star) in Omega_(frak(g))^d ( X ) [ 1 ]$. Consider the
linearized Yang-Mills equation, one can obtain the $L_oo$ algebra
structure as follows:
$
  & mu_1 (psi_1) := dif psi_1 , quad
  mu_1(A_1) := dif star A_1 , quad
  mu_1(A_1^(star)) := dif A_1^star , quad mu_1(psi^(star)_1) = 0 ,\
  & mu_2(psi_1 , psi_2) := [ psi_1 , psi_2 ] , quad
  mu_2(psi_1 , A_1) := [ psi_1 , A_1 ] , quad \
  & mu_2(psi_1 , A_2) := [psi_1, A_2^(star)] , quad
  mu_2(psi_1 , psi_2^(star)) := [psi_1, psi_2^(star)] , quad \
  & mu_2(A_1 , A_2^(star)) := [A_1, A_2^(star)] , quad
  mu_2 (A_1 , A_2) = dif star [A_1 , A_2] + [A_1, star dif A_2] + [A_2, star dif A_1] , \
  & mu_3(A_1, A_2, A_3) = [A_1, star [A_2, A_3]] + [A_2, star [A_1, A_3]] + [A_3, star [A_1, A_2]] ,
$
And the non-trivial symplectic form $omega$ would be defined as:
$
  omega ( A , A^(star) ) = integral_X angle.l A , A^star angle.r , quad omega ( psi , psi^(star) ) = integral_X angle.l psi , psi^(star) angle.r ,
$
where $angle.l dot.op , dot.op angle.r$ is the Killing form on the Lie algebra
$frak(g)$.

Especially, at the chain level, $mu_1$ part would induce a cochain
complex
$
  cal(E)_(upright(Y M))^(upright(B V)) := {Omega_(frak(g))^0 ( X ) arrow.r.long^(mu_1 = dif) Omega_(frak(g))^1 ( X ) arrow.r.long^(mu_1 = dif star dif) Omega_(frak(g))^(d - 1) ( X ) arrow.r.long^(mu_1 = dif) Omega_(frak(g))^d ( X )} ,
$
which satisfies $mu_1^2 = 0$, and the action could be written as
$
  S [ A , A^(star) , psi , psi^(star) ] = integral_X [1 / 2 angle.l F , star.op F angle.r - angle.l A^(star) , dif_A psi angle.r + 1 / 2 angle.l psi^(star) , [ psi , psi ] angle.r ] ,
$
where $dif_A = dif + [ A , dot.op ]$ is the covariant
derivative induced via gauge connection $A$. If we denote $mu_1$ as
cohomological vector field $Q$, the BV action could be written as
$
  S [ cal(A) ] = integral_X [1 / 2 angle.l cal(A) , Q cal(A) angle.r + frac(1, 3 !) angle.l cal(A) , mu_2 ( cal(A) , cal(A) ) angle.r + frac(1, 4 !) angle.l cal(A) , mu_3 ( cal(A) , cal(A) , cal(A) ) angle.r ] ,
$
which is called homotopic Chern-Simons action, where $cal(A)$ is the
superfield.

Another important example is the Chern Simons theory in three dimension,
whose $L_oo$ algebra structure is given by:
$ & mu_1 ( psi_1 ) := dif psi_1 , quad mu_1 ( A_1 ) := dif A_1 , quad mu_1 ( A_1^(star) ) := dif A_1^(star) , \
& mu_2 ( psi_1 , psi_2 ) := [ psi_1 , psi_2 ] , quad mu_2 ( psi_1 , A_1 ) := [ psi_1 , A_1 ] , \
& mu_2 ( psi_1 , A_2 ) := [ psi_1 , A_2^(star) ] , quad mu_2 ( psi_1 , psi_2^(star) ) := [ psi_1 , psi_2^(star) ] , \
& mu_2 ( A_1 , A_2^(star) ) := [ A_1 , A_2^(star) ] , quad mu_2 ( A_1 , A_2 ) = [ A_1 , A_2 ] $ and the non-trivial symplectic form $omega$ would be defined as what
we have defined above. The action could be written as
$
  "CS" [ cal(A) ] = integral_X [1 / 2 angle.l cal(A) , dif cal(A) angle.r + 1 / 6 angle.l cal(A) , [cal(A) , cal(A)] angle.r ] ,
$
where $cal(A) = A + A^(star) + psi + psi^(star)$ is the super field. We can
simply note that this action is simply the Chern-Simons action, which
only use the superfield $cal(A)$ to replace the original (no BV) field
$A$ #footnote[In fact, if the theory is associated to the flat bundle, i.e. The classical equation of motion in first order is $dif A = 0$,
  one could always expect to use the same mechanism $A arrow.r cal(A)$ to
  obtain the BV action.];.

= Four Dimensional Cohomological Field Theory: Witten's Original Consideration
<four-dimensional-cohomological-field-theory-wittens-original-consideration>
Now we want to consider Witten's construction of so-called
#emph[cohomological field theory];, which would lead to Donaldson's
theory. Consider self-dual Yang-Mills equations on a four-manifold $M$:
$ F = star.op F , $<eq:self_dual_yang_mills_instanton>
the aim of Witten's construction is to construct a cohomological field theory which
would lead to the solution or moduli space of
#link(<eq:self_dual_yang_mills_instanton>)[\[eq:self\_dual\_yang\_mills\_instanton\]];.

== Observables
<observables>
The BRST symmetry is defined as:
$
  [Q , A] = psi , quad [Q , psi] = - dif_A phi.alt , quad [Q , phi.alt] = 0 ,
$<eq:brst_symmetry_1>
where $A^a$ take value in a Lie algebra $frak(g)$, ghost $psi^a$ which
is a fermionic field takes value in $frak(g)$, and commuting field
$phi.alt^a$ which is the generator of the gauge transformation who will
generate gauge transformation by
$[ Q , [ Q , A ] ] = - dif_A phi.alt$.

One could simply verify that $Q^2 = 1 / 2 [ Q , Q ] = 0$ up to the
gauge transformation, and weather the bracket is anti or not is chosen
via the Koszul sign rule. Such a construction could be viewed as the
Cartan model of $G$ equivariant cohomology.

The ghost number would become $U = 0 , 1 , 2$ respectively, and
$A^a , psi^a$ has differential form degree $1$ and $phi.alt^a$ has form
degree $0$.

Now we shell use the BRST symmetry
#link(<eq:brst_symmetry_1>)[\[eq:brst\_symmetry\_1\]] to construct the
observables, which, in fact, only depends on the homology class of the
spacetime manifold $M$.

First, we shell consider the #emph[zeroth] observable
$cal(O)_(k,0)(x) = tr phi^(k)(x)$, which is a local
function on the spacetime manifold $M$ and is BRST invariant, i.e.
$[Q , cal(O)_(k , 0) ( x )] = 0$.

Now we shell consider
$
  dif cal(O)_(k, 0) = k tr phi^(k - 1) dif_A phi = [ Q, - tr phi^(k - 1) psi ] ,
$
thus $dif cal(O)_(k , 1)$ is a BRST exact observable, which
means it would become a global constant up to an BRST exact term.
Furthermore, define $cal(O)_(k,1) = - tr phi^(k-1) psi$
which is a one form on $M$, we have
$
  dif cal(O)_(k,1) = - k (k-1) tr phi^(k-2) psi dif_A phi - k tr phi^(k-1) dif_A psi = [ Q, cal(O)_(k, 2) ] ,
$
where $cal(O)_(k,2) = -k tr ((k-1) phi^(k-2)[psi, psi] + phi F )$. Using the mechanism above, we can construct the $n$-th observable as
follows:
$
  dif cal(O)_(k , 0) = & [Q , cal(O)_(k , 1)] , quad dif cal(O)_(k , 1) = [Q , cal(O)_(k , 2)] , \
  dif cal(O)_(k , 2) = & [Q , cal(O)_(k , 3)] , quad dif cal(O)_(k , 3) = [Q , cal(O)_(k , 4)] , \
  dif cal(O)_(k , 4) = & 0 ,
$
which is so-called
#emph[topological descendant equation];. Consider $n$ dimensional closed
manifold $Y subset M$, we could introduce the observable as follows:
$ W_k ( Y_n ) = integral_(Y_n) cal(O)_(k , n) , $ which are all BRST
close and only depends on the $n$-th homology class of the manifold $M$,
since
$ [ Q , W_k ( Y_n ) ] = integral_(Y_n) dif cal(O)_(k , n) = 0 , $
and if $Y_n$ is a trivial homology class i.e. $Y_n = partial X_(n + 1)$,
thus
$
  W_k ( partial X_(n + 1) ) = integral_(X_(n + 1)) dif cal(O)_(k , n) = integral_(X_(n + 1)) [Q , cal(O)_(k , n + 1)] = [ Q , W_(k , n + 1) ] = 0 .
$
What we have constructed above is a family of BRST invariant observables
$W_k ( Y_n )$ which only depends on the homology class of the manifold
$M$ i.e. $H_bullet ( M )$.

The more general field could be added into the BRST symmetry, which is
called anti-fields and thus extend the theory with BRST symmetry to BV
field theory. In the construction from Witten, this means add field
$( lambda , eta )$ with ghost number $( - 2 , - 1 )$ respectively,
where $lambda$ has same quantum number#footnote[Which means it would
  transform as the Lie algebra of gauge group $G$.] as $phi.alt$ and $eta$
is the partner of $lambda$. And we introduce $( chi , H )$ field with
ghost number $( - 1 , 0 )$ where $H$ is the partner of $chi$ and
$chi$ has same quantum number of equation of motion but has spin
statistic.

The BRST symmetry of the new added fields could be listed below:
$ [Q , lambda] = eta , quad [Q , eta] = [ lambda , phi.alt ] , $
$ [Q , chi] = & H , quad [Q , H] = [ chi , phi.alt ] , $
which
could be simply derived from the original BRST symmetry
#link(<eq:brst_symmetry_1>)[[eq:brst_symmetry_1]] by adding the new
fields and their BRST symmetry.

== Lagrangian
<lagrangian>
= Four Dimensional Cohomological Field Theory: Relation to $L_oo$ BV Construction
<four-dimensional-cohomological-field-theory-relation-to-l_infty-bv-construction>

= Two Dimensional Cohomological Field Theory: Chiral Field Theory and it's Deformation

#bibliography("/content/refs/coho_ft.bib")
