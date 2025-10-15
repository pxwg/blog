#import "../../../typ/templates/blog.typ": *
#import "../../../typ/packages/typst-fletcher.typ": *
#import "../../../typ/packages/physica.typ": *
#let title = "Čech-de Rham Complex and Hypercohomology"
#show: main.with(
  title: title,
  desc: [We use the tools of derived functor and sheaf cohomology to understand Čech-de Rham complex we introduced in the previous blog, which is a model of the hypercohomology of a (modified) de Rham complex.],
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

#let u1_grav = "../u1_grav/"
#let check(it) = math.attach(it, t: math.arrowhead.b)

In the #link("../u1_grav/")[previous blog], we introduced Čech-de Rham complex to compute the anomalous $U(1)$ charge of $b c$ CFT.
The (wild) intuition we learned from classical BV formalism is that, the derived object could be obtained by add some additional degree (anti-fields) to the original object, which possibly could be interpreted as some kind of _resolution_ or _derived object_ of the original object.

The same idea also applies to the Čech-de Rham complex we introduced in the #link(u1_grav)[previous blog], which introduced an additional degree (the Čech degree) to the original de Rham complex.

So, it is natural to ask the following questions:
- First, could we using the derived functor to understand the Čech-de Rham complex we introduced in the previous blog?
- Second, could we use BV formalism of $b c$ CFT to capture the non-trivial topological information we discussed in the previous blog?
In this blog, we will consider the first question.

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

= Hypercohomology and Deligne Cohomology

// Such construction formulated our intuition of using Čech complex to obtain the _global information_ of the complex of sheaves $cal(K)^(bullet)$ from its _local data_, previously discussed in #link(u1_grav)[this blog].
