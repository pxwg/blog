#import "/typ/templates/blog.typ": *
#show: main.with(
  title: "Typst Syntax",
  desc: [List of Typst Syntax, for rendering tests.],
  date: "2025-05-27",
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

$
  cal(J)_text("PPO")(theta) = bb(E)_((q,a)~cal(D))
  [
    min ( (pi_theta(o_t|q, o_(<t))) / (pi_(theta_text("old"))(o_t|q,o_(<t))) hat(A)_t,
      "clip" ( (pi_theta(o_t|q, o_(<t))) / (pi_(theta_text("old"))(o_t|q,o_(<t))), 1 - epsilon, 1 + epsilon ) hat(A)_t ) ]
$
