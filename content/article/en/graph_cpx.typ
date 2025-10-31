#import "../../../typ/templates/blog.typ": *
#import "../../../typ/packages/typst-fletcher.typ": *
#import "../../../typ/packages/physica.typ": *

#let title = "Graph Complex and AKSZ Construction"
#show: main.with(
  title: title,
  desc: [Graph complex formulated BV gauge invariant sub-algebra of observables in AKSZ-type topological field theories.],
  date: "2025-11-1",
  tags: (
    blog-tags.math,
    blog-tags.physics,
    blog-tags.algebra,
    blog-tags.topology,
  ),
  lang: "en",
  translationKey: "graph_cpx",
)

#let BV = math.upright("BV")
#let wedge = math.and

= Idea

We've already seen in the previous blog that, consider Chern-Simons theory with holomorphic gauge fixing, the perturbative expansion of gauge theory could be written as Kontsevich integral.
However, there are some questions left unanswered:
- Is this perturbative expansion gauge invariant?
- Is there a general framework to understand such phenomenon in other theories?
The first question leads us to consider Batalin-Vilkovisky (BV) formalism, and the gauge invariant here could be understood as the closure under BV operator $Delta$ (after some important renormalization procedure).
The second question could be answered using the AKSZ construction of topological field theories.

Before going into details, let's summarize some key points.
- Roughly speaking, BV operator $Delta$ could be understood as contracting fields in an observable using the "derivative" of the propagator.

  In topological field theories, such contraction would lead to a $delta$-function, which means two points in the configuration space collides, or the link in the Feynman diagram shrinks to a point.

  Therefore, the action of BV operator $Delta$ on observables could be understood as "shrinking edges" in the corresponding Feynman diagrams.

- Thus, the BV algebra of gauge invariant observables might be modeled by a pairing $(C(Gamma), d_(Gamma))$, where $C(Gamma)$ is the set of connected Feynman diagrams (graphs), and the differential $d_(Gamma)$ is given by shrinking edges in the graphs.

  Such a pairing would lead to the so-called "graph complex", which was first introduced by Kontsevich.

= BV Formalism for Chern-Simons Theory

Let us briefly review the BV formalism for Chern-Simons theory.
The original Chern-Simons action is given by gauge connection $X -> Omega^(1)_(frak(g))(X)$.
BV formalism lead us to consider the fattened space:
- Spacetime $X$ $-->$ topological space $X$ with structure sheaf $Omega^(bullet)(X)$.
- Lie algebra $frak(g)$ $-->$ differential graded Lie algebra (DGLA) $frak(g)_(bullet) = frak(g) times.circle frak(g)[1]$.
Thus, the BV Chern-Simons action is given by
$
  S_(BV) = integral_(X) tr_(frak(g)) (1/2 cal(A) wedge d cal(A) + 1/6 cal(A) wedge [cal(A), cal(A)]),
$
where $cal(A) in Omega^(bullet)(X) times.circle frak(g)$ is the BV gauge field.
We can simply verify that $S_(BV)$ satisfies the classical master equation ${S_(BV), S_(BV)} = 0$ with respect to the BV anti-bracket induced by the odd symplectic structure.

= Graph Complex

== Graph Complex of Points

== Graph Complex of Knots

== An Aside: Moduli Space of Riemann Surfaces and Graph Complex

= BV Gauge Invariant Observables

= Feynman Diagrams in AKSZ Theories
