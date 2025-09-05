#import "../../../typ/templates/blog.typ": *
#show: main-zh.with(
  title: "Typst 语法",
  desc: [Typst 语法列表，用于渲染测试。],
  date: "2025-08-14",
  tags: (
    blog-tags.programming,
    blog-tags.typst,
  ),
)

#translation-disclaimer(
  original-path: "syntax",
  lang: "zh",
)

= 原始代码块

这是一个行内原始代码块 `class T`。

这是一个行内原始代码块 ```js class T```。

这是一个长的行内原始代码块 ```js class T {}; class T {}; class T {}; class T {}; class T {}; class T {}; class T {}; class T {}; class T {};```。

Js 语法高亮由 syntect 处理：

```js
class T {};
```
Typst 语法高亮在内部特殊处理：

```typ
#let f(x) = x;
```
= 公式

这部分是语法测试中最重要的部分，因为我们的博客高度数学导向。
这是一个行内数学公式测试：$f(x) = x$。这是一个长的块级数学公式测试：

$
  upright(d)_(upright(C E))^2 c^alpha
  = & 1 / 2 f_(beta gamma)^alpha [1 / 2 f_(rho lambda)^beta c^rho c^lambda c^gamma - 1 / 2 f_(rho lambda)^gamma c^beta c^rho c^lambda]\
  = & - 1 / 2 f_(gamma beta)^alpha f_(rho lambda)^beta c^rho c^lambda c^lambda\
  = & 1 / 12 f_(beta \[ gamma)^alpha f_(rho lambda \])^beta c^rho c^lambda c^lambda\
  = & 0.
$
$
  a^2 + b^2 = & c^2 \
    a^2 b^2 = & c^2 \
$

这是来自 #link("https://github.com/ahxt/academic-homepage-typst/blob/55e76cb813f0096070fdda57dc81e13697af66b2/content/blog/grpo.typ")[academic-homepage-typst: GRPO] 的另一个公式块测试：
$
  cal(J)("PPO")(theta) = bb(E)((q,a)~cal(D))
  [
    min ( (pi_theta(o_t|q, o_(<t))) / (pi_(theta_text("old"))(o_t|q,o_(<t))) hat(A)t,
      "clip" ( (pi_theta(o_t|q, o(<t))) / (pi_(theta_text("old"))(o_t|q,o_(<t))), 1 - epsilon, 1 + epsilon ) hat(A)_t ) ]
$
其中：

$r_(i,t)(theta) = (pi_(theta)(o_(i,t) | q, o_(i,<t))) / (pi_(theta_text("old"))(o_(i,t) | q,o_(i,<t)))$ 是第 $i$ 个响应在时间步 $t$ 的重要性采样比率。

$hat(A)_(i,t)$ 是第 $i$ 个响应在时间步 $t$ 的优势函数。
