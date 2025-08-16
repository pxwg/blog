#import "/typ/templates/blog.typ": *
#show: main.with(
  title: "Typst Syntax",
  desc: [List of Typst Syntax, for rendering tests.],
  date: "2025-08-15",
  tags: (
    blog-tags.programming,
    blog-tags.typst,
  ),
)

= Raw Blocks

This is an inline raw block `class T`.

This is an inline raw block ```js class T```.

This is a long inline raw block ```js class T {}; class T {}; class T {}; class T {}; class T {}; class T {}; class T {}; class T {}; class T {};```.

Js syntax highlight are handled by syntect:

```js
class T {};
```

Typst syntax hightlight are specially handled internally:

```typ
#let f(x) = x;
```

= Equations

This part is the most important part of the syntax test since our blog is heavily math-oriented.
This is a test of inline math: $f(x) = x$. And this is a test of long block math:
$
  upright(d)_(upright(C E))^2 c^alpha
  = & 1 / 2 f_(beta gamma)^alpha [1 / 2 f_(rho lambda)^beta c^rho c^lambda c^gamma - 1 / 2 f_(rho lambda)^gamma c^beta c^rho c^lambda]\
  = & - 1 / 2 f_(gamma beta)^alpha f_(rho lambda)^beta c^rho c^lambda c^lambda\
  = & 1 / 12 f_(beta \[ gamma)^alpha f_(rho lambda \])^beta c^rho c^lambda c^lambda\
  = & 0.
$
There is another test for the equation block from #link("https://github.com/ahxt/academic-homepage-typst/blob/55e76cb813f0096070fdda57dc81e13697af66b2/content/blog/grpo.typ")[academic-homepage-typst: GRPO]
$
  cal(J)_("PPO")(theta) = bb(E)_((q,a)~cal(D))
  [
    min ( (pi_theta(o_t|q, o_(<t))) / (pi_(theta_text("old"))(o_t|q,o_(<t))) hat(A)_t,
      "clip" ( (pi_theta(o_t|q, o_(<t))) / (pi_(theta_text("old"))(o_t|q,o_(<t))), 1 - epsilon, 1 + epsilon ) hat(A)_t ) ]
$
where:
- $r_(i,t)(theta) = (pi_(theta)(o_(i,t) | q, o_(i,<t))) / (pi_(theta_text("old"))(o_(i,t) | q,o_(i,<t)))$ is the importance sampling ratio for the $i$-th response at time step $t$.
- $hat(A)_(i,t)$ is the advantage for the $i$-th response at time step $t$.
