#import "../../../typ/templates/blog.typ": *
#import "../../../typ/packages/typst-fletcher.typ": *
#import "../../../typ/packages/physica.typ": *
#let title = "Feynman Rules as a Monad"
#show: main.with(
  title: title,
  desc: [The definition of Feynman rules can be captured using the language of monads, and the "renormalization" procedure corresponds to the generalized (co)bar construction.],
  date: "2025-12-16",
  tags: (
    blog-tags.math,
    blog-tags.physics,
    blog-tags.algebra,
    blog-tags.abstract-nonsense,
  ),
  lang: "en",
  translationKey: "graph_monad",
)

#let Mod = math.bold("Mod")
#let Aut = math.text("Aut")
#let stable = math.text("stable")
#let sMod = [$#Mod^#stable$]

= Feynman Rules in QFT

Let us briefly recall the Feynman rules in perturbative quantum field theory (QFT).

A field theory described by a Lagrangian can typically be decomposed into:
- *Free part:* Quadratic terms in the fields.
- *Interaction part:* Higher-order terms in the fields.

When expanding the path integral perturbatively using Wick's theorem, each term in the expansion can be represented by a Feynman diagram, constructed via the following rules:
- *Graph* $Gamma(g, n)$: A graph of genus $g$ with $n$ labeled external legs.
- *Edges:* Correspond to the propagator $angle.l phi_1(x_1) phi_2(x_2)angle.r$, derived from the free part of the Lagrangian.
- *Vertices:* Correspond to interaction terms in the Lagrangian.
The valence of each vertex is determined by the order of the interaction term.

Finally, after integrating over all internal vertices and summing over all possible graphs, we obtain the perturbative expansion of the correlation functions.

This procedure of assigning algebraic data to each edge and vertex constitutes the *Feynman rules*.

The free part is crucial for calculating the Feynman integrals and we will not discuss it here.
In this post, we will focus on the combinatorial structure of the graphs and the procedure of assigning data to their vertices.

Let us now formulate these ideas rigorously.

= The Vertex

First, the possible contributions for a vertex can be organized into a specific structure #footnote([If there are additional structures input from the theory, such as grading, we should replace the vector space with the corresponding object, e.g., a graded vector space.]):
- A vector space graded by the valence of the vertex.
- A permutation action of the symmetric group $bb(S)_n$ on the degree $n$ part, representing the permutation of leg labels.

Thus, such contributions form an $bb(S)$-module (or symmetric sequence), where $bb(S)_(n)="Aut"({1,...,n})$. An $bb(S)$-module is a sequence of vector spaces $V = {V(n), n>0}$, each equipped with an action of $bb(S)_n$.

We can form the category of $bb(S)$-modules, denoted by $Mod_(bb(S))$, whose objects are $bb(S)$-modules and morphisms are $bb(S)$-equivariant linear maps.

This vector space may correspond to additional data.
In our context, it is natural to consider the genus grading. That is, each $V(n)$ can be further decomposed as:
$
  V(n) = plus.big_(g >= 0) V(g, n),
$
where $g$ is a non-negative integer representing the genus, satisfying the *stability condition* $2g - 2 + n > 0$.
If we restrict ourselves to tree-level contributions, we set $g = 0$ and require $n >= 3$ (or $n>=2$ for propagators), effectively ignoring unstable tadpole diagrams.
Since this condition corresponds to stability in the theory of modular operads, we denote the category of such $bb(S)$-modules as $Mod^(stable)_(bb(S))$, i.e., stable $bb(S)$-modules.

= The Graph

Next, we consider the graphs.
Defining a graph intuitively is easy, but establishing the precise axiomatic framework is subtle.
A natural way to describe a graph is by:
- Collecting all vertices into a set $V(Gamma)$.
- Assigning a set of half-edges $H(v)$ to each vertex $v in V(Gamma)$. The cardinality of this set is the valence $n(v)$.
- Pairing half-edges to form edges. The set of edges is denoted by $E(Gamma)$.
- The remaining unpaired half-edges are called (external) legs, denoted by $L(Gamma)$, with cardinality $n$.

Moreover, a labeled graph assigns a non-negative integer $g(v)$ to each vertex $v$, called the genus of the vertex.
The genus of the graph $Gamma$ is defined as:
$
  g(Gamma) = sum_(v in V(Gamma)) g(v) + b_1(Gamma),
$
where $b_1(Gamma)$ is the first Betti number of the graph #footnote([This definition of genus is standard in the context of modular operads. Unlike the usual graph genus (Betti number), we decorate each vertex with "inner" genus data, which is essential for the monad structure.]).
Such a diagram is denoted as $Gamma_(g)$.

We define a labeled graph $Gamma(g, n)$ as a pair $(Gamma_(g), rho)$, where $rho: {1,...,n} -> L(Gamma)$ is a bijection labeling the legs.

The category of labeled graphs with genus $g$ and $n$ labeled legs, denoted as $Gamma((g,n))$, has objects as labeled graphs $Gamma(g, n)$ and morphisms as graph morphisms preserving the leg labeling.

We omit the technical definition of graph morphisms here. Roughly speaking, a morphism is a map between two graphs that preserves the connectivity structure of vertices, edges, and legs.

There exists a terminal object in $Gamma((g,n))$: the single-vertex graph $*_(g,n)$ with no edges, one vertex of genus $g$, and $n$ legs.

= Feynman Rules Revisited

We can now reformulate the Feynman rules using the language of category theory for $sMod_(bb(S))$ and $Gamma((g,n))$.

In this context, a Feynman rule is specified by:
- An object $V$ in $sMod_(bb(S))$.
- An isomorphism class of graphs $[Gamma(g, n)]$ in $Gamma((g,n))$.
Summing over all possible isomorphism classes of graphs $[Gamma(g, n)]$, we obtain an endofunctor on $sMod_(bb(S))$, denoted by $bb(M)$:
$
  bb(M) V(g,n) tilde.equiv plus.big_(Gamma in [Gamma(g, n)]) V(Gamma)_(Aut(Gamma)) := plus.big_(Gamma in [Gamma(g, n)]) V(g,n)_(Aut(Gamma)),
$
where $V_(G)$ is the coinvariant space of a $G$-module $V$.

Since $bb(M)$ is an endofunctor on $Mod_(bb(S))$, we can consider the relationship between $bb(M)^(2) V$ and $bb(M) V$.

Moreover, we can consider $bb(M)^(k) V(g,n)$ for any positive integer $k$.
By definition, such composition corresponds to:
- At the level of graphs,
  - Consider a Feynman diagram.
  - For each vertex in the diagram, we replace it with another Feynman diagram.
- At the level of vector spaces,
  - For each vertex, assigning a vector space $bb(M)^(k-1)V(Gamma)$ to it.
  - Obtaining a new vector space by applying the Feynman rule again.
There exists a natural transformation $mu: bb(M)^(2)V -> bb(M) V$, called the *multiplication* of the endofunctor $bb(M)$. This corresponds to the operation of:
- Substituting diagrams into vertices.
- Flattening into a single diagram.
- Using the Feynman rule to obtain a vector space.

For $bb(M)^(3)V$, there are two ways to flatten the nested diagrams (associativity):
- Flatten the lowest level first, then the resulting diagrams.
- Flatten the highest level first, then the resulting diagrams.
Both procedures yield the same result, satisfying the associativity condition.

Moreover, there is a unit transformation $eta: id -> bb(M)$, where $id$ is the identity endofunctor. This corresponds to the inclusion of the single-vertex graph $*_(g,n)$.

Thus, the endofunctor $bb(M)$, together with $mu$ and $eta$, forms a *monad* on the category $sMod_(bb(S))$.
This demonstrates that the combinatorial structure of Feynman rules is perfectly captured by the language of monads.

= Modular Operads

Recall that a (cyclic) operad is simply an algebra over a specific monad corresponding to trees.

Since our monad $bb(M)$ is defined using graphs with genus loops, its algebras generalize operads to what are known as *modular operads*.

Precisely, a modular operad $cal(A)$ is an algebra over the monad $bb(M)$, equipped with a structure map $rho: bb(M)cal(A) -> cal(A)$ satisfying:
- *Associativity:* $rho compose mu_(cal(A)) = rho compose bb(M)(rho)$.
- *Unit:* $rho compose eta_(cal(A)) = id_(cal(A))$.

We denote a modular operad as a pair $(cal(A), rho)$.

= Multiplication Functor and Renormalization

Having defined Feynman rules via monads, we turn to *renormalization*, a crucial procedure in perturbative QFT.

== The Idea

Wilson's Renormalization Group (RG) approach suggests that to obtain an effective theory at a lower energy scale, we must:
+ Integrate out high-energy modes, causing original interaction terms to "flow" into effective interactions.
+ Rescale fields and coupling constants.
+ Retain only relevant and marginal interaction terms at low energy.

The multiplication functor $mu$ naturally describes the combinatorial aspect of the first step: the contraction of internal edges corresponds to the integration of propagators.

== Bar Construction

Given a modular operad $cal(A)$ constructed from a monad $bb(M)$, the renormalization procedure can be captured by the map:
$
  bb(M) cal(A) ->^rho cal(A),
$
where $rho$ is the structure map of the modular operad $cal(A)$.

Consider applying the functor $bb(M)$ iteratively. This corresponds to a hierarchy of nested contractions (or scales).
We obtain a sequence of maps:
#diagram-frame(edge => [$
    #diagram(
      node((0, 0), $dots.c$),
      node((1, 0), $bb(M)^(2) cal(A)$),
      node((2, 0), $bb(M) cal(A)$),
      node((3, 0), $cal(A),$),

      edge((0, 0), (1, 0), "->", shift: -5pt),
      edge((0, 0), (1, 0), "->", shift: 0pt),
      edge((0, 0), (1, 0), "->", shift: 5pt),

      edge((1, 0), (2, 0), "->", shift: -3pt, label: $mu dot id_cal(A)$, label-side: left),
      edge((1, 0), (2, 0), "->", shift: 3pt, label: $bb(M) dot rho$, label-side: right),

      edge((2, 0), (3, 0), "->", label: $rho$),
    )
  $])
This is a simplicial object in the category $sMod_(bb(S))$, forming the *bar construction* of the modular operad $cal(A)$.

Simplicial objects encode face maps ${diff_(i)}$ and degeneracy maps ${sigma_(i)}$, giving rise to homological structures. The "master equation" $diff^(2) = 0$ encodes the consistency conditions of the theory, specifically the associativity and unit axioms of the monad.

Consider the specific structure of the boundary operator $diff$.
The face map $diff_i$ essentially corresponds to contracting the graph at the $i$-th level of nesting. The expression for such a map is:
$
  diff_(i) = cases(
    bb(M)^(i) compose mu compose bb(M)^(n-1-i)\, thin & 0<=i<n,
    bb(M)^(n) compose rho\, & thin i=n\,
  )
$
These maps satisfy the simplicial identity $diff_(i) diff_(j) = diff_(j-1) diff_(i)$.

Using these face maps, we define the total boundary map $diff_((n)): bb(M)^(n+1)cal(A) -> bb(M)^(n) cal(A)$ as:
$
  diff_((n)) = sum_(i=0)^(n) (-1)^(i) diff_(i),
$
where the master equation $diff^(2)_((n)) = 0$ is satisfied since the simplicial identity.

#remark([
  This bar construction is a natural generalization of the classical bar construction in homological algebra. There, a chain complex can be viewed as a 1-dimensional tree, and the face maps correspond to the "splitting" of vertices.

  Restricting our diagrams to trees (genus 0) yields the bar construction for cyclic operads, where the composition map corresponds to linking the legs of two trees.
])

= Outlook

We have built a "categorical description" of Feynman diagrams, primarily at the level of vertices and their composition.

However, essential data remains uncaptured.
For example, in perturbative Chern-Simons theory, the correlation function (on $bb(R)^(3)$) involves the Gaussian linking number, which is sensitive to the *orientation* of edges.
Thus, to develop a full categorical description, one must account for orientation data.
This leads to the concept of "twisted modular operads," which is intimately related to Kontsevich's graph complex—the "true" home of Chern-Simons perturbation theory.

But that is a story for another time.
