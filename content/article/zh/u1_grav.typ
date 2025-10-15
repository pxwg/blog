#import "../../../typ/templates/blog.typ": *
#import "../../../typ/packages/typst-fletcher.typ": *
#import "../../../typ/packages/physica.typ": *
#let title = "混合反常与 Riemann-Roch 定理"
#show: main.with(
  title: title,
  desc: [bc 共形场论中的 U(1)-引力混合反常体现为 Riemann-Roch 定理],
  date: "2025-09-14",
  tags: (
    blog-tags.physics,
    blog-tags.quantum-field,
  ),
  lang: "zh",
  translationKey: "u1_grav",
  llm-translated: true,
)

本博客旨在解释 $b c$ 共形场论 (CFT) 中的 $U(1)$ 对称性与引力之间的 _混合反常_ (mixed anomaly) 如何导出复几何中的 _Riemann-Roch 定理_。在本博客中，我们将只关注主要的 _物理_ 思想，而将严格的数学处理留给未来的文章。

= 引言：球面内的磁单极子
<intro>

考虑一个球面 $bb(S)^(2)$ 内的磁单极子，在整个 $bb(S)^(2)$ 上不存在一个全局良定义的规范联络 $A$。我们需要用一些坐标卡 ${U_(i)}$ 来覆盖 $bb(S)^(2)$，然后在每个坐标卡上定义 $A_(i) in Omega^(1)(U_(i))$（在确定一个参考联络后），并利用转移函数 ${f_(i j)}$ 来获得全局的 $U(1)$ 联络。

对于 $bb(S)^(2)$ 的情况，最简单的坐标卡选择可能是两个半球，这两个坐标卡的交集是一个圆周 $bb(S)^(1)$。因此，可以很容易地证明，该联络可以写为：
$
  A(theta, phi) = cases(
    frac(1, 2) (1-cos theta) dif phi \, theta in (0, pi/2),
    frac(1, 2)(-1 - cos theta) dif phi \, theta in (pi/2, pi)
  ),
$
其中，相关的规范曲率可以写为 $F = frac(1, 2) dif S$，转移函数可以写为 $upright(e)^(i phi): A |-> A + dif phi$。使用上述公式，磁通量可以计算为：
$
  "磁通量" = integral_(bb(S)^(2)) F = integral_(U_(1)) dif A + integral_(U_(2)) dif A = integral_(partial U_(1)) A + integral_(partial U_(2)) A = integral_(bb(S)^(1)) dif phi in ZZ.
$

= bc 共形场论与 U(1) 流

== 局域描述

考虑一个定义在黎曼面 $X$ 上的 $b c$ 共形场论，其共形权重为 $(lambda, 0)$ 和 $(1 - lambda, 0)$：
$
  S = frac(1, 2pi) integral_(X) b overline(diff) c,
$
其中 $b in Gamma(X, L^(times.circle lambda))$，$c in Gamma(X, K times.circle L^(- times.circle lambda))$，$L$ 是一个全纯线丛，$K$ 是 $X$ 上的典范丛。


现在我们考虑这个共形场论在某个坐标卡 $U approx bb(C)$ 上的局域描述，其局域坐标为 $z$。在该坐标下，能量 - 动量张量由下式给出：
$
  T(z) = - lambda :b diff c: + (1-lambda) : diff b c :,
$
而 $U(1)$ 流为：
$
  J(z) = :b c: := lim_(w -> z) b(w) c(z) - frac(dif z, w - z),
$
该流的算符乘积展开 (OPE) 可以写为：
$
  T(z)J(w) = frac(1 - 2 lambda, (z - w)^(3)) dif z + frac(J(w), (z-w)^(2)) + frac(diff_(z) J(w), z- w) + :T(z)J(w):,
$
这意味着当考虑共形变换 $z |-> w$ 时，流会发生如下变化：
$
  J(w) = J'(z) + frac(1-2 lambda, 2) diff (ln diff_(z) w) = J'(z) + frac(1 - 2 lambda, 2) dif (ln diff_(z) w).
$
最后一个等式成立，因为共形变换是 _全纯的_。这个变换公式表明 $J(w)$ 不是一个主场。

从经典力学角度看，这里的守恒量可以朴素地写为 $integral_(Sigma) overline(diff) J dif x =0$。这个方程在 $CC$ 上对于具有紧支撑的 $b c$ 场是成立的。然而，当我们考虑该场论的全局结构时，需要进行更精确的分析。

== 从局域数据粘合坐标卡

当我们将坐标卡粘合成一个一维复流形时，满足 $diff_(z) f(p) != 0$ 的全纯函数 $f$ 将扮演 _转移函数_ 的角色，它实际上就是一个共形变换 $z |-> w$。因此，回顾引言中的讨论，$overline(partial) J$ 在 $X$ 上的积分应该被重新表述为在由某些共形变换粘合的多个坐标卡上的积分之和：
$
  integral_(X) overline(diff) J := sum_(i) integral_(U_(i)) overline(diff) J(z_(i)).
$
这里我们为 $X$ 选择了一个良覆盖 ${U_(i)}$，并在每个坐标卡上赋予局域坐标 ${z_(i)}$。由于 $J(z_(i))$ 是 $U_(i)$ 上的 $(1,0)$ 形式，上述积分可以改写为：
$
  integral_(X) overline(diff) J := sum_(i) integral_(U_(i)) dif J(z_(i)).
$

给定 $X$ 的一个（良）覆盖 $cal(U) := {U_(i)}$，转移函数由 $f_(i j): z_(j) |-> f_(i j)(z_(i))$ 给出，因此两个坐标卡上的流由以下关系联系：
$
  J(z_(j)) = J(z_(i)) + frac(1 - 2 lambda, 2) dif (ln diff_(z_(i)) f_(i j)).
$
至此，我们遇到了与球面内磁单极子相似的情况，这里的流 $J$ 扮演了规范联络 $A$ 的角色，它可能不是全局良定义的。

一种表述引言中思想的方式是，我们首先在每个坐标卡上对 $dif J$ 进行积分，然后通过转移函数将它们加总起来。

// == Čech 复形与第一陈类

我们可以将上述考虑嵌入到 _Čech 复形_ 中，其中 $J(z_(i))$ 是 $C^(0)(cal(U), Omega^(1))$ 中的一个元素，而 $frac(1 - 2 lambda, 2) dif (ln diff_(z_(i)) f_(i j))$ 是 $C^(1)(cal(U), Omega^(1))$ 中的一个元素，这里：
- $C^(bullet)$ 中的第一个上同调次数是坐标卡的交集个数，例如，$U_(i)$ 是 $C^(0)$ 中的元素，$U_(i) inter U_(j)$ 是 $C^(1)$ 中的元素，依此类推。
- $Omega^(bullet)$ 中的第二个上同调次数表示微分形式的阶数，例如，$Omega^(0)$ 是 0 阶形式（函数），$Omega^(1)$ 是 1 阶形式，依此类推 #footnote([$U_(i)$ 上的 $(1,0)$ 形式可以自然地嵌入到 $C^(0)(cal(U), Omega^(1))$ 中，因此我们记作 $J in C^(0)(cal(U), Omega^(1))$.])。
相关的 Čech 微分由以下方式导出：
- $delta: C^(p)(cal(U), Omega^(q)) |-> C^(p+1)(cal(U), Omega^(q))$，其中 $delta: f_(i_1,...,i_(n)) |-> (delta f)_(i_1, ..., i_(n), i_(n+1))$。
- $dif: C^(p)(cal(U), Omega^(q)) -> C^(p)(cal(U), Omega^(q+1))$ 是在坐标卡 $U_(i_1, ..., i_(n))$ 上的标准 _de Rham 微分_。

因此，流 $J$ 的变换可以重述为：
$
  delta J_(i j) = frac(1 - 2 lambda, 2) dif (ln diff_(z_(j)) f_(i j)),
$
可以改写为：

// TODO: better function to draw commutative diagram for html output
#if get-target() == "web" {
  theme-frame(
    tag: "span",
    theme => {
      let edge = edge.with(stroke: theme.main-color)
      let it = [$
          #align(center, diagram(
            cell-size: (1mm, 1mm),
            $J_(i) edge(delta, ->) & delta J_(i j)\
            & edge("u", dif, ->) frac(1-2 lambda, 2) ln diff_(z_(j)) f_(i j),$,
          ))\
          quad
        $]
      set text(fill: theme.main-color, size: math-size, font: math-font)
      span-frame(attrs: (class: "block-equation"), it)
    },
  )
}
其中箭头 $a ->^(delta) b$ 表示 $b = delta a$。此外，由于转移函数满足条件
$
  diff_(z_(j)) f_(i j) diff_(z_(k)) f_(j k) diff_(z_(i)) f_(k i) = 1 := e^(2 i pi n_(i j k)),
$
我们有：

#if get-target() == "web" {
  theme-frame(
    tag: "span",
    theme => {
      let edge = edge.with(stroke: theme.main-color)
      let it = [$
          #align(center, diagram(
            cell-size: (1mm, 1mm),
            $J_(i) edge(delta, ->) & delta J_(i j) \
            & edge("u", dif, ->) frac(1-2 lambda, 2) ln diff_(z_(j)) f_(i j) edge(delta, ->) & (1-2 lambda) i pi n_(i j k) \
            & & edge("u", dif, ->) (1-2 lambda) i pi n edge(delta, ->) & 0,$,
          ))\
          quad
        $]
      set text(fill: theme.main-color, size: math-size, font: math-font)
      span-frame(attrs: (class: "block-equation"), it)
    },
  )
}
其中 $dif$ 的作用相当于一个嵌入 $H^(2)(X, ZZ) arrow.hook Omega^(0)(U_(i j k))$，即对于 $[n] in H^(2)(X, ZZ)$ 有 $dif: n |-> n_(i j k)$。注意到我们的积分是对 $overline(diff) J$ 在 $X$ 上进行的，因此我们需要将 $overline(diff) J = dif J$ 纳入考虑，于是我们有：

#if get-target() == "web" {
  theme-frame(
    tag: "span",
    theme => {
      let edge = edge.with(stroke: theme.main-color)
      let it = [$
          #align(center, diagram(
            cell-size: (1mm, 1mm),
            $0 \
            edge("u", dif, ->) omega edge(delta, ->) & dif J_(i) \
            & edge("u", dif, ->) J_(i) edge(delta, ->) & delta J_(i j) \
            & & edge("u", dif, ->) frac(1-2 lambda, 2) ln diff_(z_(j)) f_(i j) edge(delta, ->) & (1-2 lambda) i pi n_(i j k) \
            & & & edge("u", dif, ->) (1-2 lambda) i pi n edge(delta, ->) & 0,$,
          ))\
          quad
        $]
      set text(fill: theme.main-color, size: math-size, font: math-font)
      span-frame(attrs: (class: "block-equation"), it)
    },
  )
}
其中 $delta$ 是将一个光滑形式限制到坐标卡交集上的操作，即对于 $omega in Omega^(2)(X)$ 有 $delta: omega |-> omega|_(U_(i))$。

利用上图，我们可以将 $overline(diff) J$ 在 $X$ 上不明确的积分，替换为 $dif J_(i)$ 在每个坐标卡 $U_(i)$ 上的良定义积分，进而替换为全局良定义的 2-形式 $omega in Omega^(2)(X)$ 的积分。

此外，上图暗示了 $omega$ 在 $X$ 上的积分会降维为对所有 $U_(i j k)$ 上的 $(1- 2 lambda) i pi n_(i j k)$ 求和。为了看清这一点，我们考虑覆盖 $cal(U)$ 的神经 (nerve of cover)，这是一个从 $cal(U)$ 构造出来的单纯复形。下图是一个覆盖的神经（及其对偶）的例子。

#image_viewer(
  path: "../assets/u1_grav_nerve.png",
  desc: [覆盖的神经及其对偶],
  dark-adapt: true,
  adapt-mode: "invert-no-hue",
)

因此，$omega$ 在 $X$ 上的积分可以：
- 首先，被重述为在边界 $e_(i j)$ 上的积分：
$
  integral_X omega = sum_({e_(i j)}) integral_(e_(i j)) (delta J)_(i j) = sum_({e_(i j)}) integral_(e_(i j)) frac(1 - 2 lambda, 2) dif (ln diff_(z_(j)) f_(i j)),
$
其中 $e_(i j)$ 表示对应于交集 $U_(i) inter U_(j)$ 的边，
- 然后，被重述为在面 $f_(i j k)$ 上的积分，这其实就是对 $n_(i j k)$ 的求和：
$
  integral_(X) omega = sum_({f_(i j k)}) (1 - 2 lambda) i pi n_(i j k),
$
其中 $f_(i j k)$ 表示对应于交集 $U_(i) inter U_(j) inter U_(k)$ 的面。
- 最后，被重述为 $n$ 在 $X$ 上的‘积分’，即 $H^(2)(X, ZZ)$ 中的 $[n]$ 与 $H_(2)(X, ZZ)$ 中的基本类 $[X]$ 的配对：
$
  integral_(X) omega = (1 - 2 lambda) i pi angle.l [n], [X] angle.r,
$
根据 #link("https://en.wikipedia.org/wiki/Chern_class")[定义]，这恰好是线丛 $L$ 的第一陈类 $c_(1)(L) in H^(2)(X, ZZ)$ 乘以 $(1 - 2 lambda) i pi$。

_Remark_：这种降维方法被称为 _zig-zag_ 技巧，它将一个微分形式的积分降维为对覆盖的神经中的单纯形求和 (End of the Remark)

因此，$overline(diff) J$（实际上是 $omega$）在黎曼面 $X$ 上的积分给出：
$
  integral_(X) overline(diff) J := integral_(X) omega = (1 - 2 lambda) pi i c_(1)(L),
$
其中 $c_(1)(L) in H^(2)(X, ZZ)$ 是线丛 $L$ 的第一陈类。

= 零模、Riemann-Roch 与指标

== 零模与指标

$b c$ 共形场论的零模方程可以写为：
$
  overline(diff) c = 0, quad overline(diff) b = 0.
$
我们分别用 $B$ 和 $C$ 表示 $b, c$ 场的零模个数。不难发现 $C = ker(overline(diff)_(K times.circle L^(-lambda)))$ 且 $B = ker(overline(diff)_(L^(lambda)))$，因此零模数之差为：
$
  C - B = dim(H^(0)(X, cal(O)(K times.circle L^(-lambda)))) - dim(H^(0)(X, cal(O)(L^(lambda)))),
$
利用 Serre 对偶 $H^(i)(X, cal(O)(K times.circle L^(-lambda))) approx H^(n-i)(X, cal(O)(L^(lambda)))^(or)$，我们得到（在我们的情况下，$n=1$）：
$
  C - B = dim(H^(1)(X, cal(O)(L^(lambda)))) - dim(H^(0)(X, cal(O)(L^(lambda)))) := h^(1)(X, cal(O)(L^(lambda))) - h^(0)(X, cal(O)(L^(lambda))),
$
因此椭圆算子 $overline(diff)$ 的指标可以重述为：
$
  "ind"(overline(diff)) = h^(0)(X, cal(O)(L^(lambda))) - h^(1)(X, cal(O)(L^(lambda))),
$

此外，众所周知，零模数之差可以重述为 $U(1)$ 诺特流的荷，它由（量子层面的）$U(1)$ 生成元给出：
$
  Q := frac(1, 2 pi i)integral_(X) overline(diff) J(z) = frac(1, 2 pi i) integral.cont :b(z) c(z):,
$
我们可以使用路径积分来计算这个荷，我们有：
$
  angle.l Q angle.r = frac(1, Z) integral d mu thin Q e^(-S[b,c]),
$
其中 $d mu$ 是场空间上的形式化的 Berezin 测度，$Z$ 是配分函数。

注意到 $b c$ 场的可能存在的零模不会出现在作用量 $S[b,c]$ 中，因此除非没有零模，否则上述积分恒为零。为了克服这个问题，我们需要在积分中插入一个包含 $B$ 个 $b$ 场和 $C$ 个 $c$ 场的可观测量，即：
$
  angle.l Q angle.r := frac(integral d mu thin Q cal(O)[b,c] e^(-S), integral d mu thin cal(O)[b,c] e^(-S)),
$
我们最终将证明这个积分与 $cal(O)$ 的选择无关，但现在让我们选择一个该算符的简单形式：
$
  cal(O)[b,c] := b(z_1) ... b(z_(B)) c(w_1) ... c(w_(C)),
$
因此，$U(1)$ 荷算符作用在该可观测量上，结果为：
$
  [Q, cal(O)] = (B - C) cal(O),
$
这可以从
$
  [Q, b(z)] = b(z), quad [Q, c(z)] = -c(z),
$
以及对易子的莱布尼兹法则推导出来。

现在我们考虑上述对易子的路径积分形式。为了实现上述对易子，我们需要两个事实：
- 首先，路径积分会导出一个（时间，径向）有序积。
- 其次，$Q$ 的值在积分路径的微小形变下是稳健的（利用柯西积分公式）。
第一个事实表明我们可以将量子期望值实现为：
$
  bra(0)T{[Q, O(z)] ...}ket(0) = angle.l (Q(C_1) - Q(C_2) O(z) ...) angle.r.
$
利用第二个事实，这两个回路可以形变为一个围绕 $O(z)$ 的闭合回路。因此，对易子可以简单地实现为 $Q O$ 的路径积分期望值。

对每个 $b(z_i)$ 和 $c(w_j)$ 使用上述结果，我们最终得到：
$
  angle.l Q angle.r = B - C,
$
这与 $cal(O)$ 的选择无关。因此，我们将椭圆算子 $overline(diff)$ 的指标与 $U(1)$ 荷等同起来：
$
  angle.l Q angle.r = "ind"(overline(diff)).
$

== 混合反常与 Riemann-Roch 定理

回顾我们之前的结果，这实际上给出了鬼数与流形欧拉示性数之间的关系：
$
  angle.l Q angle.r = frac(1 - 2 lambda, 2) chi(L) = (1 - 2 lambda)(1-g) := "deg"(L^(lambda))+ 1- g,
$
这里我们使用了如下事实：$chi(L^(lambda)) = deg(L^(lambda)) = lambda deg(L)$ 且 $deg(L) = 2 - 2g$，其中 $L$ 是 $X$ 上的典范线丛。
注意到鬼数与指标的等价性，我们最终得到了椭圆算子 $overline(partial)$ 的指标定理：
$
  "ind"(overline(partial)_(L^(lambda))) = (1 - 2 lambda) chi(L) = "deg"(L^(lambda)) + 1 - g,
$
使用指标表达式 $"ind"(overline(diff)) = h^(0)(X, cal(O)(L^(lambda))) - h^(1)(X, cal(O)(L^(lambda)))$，这正是 Riemann-Roch 定理：
$
  h^(0)(X, cal(O)(L^(lambda))) - h^(1)(X, cal(O)(L^(lambda))) = "deg"(L^(lambda)) + 1 - g.
$
利用线丛 - 除子对应关系，这个定理可以转化为教科书中的标准形式。
