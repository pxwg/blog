#import "../../../typ/templates/blog.typ": *
#import "../../../typ/packages/typst-fletcher.typ": *
#import "../../../typ/packages/physica.typ": *
#let title = "Feynman Rule as a Monad"
#show: main.with(
  title: title,
  desc: [The definition of Feynman rules can be captured using the language of monad, and the "renormalization" procedure corresponds to the generalized (co)bar construction.],
  date: "2025-12-16",
  tags: (
    blog-tags.math,
    blog-tags.physics,
    blog-tags.topology,
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

Let's recall the Feynman rules in perturbative quantum field theory.

A field theory described by a Lagrangian could always be split into:
- Free part: quadratic terms in the fields.
- Interaction part: higher order terms in the fields.

While we expand the path integral perturbatively, using Wick's theorem, each term in the expansion can be represented by a Feynman diagram, constructed using the following rules:
- Graph $Gamma(g, n)$: a genus $g$ graph with $n$ labeled external legs.
- Edges: correspond to $angle.l phi_1(x_1) phi_2(x_2)angle.r$, derived from the free part of the Lagrangian.
- Vertices: correspond to interaction terms in the Lagrangian.
The valence of each vertex is determined by the order of the interaction term.

Finally, after integrating over all internal vertices and summing over all possible graphs, we obtain the perturbative expansion of the correlation functions.

Such a procedure of assigning data to each edge and vertex, is called the *Feynman rule*.

The free part is crucial for calculating the Feynman integrals and we will not discuss it here.
In this blog, we will focus on the graphs and the procedure of assigning data to their vertices.

Now we try to formulate the idea above.

= Vertex

First, the possible contributions for a vertex can be organized into #footnote([If there are some additional structures input form the theory, such as grading, we should replace the vector space by the corresponding object, e.g., graded vector space, etc.]):
- Vector space graded by the valence of the vertex.
- Permutation action of the symmetric group $bb(S)_n$ on the degree $n$ part, by permuting the labels of the legs.
Thus, such contributions form an $bb(S)$-module, where $bb(S)_(n)="Aut"({1,...,n})$ and a $bb(S)$-module is a sequence of vector spaces $V = {V(n), n>0}$, each equipped with an action of the symmetric group $bb(S)_n$.

We can also form the category of $bb(S)$-modules, denoted by $Mod_(bb(S)_(n))$, whose objects are $bb(S)$-modules and morphisms are $bb(S)_(n)$ equivariant linear maps.

Such vector space may correspond to some additional data.
In our context, it would be natural to consider the genus grading, i.e., each $V(n)$ could be further decomposed as:
$
  V(n) = plus.big_(g >= 0) V(g, n),
$
where $g$ is a non-negative integer representing the genus, satisfying stable condition $2g - 2 + n >= 0$.
If we only consider tree level contributions, we can set $g = 0$ and have $n >= 2$, corresponding to ignore all tadpole diagrams.
Since such condition corresponds to the stable condition in the theory of modular operads, we can denote the category of such $bb(S)$-modules as $Mod^(stable)_(bb(S))$, i.e., stable $bb(S)$-modules.

= Graph

Next, we consider the graphs.
"Understanding" a graph is seemingly easy, but deciding "under" which axioms it should "stand" is subtle.
A natural way to describe them is:
- Collecting all vertices, which forms a set $V(Gamma)$.
- Given a vertex $v in V(Gamma)$, we have a set of half-edges $H(v)$ attached to it. Its cardinality is called the valence of the vertex $n(v)$.
- Identifying a half-edge from two vertices, which forms an edge. The set of edges is denoted by $E(Gamma)$.
- The remaining half-edges are called (external) legs, denoted by $L(Gamma)$, whose cardinality is $n$.

Moreover, a labeled graph could assign a non-negative integer $g(v)$ to each vertex $v$, called the genus of the vertex.
Thus, the genus of the graph $Gamma$ is defined as:
$
  g(Gamma) = sum_(v in V(Gamma)) g(v) + b_1(Gamma),
$
where $b_1(Gamma)$ is the first Betti number of the graph #footnote([Well, this definition of genus is a bit odd. Usually, we define the genus of a graph as its first Betti number. Here we add some "inner" data to each vertex, which is useful in the study of the monad structure.]).
And such diagram could be denoted as $Gamma_(g)$

Thus, we can also define the labeled graph $Gamma(g, n)$ as a pair $(Gamma_(g), rho)$, where $rho: {1,...,n} -> L(Gamma)$ is a labeling of the legs, which is a bijection.

The category of labeled graphs with genus $g$ and $n$ labeled legs, denoted as $Gamma((g,n))$, can be defined, whose objects are labeled graphs $Gamma(g, n)$ and morphisms are morphisms of graphs preserving the labeling of legs.

Well, I think we should also define what a morphism of graphs is, but I will skip it here.
Roughly speaking, a morphism of graphs is a map between two graphs that preserves the structure of vertices, edges, and legs.

There is a terminal object in the category $Gamma((g,n))$, which is the empty graph $*_(g,n)$, with no edges, one vertex of genus $g$ and $n$ legs.

= Feynman Rule Revisited

Now we can reformulate the Feynman rule using the language of category theory for $sMod_(bb(S))$ and $Gamma((g,n))$.

In the context of category theory, a Feynman rule can be described as given:
- An object $V$ in $sMod_(bb(S))$.
- An (isomorphism class) of object $[Gamma(g, n)]$ in $Gamma((g,n))$.
Summing over all possible (isomorphism classes) of graphs $[Gamma(g, n)]$, we obtain a $sMod_(bb(S))$ endofunctor, denoted by $bb(M)$:
$
  bb(M) V(g,n) tilde.equiv plus.big_(Gamma in [Gamma(g, n)]) V(Gamma)_(Aut(Gamma)) := plus.big_(Gamma in [Gamma(g, n)]) V(g,n)_(Aut(Gamma)),
$
where $V_(G)$ is the coinvariant space of a $G$-module $V$.

Since it is an endofunctor on $Mod_(bb(S))$, we can also consider the relation between $bb(M)^(2) V(g,n)$ and $bb(M) V(g,n)$.
Moreover, we can consider $bb(M)^(k) V(g,n)$ for any positive integer $k$.
By definition, such composition corresponds to:
- At the level of graphs,
  - Consider a Feynman diagram.
  - For each vertex in the diagram, we replace it with another Feynman diagram.
- At the level of vector spaces,
  - For each vertex, assigning a vector space $bb(M)^(k-1)V(Gamma)$ to it.
  - Obtaining a new vector space by applying the Feynman rule again.
Thus, there is a natural transformation $mu: bb(M)^(2)V -> bb(M) V$, called the multiplication of the endofunctor $bb(M)$, which corresponding to the operation of
- Substituting diagrams into vertices.
- Flattening into a single diagram.
- Using the Feynman rule to obtain a vector space.

Consider $bb(M)^(3)V$, since there are two ways to flatten the diagrams:
- First flatten the diagrams at the lowest level, then flatten the resulting diagrams.
- First flatten the diagrams at the highest level, then flatten the resulting diagrams.
And both ways should yield the same result after applying the Feynman rule, such a transformation satisfies the associativity condition.

Moreover, there is a unit transformation $eta: id -> bb(M)$, where $id$ is the identity endofunctor on $sMod_(bb(S))$, which corresponds to the inclusion of the empty graph $*_(g,n)$ in $Gamma((g,n))$.

Thus, the endofunctor $bb(M)$, together with the natural transformations $mu$ and $eta$, forms a *monad* on the category $sMod_(bb(S))$.
Which states that, the Feynman rule can be captured using the language of monad.

= Modular Operad

Remember the definition of a (cyclic) operad, which is just a algebra over a certain monad corresponding to trees.

After we have defined the monad $bb(M)$, we can also consider its algebras.
Since this monad is defined using graphs with genus, its algebras would become a generalization of operad, called *modular operad*.

To be precise, a modular operad $cal(A)$ is an algebra over the monad $bb(M)$, which equipped with a structure map $rho: bb(M)cal(A) -> cal(A)$ satisfying:
- Associativity: $rho dot mu_(cal(A)) = rho dot bb(M)(rho)$.
- Unit: $rho dot eta_(cal(A)) = id_(cal(A))$.

We would denote a modular operad as a pair $(cal(A), rho)$.

= Multiplication Functor and Renormalization

After defining Feynman rules with monads, we can consider some other important procedures in quantum field theory, which is crucial in perturbative QFT, such as *renormalization*.

== Idea

Roughly speaking, Wilson's renormalization group (RG) approach suggests that, to obtain the effective theory at a lower energy scale, we need to:
+ Integrating out the high-energy modes, which let the original interaction terms "shrink" into effective interaction terms.
+ Rescaling the fields and coupling constants accordingly.
+ Only the relevant and marginal interaction terms survive at low energy.

Thus, the multiplication functor $mu$ describes the first step of the RG procedure.

== (Co)bar Construction

Given a modular operad $cal(A)$ constructed from monad $bb(M)$, the renormalization procedure described above could be naturally captured by:
$
  bb(M) cal(A) ->^rho cal(A),
$
where $rho$ is the structure map of the modular operad $cal(A)$.

Consider we apply the multiplication functor $bb(M)$ again, which corresponds to integrating out more high-energy modes.
After repeating the procedure, we obtain a sequence of maps:
#diagram-frame(edge => [$
    #diagram(
      node((0, 0), $dots.c$),
      node((1, 0), $bb(M)^(2) A$),
      node((2, 0), $bb(M) A$),
      node((3, 0), $A,$),

      edge((0, 0), (1, 0), "->", shift: -5pt),
      edge((0, 0), (1, 0), "->", shift: 0pt),
      edge((0, 0), (1, 0), "->", shift: 5pt),

      edge((1, 0), (2, 0), "->", shift: -3pt, label: $mu dot id_cal(A)$, label-side: left),
      edge((1, 0), (2, 0), "->", shift: 3pt, label: $bb(M) dot rho$, label-side: right),

      edge((2, 0), (3, 0), "->", label: $rho$),
    )
  $])
which is a simplicial object in the category of $sMod_(bb(S))$, forming a *bar construction* of the modular operad $cal(A)$.
