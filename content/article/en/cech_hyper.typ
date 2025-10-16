#import "../../../typ/templates/blog.typ": *
#import "../../../typ/packages/typst-fletcher.typ": *
#import "../../../typ/packages/physica.typ": *
#let title = "Čech-de Rham Complex as a Model of Derived Global Section"
#show: main.with(
  title: title,
  desc: [We use the tools of derived functor and sheaf cohomology to understand Čech-de Rham complex we introduced in the previous blog, which is a model of the derived global section of Deligne complex.],
  date: "2025-10-15",
  tags: (
    blog-tags.math,
    blog-tags.physics,
    blog-tags.topology,
    blog-tags.abstract-nonsense,
  ),
  lang: "en",
  translationKey: "cech_hyper",
)
#let target = get-target()

#let u1_grav = "../u1_grav/"
#let check(it) = math.attach(it, t: math.arrowhead.b)
#let tot = math.upright("Tot")
#let cech = math.upright("Čech")
#let Cech = "Čech"
#let Hom = math.upright("Hom")
#let Ext = math.upright("Ext")
#let Tor = math.upright("Tor")

In the #link("../u1_grav/")[previous blog], we introduced Čech-de Rham complex to compute the anomalous $U(1)$ charge of $b c$ CFT.
A (wild) intuition we learned from classical BV formalism is that, the derived object could be obtained by add some additional degree (anti-fields) to the original object, which possibly could be interpreted as some kind of _resolution_ or _derived object_ of the original object.

The same idea also applies to the Čech-de Rham complex we introduced in the #link(u1_grav)[previous blog], which introduced an additional degree (the Čech degree) to the original de Rham complex.

So, it is natural to ask the following questions:
- First, could we using the derived functor to understand the Čech-de Rham complex we introduced in the previous blog?
- Second, could we use BV formalism of $b c$ CFT to capture the non-trivial topological information we discussed in the previous blog?
In this blog, we will consider the first question.

= A Crash Course of Derived (Something)

Instead of giving a full introduction of derived functor, we will only give a brief review of the concepts we will use in this blog.
For a full introduction, try _Methods of Homological Algebra_ by Gelfand and Manin.


== Derived Category

Given an Abelian category $cal(A)$, we can formulate its derived category $D(cal(A))$ by:
- Replacing "bad" objects into some "good" objects.
- Replacing "bad" morphisms into "good" morphisms.
So, the question is, what are "good" objects and "good" morphisms?

There are some examples from Gelfand and Manin's book:
- Naive tensor product is "bad" (only right-exact, not exact), we need to correctly define it by using _flat resolution_, i.e., given $X, Y in cal(A)$, the "good" tensor product should be defined as:
  $
    X times.circle^(L)Y := P^(bullet) times.circle Y,
  $
  where $P^(bullet)$ is a flat resolution of $X$.
  By definition of flat resolution, the functor $- times.circle Y$ is exact on $P^(bullet)$, thus the derived tensor product (which could be identified with $Tor_(i)(-,-)$ after taking homology) is "good".
  Namely, given a short exact sequence $0 -> A -> B -> C ->0$, the sequence:
  $
    ... -> Tor_(i)(X, A) -> Tor_(i)(X, B) -> Tor_(i)(X, C) -> ...
  $
  is exact.
- Naive Hom functor is "bad" (only left-exact, not exact), we need to correctly define it by using _injective resolution_, i.e., given $X, Y in cal(A)$, the "good" Hom functor should be defined as:
  $
    R Hom(X, Y) := Hom(X, I^(bullet)),
  $
  where $I^(bullet)$ is an injective resolution of $Y$.
  By definition of injective resolution, the functor $Hom(X, -)$ is exact on $I^(bullet)$, thus the derived Hom functor (which could be identified with $Ext^(i)(-,-)$ after taking cohomology) is "good".
  Namely, given a short exact sequence $0 -> A -> B -> C ->0$, the sequence:
  $
    ... -> Ext^(i)(X, Y) -> Ext^(i+1)(X, Y) -> ...
  $
  is exact.

The lesson above is, to define some good functors, we need to replace the original objects by some "good" objects (flat or injective resolution).
Which hints to identify the object with the other objects which are quasi-isomorphic to it.

However, unlike the category of chain complexes $"Ch"(cal(A))$, which identifies two objects if they are chain homotopic, it is quit hard to obtain an "inverse" map of a quasi-isomorphism.
Using a technique called _localization of category_, we can formally invert all quasi-isomorphisms in $"Ch"^(bullet)(cal(A))$ and obtain the derived category $D(cal(A))$.
Thus, we found a first property of derived category:
- There exists a functor:
  $
    Q: "Ch"^(bullet)(cal(A)) -> D(cal(A)),
  $
  while $f$ is a quasi-isomorphism in $"Ch"(cal(A))$, $Q(f)$ is an isomorphism in $D(cal(A))$.
Such a functor is universal, i.e., given any functor $F: "Ch"(cal(A)) -> cal(B)$ which sends quasi-isomorphisms to isomorphisms, there exists a unique functor $F': D(cal(A)) -> cal(B)$ such that $F = F' o Q$.

Now we back to the question of finding "good" morphism.
In the (co)homology level, the exact sequence is a "good" object.
If one want to find such a "good" object in the chain complex level, one would find _distinguished triangle_, whose definition is:
$
  A -> B -> C -> A[1].
$
While acting some "good" functors on a distinguished triangle, the image is still a distinguished triangle.
Moreover, if one take (co)homology of a distinguished triangle, one would obtain a (long) exact sequence, which return to the original discussion at (co)homology level (for a proof of this fact, check #link("https://mathoverflow.net/questions/257495/what-is-a-triangle")[here]).
Thus, the morphism which preserves distinguished triangle is a "good" morphism.

For example, the derived $Hom$ functor $R Hom(-, -)$ preserves distinguished triangle.

== Derived Global Section

Now we consider an important example of derived functor, which is the _derived global section_ $R^(bullet) Gamma(X, -)$ of the global section functor $Gamma(X, -)$, which would be used in the following discussion.

The original global section functor $Gamma(X, -)$ is a typically "bad" functor, which is left-exact but not exact.
To define its derived functor, we need to replace the original sheaf by its injective resolution.
Note that the injective resolution is $Gamma$-acyclic, the derived global section could be simply defined as:
$
  R Gamma(X, cal(F)) := Gamma(X, cal(I)^(bullet)),
$
which is exact and return to the original global section functor when taking $0$-th cohomology.

== Some Remarks on Resolution

In the main text, we claim that derived functors "restore" the exactness lost by their naive counterparts.
This property is not an axiom but a direct consequence of a powerful mechanism in homological algebra.

The choice of resolution (injective vs. projective/flat) is precisely tailored to the type of functor we want to correct. Here, we present the general argument for why this machinery works.

The key is that, the injective/flat(projective) resolution would restore the exactness lost by left/right-exact functors.

#custom-block(
  [
    Let $F: cal(A) -> cal(B)$ be a _left-exact functor_. Given a short exact sequence $0 -> A -> B -> C -> 0$, we know applying $F$ yields a sequence $0 -> F(A) -> F(B) -> F(C)$ which is exact but may fail to be exact at $F(C)$. The right derived functors $R^i F$ are designed to measure and correct this failure.

    The cornerstone is the #link("https://en.wikipedia.org/wiki/Horseshoe_lemma")[Horseshoe Lemma], which allows us to lift the entire short exact sequence to the level of resolutions.
    We can find _injective resolutions_ $cal(I)_A^(bullet)$, $cal(I)_B^(bullet)$, and $cal(I)_C^(bullet)$ for $A$, $B$, and $C$ that fit together into a _short exact sequence of cochain complexes_:
    $
      0 -> cal(I)_A^(bullet) -> cal(I)_B^(bullet) -> cal(I)_C^(bullet) -> 0.
    $
    Because each $cal(I)^n$ is injective, this sequence is not just exact, but _split exact_ in every degree.

    We now apply our left-exact functor $F$ to this sequence of complexes. Since any additive functor preserves split exact sequences, $F$ carries the sequence of resolutions to a new _short exact sequence of cochain complexes_:
    $
      0 -> F(cal(I)_A^(bullet)) -> F(cal(I)_B^(bullet)) -> F(cal(I)_C^(bullet)) -> 0.
    $
    i.e., the injective property of the resolutions ensures that the structure is perfectly preserved by the functor.

    The fundamental lemma of homological algebra (#link("https://en.wikipedia.org/wiki/Zig-zag_lemma")[zig-zag lemma]) states that any short exact sequence of cochain complexes gives rise to a _long exact sequence in cohomology_.
    Applying this theorem to the resulting sequence yields:
    $
      ... -> H^i (F(cal(I)_A^(bullet))) -> H^i (F(cal(I)_B^(bullet))) -> H^i (F(cal(I)_C^(bullet))) -> H^(i+1) (F(cal(I)_A^(bullet))) -> ...
    $
    By the very definition of right derived functors, we have $R^i F(X) := H^i(F(cal(I)_X^(bullet)))$.
    Substituting this in, we obtain the canonical long exact sequence for the derived functors of $F$.
    This demonstrates how injective resolutions systematically generate the structure needed to repair any left-exact functor.
  ],
  title: "Injective Resolutions for Left-Exact Functors",
  collapsible: true,
  collapsed: true,
)

#custom-block(
  [
    The argument for right-exact functors is perfectly dual. Let $F: cal(A) -> cal(B)$ be a _right-exact functor_. Given $0 -> A -> B -> C -> 0$, the sequence $F(A) -> F(B) -> F(C) -> 0$ is exact, but may fail at $F(A)$. The left derived functors $L_i F$ correct this.

    We use the dual Horseshoe Lemma to find _projective resolutions_ $cal(P)_A^(bullet)$, $cal(P)_B^(bullet)$, and $cal(P)_C^(bullet)$ that fit into a _short exact sequence of chain complexes_:
    $
      0 -> cal(P)_A^(bullet) -> cal(P)_B^(bullet) -> cal(P)_C^(bullet) -> 0
    $
    Because each $cal(P)_n$ is projective, this sequence is _split exact_ in every degree. (For many right-exact functors like the tensor product, using the broader class of _flat resolutions_ is sufficient and often more convenient).

    An additive functor preserves split exact sequences. Applying $F$ yields another _short exact sequence of chain complexes_:
    $
      0 -> F(cal(P)_A^(bullet)) -> F(cal(P)_B^(bullet)) -> F(cal(P)_C^(bullet)) -> 0
    $

    The homological version of the long exact sequence theorem gives a _long exact sequence in homology_:
    $
      ... -> H_i (F(cal(P)_A^(bullet))) -> H_i (F(cal(P)_B^(bullet))) -> H_i (F(cal(P)_C^(bullet))) -> H_(i-1) (F(cal(P)_A^(bullet))) -> ...
    $
    By definition, $L_i F(X) := H_i (F(cal(P)_X^(bullet)))$, so this is precisely the long exact sequence for the left derived functors of $F$.
    This is the universal mechanism by which projective/flat resolutions repair right-exact functors.
  ],
  title: "General Argument: Projective/Flat Resolutions for Right-Exact Functors",
  collapsed: true,
  collapsible: true,
)

= Čech Complex of Sheaves of Complex

In this section, we will review the construction of Čech complex of sheaves of bounded below complex, following the treatment in #link("https://stacks.math.columbia.edu/tag/01FP")[stack project].

Consider a ringed space $(X, cal(O)_(X))$ with a bounded blow complex of presheaves of Abelian groups $cal(K)^(bullet)$.

#remark(
  [
    In the case of #link("../u1_grav")[previous blog], $X$ is a Riemann surface, $cal(O)_(X)$ is the sheaf of smooth functions and $cal(K)^(bullet)$ is the complex of sheaves of differential forms $Omega^(bullet)$ which replaced the degree $-1$ part by the sheaf of circle group ($U(1)$)-valued smooth functions $underline(U(1)) := C^(oo)(-, U(1))$:
    $
      cal(K)^(bullet) := [... -> 0 -> C^(oo)(-, U(1)) ->^(d log) Omega^(1) ->^(d) Omega^(2) -> ... ->^(d) Omega^(n) -> 0 -> ...],
    $
    which is also called the #link("https://ncatlab.org/nlab/show/Deligne+cohomology#TheSmoothDeligneComplex")[_Deligne complex_].

    To be more precise, what we really considered in the previous blog is the complex induced by the short exact sequence:
    $
      0 -> ZZ arrow.hook RR arrow.long^(exp(2pi i-)) U(1) -> 0,
    $
    which is weak equivalent to the complex defined above.
    In the derived category, they are isomorphic.
  ],
)

We can compute the cohomology $H^(n)(X, cal(K)^(bullet))$ using Čech cocycles.
Namely, we consider an open cover $cal(U) = {U_i}_{i in I}$ of $X$ and form a Čech complex
$
  cal(C)^(bullet)_(upright("Čech"))(cal(U), cal(K)^(bullet)),
$
which is a double complex.
The associated total complex to it is the complex with degree $n$ part:
$
  "Tot"^(n) (cal(C)^(bullet)_(upright("Čech"))(cal(U), cal(K)^(bullet))) := plus.big_(p + q = n) product_(i_0, ..., i_(p)) cal(K)^(q)(U_(i_0,...,i_(p))),
$
where we denote $U_(i_(0), ..., i_(p)) := U_(i_0) inter ... inter U_(i_p)$ and assign the degree of $p$ intersections be $p-1$.
Consider an element $alpha$ living in $cal(K)^(q)(U_(i_0,...,i_(p)))$, where $n = p + q$, the differential on the total complex is given by:
$
  d(alpha)_(i_0,...,i_(p+1)) = sum_(j=0)^(p+1) (-1)^j alpha_(i_0,..., hat(i)_(j),...,i_(p+1)) + (-1)^(p+1) d_(cal(K))(alpha)_(i_0,...,i_(p)),
$
where $d_(cal(K))$ is the differential of the complex of sheaves $cal(K)^(bullet)$, and the expression $alpha_(i_0, ..., hat(i)_(j),...,i_(p+1))$ means the restriction of $alpha_(i_0,...,hat(i)_(j)...,i_(p))$ to $U_(i_0,...,i_(p+1))$.
Thus, the total complex could be defined as:
$
  upright("Tot")(cal(C)_("Čech")^(bullet)(cal(U), cal(K)^(bullet))) := (plus.big_(n) "Tot"^(n)(cal(C)_("Čech")^(bullet)(cal(U), cal(K)^(bullet))), d),
$
where $d$ and $"Tot"^(n)$ is defined as above.

#claim(
  [
    - The construction of $"Tot"(cal(C)^(bullet)_("Čech")(cal(U), cal(K)^(bullet)))$ is _functorial_ in $cal(K)^(bullet)$.
    - The transformation: $ Gamma(X, cal(K)^(bullet)) -> "Tot"(cal(C)^(bullet)_("Čech")(cal(U), cal(K)^(bullet))), $ of complexes defined by sending a global section $s in Gamma(X, cal(K)^(n))$ to an element $alpha$, where $alpha_(i_0) = s|_(U_(i_0))$ and $alpha_(i_0,...,i_(p)) = 0$ for $p >= 1$, is _functorial_.
  ],
)

= Čech Complex as a Model of Derived Global Section

Now it's time to reveal the structure behind the construction of Čech-de Rham complex.
The claim is, the Čech-de Rham complex is a _model_ of the derived global section $R^(bullet) Gamma(X, cal(K)^(bullet))$ of the complex of sheaves $cal(K)^(bullet)$.
Here, "model" means the cohomology of the Čech-de Rham complex is isomorphic to $R^(bullet) Gamma(X, cal(K)^(bullet))$.

Before rushing to this claim, we firstly consider a more general situation, which would be true for any bounded below complex of sheaves of Abelian groups $cal(K)^(bullet)$ on a topological space $X$ (not necessarily Čech-de Rham).

#theorem(
  [(See #link("https://stacks.math.columbia.edu/tag/08BN")[Stack Project]) Let $(X, cal(O)_(X))$ be a ringed space.
    Let $cal(U): X = union.big_(i in I) U_(i)$ be an open cover of $X$.
    For a bounded below complex $cal(K)^(bullet)$ of $cal(O)_(X)$-modules, there is a canonical map:
    $
      "Tot"(cal(C)^(bullet)_(upright("Čech"))(cal(U), cal(K)^(bullet))) -> R Gamma(X, cal(K)^(bullet)),
    $
    which is:
    - Functorial on $cal(K)^(bullet)$.
    - Compatible with functorial map $Gamma(X, cal(K)^(bullet)) -> "Tot"(cal(C)^(bullet)_(upright("Čech"))(cal(U), cal(K)^(bullet)))$ defined previously,
    - Compatible with refinement of open cover.
  ],
)

The idea of the proof is to find a _injective sheaves_ $cal(I)^(bullet)$ which is quasi-isomorphic to $cal(K)^(bullet)$,
$
  cal(K)^(bullet) -> cal(I)^(bullet),
$
then the derived section would be descended to the global section of $cal(I)^(bullet)$.
$
  R Gamma(X, cal(K)^(bullet)) = Gamma(X, cal(I)^(bullet)).
$
Thus, the map could be simply constructed by "descending" the lowest Čech degree part of the Čech complex to the global section, which is simply the augmentation map of the Čech complex.

As a conclusion, the map we want to construct is the composition of two maps:
$
  "Tot"(cal(C)_("Čech")^(bullet)(cal(U), cal(K)^(bullet))) -> "Tot"(cal(C)^(bullet)_(upright("Čech"))(cal(U), cal(I)^(bullet))) -> Gamma(X, cal(I)^(bullet)).
$
which is easy to expect to be functorial and compatible with the functorial map defined previously.

#proof(
  [
    (We follow the proof in #link("https://stacks.math.columbia.edu/tag/08BN")[Stack Project].)


    *Step 1*:
    Let $cal(I)^(bullet)$ be a bounded below complex of injective sheaves with a quasi-isomorphism $cal(K)^(bullet) -> cal(I)^(bullet)$.
    By definition of derived functor, we have:
    $
      R Gamma(X, cal(K)^(bullet)) = Gamma(X, cal(I)^(bullet)).
    $
    *Step 2*:
    We apply the Čech complex construction to $cal(I)^(bullet)$ and $cal(K)^(bullet)$ respectively, and get a map of double complexes:
    $
      cal(C)^(bullet)_(upright("Čech"))(cal(U), cal(K)^(bullet)) -> cal(C)^(bullet)_(upright("Čech"))(cal(U), cal(I)^(bullet)).
    $
    Since the construction of Čech complex is term-wise and exact on each open set, i.e., the map above induced a map of complexes:
    $
      "Tot"(cal(C)^(bullet)_(upright("Čech"))(cal(U), cal(K)^(bullet))) -> "Tot"(cal(C)^(bullet)_(upright("Čech"))(cal(U), cal(I)^(bullet))),
    $
    which is quasi-isomorphism.

    *Step 3*:
    Now we only need to construct a map:
    $
      "Tot"(cal(C)^(bullet)_(upright("Čech"))(cal(U), cal(I)^(bullet))) -> Gamma(X, cal(I)^(bullet)).
    $
    // TODO: define augmentation map in previous blog
    Such a map could be constructed by an augmentation of the double complex $cal(C)^(bullet)_(upright("Čech"))(cal(U), cal(I)^(bullet))$, which sends an element $alpha in cal(I)^(q)(U_(i_0,...,i_(p)))$ to:
    - $0$ if $p >= 1$.
    - $alpha in Gamma(X, cal(I)^(bullet))$ if $p = 0$.
    Such a map is a chain map, thus we get the desired map.
  ],
)

The remain part is to show the functoriality and compatibility of the map constructed above.
Namely, we need to show:
- Functoriality: the following diagram commutes in the derived category:
  #diagram-frame(
    edge => [$
        #align(center, diagram(
          cell-size: (1mm, 1mm),
          $edge("d", "Tot"(cal(C)_("Čech")^(bullet), f), ->) "Tot"(cal(C)^(bullet)_("Čech") (cal(U), cal(F)^(bullet))) edge(->) & R Gamma(X, cal(F)^(bullet)) edge("d", R Gamma(f), ->) \
          "Tot"(cal(C)^(bullet)_("Čech") (cal(U), cal(K)^(bullet))) edge(->) & R Gamma(X, cal(K)^(bullet)).\ $,
        ))\
        quad
      $],
  )

#proof(
  [
    Consider a Abelian category $cal(A)$, the derived category is $D(cal(A))$.
    Given a topological space $X$, we consider a sheaf of chain morphism $f: cal(F)^(bullet) -> cal(K)^(bullet)$.
    The functoriality of such map is equavalent to the commutativity of the following diagram:
    #diagram-frame(
      edge => [$
          #align(center, diagram(
            cell-size: (1mm, 1mm),
            $edge("d", "Tot"(cal(C)_("Čech")^(bullet), f), ->) "Tot"(cal(C)^(bullet)_("Čech") (cal(U), cal(F)^(bullet))) edge(->) & R Gamma(X, cal(F)^(bullet)) edge("d", R Gamma(f), ->) \
            "Tot"(cal(C)^(bullet)_("Čech") (cal(U), cal(K)^(bullet))) edge(->) & R Gamma(X, cal(K)^(bullet)).\ $,
          ))\
          quad
        $],
    )
    A standard method to prove this commutativity is to consider the complex of injective sheaf with quasi-isomorphism:
    $
      phi.alt_(F): cal(F)^(bullet) -> cal(I)^(bullet)_(F), quad phi.alt_(K): cal(K)^(bullet) -> cal(I)^(bullet)_(K),
    $
    thus, the diagram above could be expanded to:
    #diagram-frame(
      edge => [$
          #align(center, diagram(
            cell-size: (1mm, 1mm),
            $edge("d", "Tot"(cal(C)_("Čech")^(bullet), f), ->) "Tot"(cal(C)^(bullet)_("Čech") (cal(U), cal(F)^(bullet))) edge(->) & "Tot"(cal(C)^(bullet)_( "Čech")(cal(U), cal(I)^(bullet)_(F))) edge(->) edge("d", "Tot"(cal(C)_("Čech")^(bullet), f'), ->) & Gamma(X, cal(I)_(F)^(bullet)) edge("d", Gamma(f'), ->) \
            "Tot"(cal(C)^(bullet)_("Čech") (cal(U), cal(K)^(bullet))) edge(->) & "Tot"(cal(C)^(bullet)_( "Čech")(cal(U), cal(I)^(bullet)_(K))) edge(->) & Gamma(X, cal(I)_(K)^(bullet)),\ $,
          ))\
          quad
        $],
    )
    where we used the lifting property of injective sheaves to obtain a chain map $f$, which is unique up to homotopy and defined with the following commutative diagram:
    #diagram-frame(
      edge => [$
          #align(center, diagram(
            cell-size: (1mm, 1mm),
            $ edge("d", ->) cal(F)^(bullet) edge(f, ->) & cal(K)^(bullet) edge("d", ->) \
                     cal(I)^(bullet)_(F) edge(f', ->) & cal(I)^(bullet)_(K). \ $,
          ))\
          quad
        $],
    )
    Now, the proof of the commutativity could be decomposed into the commutativity of each small square in the diagram above.

    *Left Square*:
    Since the construction of Čech complex is functorial, the left square commutes (up to homotopic equivalence, which is, in derived category, equivalence).

    *Right Square*:
    Since the augmentation map is functorial, the right square commutes strictly.
  ],
  title: "Proof of Functoriality",
)

- Compatibility: the following diagrams commute:
  #diagram-frame(
    edge => [$
        #align(center, diagram(
          cell-size: (1mm, 1mm),
          $edge("dr", ->) Gamma(X, cal(K)^(bullet)) edge(->) & R Gamma(X, cal(K)^(bullet)) \
          & "Tot"(cal(C)^(bullet)_("Čech") (cal(U), cal(K)^(bullet))) edge("u", ->), quad \ $,
        ))
        #align(center, diagram(
          cell-size: (1mm, 1mm),
          $edge("dr", ->) "Tot"(cal(C)^(bullet)_("Čech") (cal(U), cal(K)^(bullet))) edge(->) & R Gamma(X, cal(K)^(bullet)) \
          & "Tot"(cal(C)^(bullet)_("Čech") (cal(V), cal(K)^(bullet))) edge("u", ->),\ $,
        ))\
        quad
      $
    ],
  )
  which are the compatibility with global section and refinement of open cover respectively.

#proof(
  [
    *Compatibility with Global Section*:
    The compatibility could be written as the commutativity of the following diagram:
    #diagram-frame(
      edge => [$
          #align(center, diagram(
            cell-size: (1mm, 1mm),
            $edge("dr", ->) Gamma(X, cal(K)^(bullet)) edge(->) & R Gamma(X, cal(K)^(bullet)) \
            & "Tot"(cal(C)^(bullet)_("Čech") (cal(U), cal(K)^(bullet))) edge("u", ->).\ $,
          ))\
          quad
        $
      ],
    )
    Given a injective sheaf $cal(I)_(K)^(bullet)$, the diagram above could be rephrased as:
    #diagram-frame(
      edge => [$
          #align(center, diagram(
            cell-size: (1mm, 1mm),
            $edge("dr", ->) Gamma(X, cal(K)^(bullet)) edge(->) & Gamma(X, cal(I)_(K)^(bullet)) \
            & "Tot"(cal(C)^(bullet)_("Čech") (cal(U), cal(K)^(bullet))) edge("u", ->).\ $,
          ))\
          quad
        $
      ],
    )
    We can chase an element $s in Gamma(X, cal(K)^(n))$ in the diagram above.
    On the lower path, we have:
    $
      s |-> { alpha_(i_0) = s|_(U_(i_0)), alpha_(i_0,...,i_(p)) = 0, p >= 1 } |-> { alpha_(i_0) = phi.alt_(K)(s|_(U_(i_0))), alpha_(i_0,...,i_(p)) = 0, p >= 1 } -> {phi_(K)(s|_(U_(i_0)))}.
    $
    where $phi.alt_(K): cal(K)^(bullet) -> cal(I)_(K)^(bullet)$ is the quasi-isomorphism defined previously.
    The sheave morphism should be commute with augmentation map, i.e., $phi.alt_(K)(s|_(U_(i_0))) = phi_(K)(s)|_(U_(i_0))$, which implies the upper path and lower path are the same.

    *Compatibility with Refinement*:
    Consider two open covers $cal(U) = {U_i}_I$ and $cal(V) = {V_i}_J$ of $X$, where $cal(V)$ is a refinement of $cal(U)$.
    Given a injection $cal(K)^(bullet) -> cal(I)_(K)^(bullet)$, the compatibility could be written as the commutativity of the following diagram:
    #diagram-frame(edge => [$
        #align(center, diagram(
          cell-size: (1mm, 1mm),
          $edge("dr", ->) "Tot"(cal(C)^(bullet)_("Čech") (cal(U), cal(K)^(bullet))) edge(->) & Gamma(X, cal(I)^(bullet)) \
          & "Tot"(cal(C)^(bullet)_("Čech") (cal(V), cal(K)^(bullet))) edge("u", ->),\ $,
        ))\
        quad
      $
    ])
    with the same augmentation above, the commutativity is obvious.

  ],
  title: "Proof of Compatibility",
)

A usual way to construct an injective resolution is to use #link("https://en.wikipedia.org/wiki/Cartan%E2%80%93Eilenberg_resolution")[Cartan-Eilenberg resolution]: $cal(K)^(bullet) -> cal(I)^(bullet, bullet)$, where $cal(K)^(bullet) -> tot(cal(I)^(bullet, bullet))$ is an injective resolution.
Thus, the Čech complex:
$
  tot(cal(C)^(bullet)_cech (cal(U), tot(cal(I)^(bullet, bullet)))),
$
could be used to compute the derived global section $R Gamma(X, cal(K)^(bullet))$, as we discussed above.
Now we consider an associated double complex:
$
  A^(n, m) := plus.big_(p+q = n) cal(C)^(p)_cech (cal(U), cal(I)^(q, m)).
$
The $E_1$ page of the spectral sequence associated to the double complex $A^(n, m)$ is the cohomology of complex $A^(n, bullet)$. Note that $cal(I)^(bullet)$ is an injective resolution, this cohomology is simply the Čech complex $cal(C)^(p)_cech (cal(U), underline(H)^(q)(cal(K)^(bullet)))$.
Thus, the $E_2$ page is the Čech cohomology $H^(p)_(cech)(cal(U), underline(H)^(q)(cal(K)^(bullet)))$.
// TODO: proof the convergence.

Finally, if one could prove that such a spectral sequence converges to the original cohomology, the spectral sequence could be indeed used to compute such cohomology.
The discussion above could be formulated by the theorem below:
#theorem([There is a spectral sequence $(E_(r), d_(r))_(r >0)$ with $E_2$ page:
  $
    E_2^(p,q) = H^(p)(cal(U), underline(H)^(p)(cal(K)^(bullet))),
  $
  which converges to $H^(bullet)(X, cal(K)^(bullet))$.
])
#proof(
  [Check #link("https://stacks.math.columbia.edu/tag/0132")[stacks project]],
  title: "Proof of Convergence",
)

Now we can apply the theorem above to the complex of sheaves
$
  cal(K)^(bullet) := [... -> 0 -> C^(oo)(-, U(1)) ->^(d log) Omega^(1) ->^(d) Omega^(2) -> ... ->^(d) Omega^(n) -> 0 -> ...],
$
Using the Poincaré lemma, we know that, for any contractible open set $U$, the complex $cal(K)^(bullet)(U)$ has cohomology only at degree $0$.
Then, using the spectral sequence above, the map:
$
  tot(cal(C)_(cech)^(bullet)(cal(U), cal(K)^(bullet))) -> R Gamma(X, cal(K)^(bullet)),
$
is indeed an isomorphism!
Thus, we finally showed that, the Čech-de Rham complex we introduced in the previous blog is indeed a model of the derived global section of the complex of sheaves $cal(K)^(bullet)$, i.e., $R Gamma(X, cal(K)^(bullet))$.


// The spectral sequence immediately shows the Čech-de Rham complex is indeed a model of the derived global section of the complex of sheaves $cal(K)^(bullet)$, i.e., $R Gamma(X, cal(K)^(bullet))$.

// Such construction formulated our intuition of using Čech complex to obtain the _global information_ of the complex of sheaves $cal(K)^(bullet)$ from its _local data_, previously discussed in #link(u1_grav)[this blog].
