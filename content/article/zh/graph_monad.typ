#import "../../../typ/templates/blog.typ": *
#import "../../../typ/packages/typst-fletcher.typ": *
#import "../../../typ/packages/physica.typ": *

#let title = "费曼规则作为单子"

#show: main.with(
  title: title,
  desc: [费曼规则的定义可以通过单子（Monad）语言来捕捉，而“重整化”过程对应于广义的 (co)bar construction。],
  date: "2025-12-16",
  tags: (
    blog-tags.math,
    blog-tags.physics,
    blog-tags.algebra,
    blog-tags.abstract-nonsense,
  ),
  lang: "zh",
  translationKey: "graph_monad",
  llm-translated: true,
)

#let Mod = math.bold("Mod")
#let Aut = math.text("Aut")
#let stable = math.text("stable")
#let sMod = [$#Mod^#stable$]

= 量子场论中的费曼规则

让我们简要回顾一下微扰量子场论（QFT）中的费曼规则。

一个由拉格朗日量描述的场论通常可以分解为：
- *自由部分（Free part）：* 场中的二次项。
- *相互作用部分（Interaction part）：* 场中的高阶项。

当使用维克定理（Wick's theorem）对路径积分进行微扰展开时，展开式中的每一项都可以用一个费曼图来表示，其构建遵循以下规则：
- *图（Graph）* $Gamma(g, n)$：一个亏格为 $g$ 且带有 $n$ 条带标号外腿（external legs）的图。
- *边（Edges）：* 对应传播子 $angle.l phi_1(x_1) phi_2(x_2)angle.r$，源自拉格朗日量的自由部分。
- *顶点（Vertices）：* 对应拉格朗日量中的相互作用项。
每个顶点的配价（valence）由相互作用项的阶数决定。



最后，在对所有内部顶点进行积分并对所有可能的图进行求和后，我们得到了关联函数的微扰展开。

这种为每条边和每个顶点分配代数数据的过程构成了*费曼规则*。

自由部分对于计算费曼积分至关重要，但我们在此不做讨论。
在这篇博文中，我们将聚焦于图的组合结构以及向其顶点分配数据的过程。

现在，让我们严谨地形式化这些想法。

= 顶点

首先，顶点可能的贡献可以被组织成一种特定的结构#footnote([如果理论中有额外的结构输入，例如分级（grading），我们应将向量空间替换为相应的对象，如分级向量空间。])：
- 一个按顶点配价分级的向量空间。
- 对称群 $bb(S)_n$ 在 $n$ 阶部分上的置换作用，代表外腿标号的置换。

因此，这些贡献构成了一个 $bb(S)$-模（或称为对称序列），其中 $bb(S)_(n)="Aut"({1,...,n})$。一个 $bb(S)$-模是向量空间序列 $V = {V(n), n>0}$，其中每个空间都装备了 $bb(S)_n$ 的作用。

我们可以构造 $bb(S)$-模的范畴，记为 $Mod_(bb(S))$，其对象是 $bb(S)$-模，态射是 $bb(S)$-等变线性映射。

这个向量空间可能对应于额外的数据。
在我们的语境中，考虑亏格分级是很自然的。即，每个 $V(n)$ 可以进一步分解为：
$
  V(n) = plus.big_(g >= 0) V(g, n),
$
其中 $g$ 是表示亏格的非负整数，满足*稳定性条件* $2g - 2 + n > 0$。
如果我们仅限于树级（tree-level）贡献，我们将 $g = 0$ 并要求 $n >= 3$（对于传播子则 $n>=2$），这实际上忽略了不稳定的蝌蚪图（tadpole diagrams）。
由于该条件对应于 modular operad 理论中的稳定性，我们将此类 $bb(S)$-模的范畴记为 $Mod^(stable)_(bb(S))$，即稳定的 $bb(S)$-模。

= 图

接下来，我们考虑图。
直观地定义一个图很容易，但建立精确的公理化框架却很微妙。
描述图的一种自然方式是：
- 收集所有顶点形成一个集合 $V(Gamma)$。
- 为每个顶点 $v in V(Gamma)$ 分配一个半边（half-edges）集合 $H(v)$。该集合的基数称为配价 $n(v)$。
- 将半边配对形成边。边的集合记为 $E(Gamma)$。
- 剩余未配对的半边称为（外部）腿（legs），记为 $L(Gamma)$，其基数为 $n$。

此外，一个标号图为每个顶点 $v$ 分配一个非负整数 $g(v)$，称为顶点的亏格。
图 $Gamma$ 的亏格定义为：
$
  g(Gamma) = sum_(v in V(Gamma)) g(v) + b_1(Gamma),
$
其中 $b_1(Gamma)$ 是图的第一贝蒂数#footnote([这个亏格定义在 modular operad 的语境中是标准的。与通常的图亏格（贝蒂数）不同，我们用“内部”亏格数据装饰每个顶点，这对单子结构至关重要。])。
这样的图记为 $Gamma_(g)$。



我们将标号图 $Gamma(g, n)$ 定义为一个二元组 $(Gamma_(g), rho)$，其中 $rho: {1,...,n} -> L(Gamma)$ 是对外腿进行标号的双射。

亏格为 $g$ 且有 $n$ 条标号腿的标号图范畴记为 $Gamma((g,n))$，其对象是标号图 $Gamma(g, n)$，态射是保持腿标号的图态射。

我们在此略过图态射的技术定义。粗略地说，态射是两个图之间保持顶点、边和腿连接结构的映射。

在 $Gamma((g,n))$ 中存在一个终对象：单顶点图 $*_(g,n)$，它没有边，只有一个亏格为 $g$ 的顶点和 $n$ 条腿。

= 重访费曼规则

现在我们可以利用 $sMod_(bb(S))$ 和 $Gamma((g,n))$ 的范畴论语言来重新表述费曼规则。

在这个语境下，一个费曼规则由以下要素指定：
- $sMod_(bb(S))$ 中的一个对象 $V$。
- $Gamma((g,n))$ 中的一个图同构类 $[Gamma(g, n)]$。

对所有可能的图同构类 $[Gamma(g, n)]$ 求和，我们获得了一个 $sMod_(bb(S))$ 上的自函子（endofunctor），记为 $bb(M)$：
$
  bb(M) V(g,n) tilde.equiv plus.big_(Gamma in [Gamma(g, n)]) V(Gamma)_(Aut(Gamma)) := plus.big_(Gamma in [Gamma(g, n)]) V(g,n)_(Aut(Gamma)),
$
其中 $V_(G)$ 是 $G$-模 $V$ 的余不变空间（coinvariant space）。

由于 $bb(M)$ 是 $Mod_(bb(S))$ 上的自函子，我们可以考虑 $bb(M)^(2) V$ 与 $bb(M) V$ 之间的关系。

此外，我们可以考虑任意正整数 $k$ 的 $bb(M)^(k) V(g,n)$。
根据定义，这种复合对应于：
- 在图的层面上，
  - 考虑一个费曼图。
  - 对于图中的每个顶点，用另一个费曼图替换它。
- 在向量空间的层面上，
  - 对于每个顶点，为其分配一个向量空间 $bb(M)^(k-1)V(Gamma)$。
  - 通过再次应用费曼规则获得一个新的向量空间。



存在一个自然变换 $mu: bb(M)^(2)V -> bb(M) V$，称为自函子 $bb(M)$ 的*乘法*。这对应于以下操作：
- 将图代入顶点。
- 将其压平（flattening）为单个图。
- 使用费曼规则获得一个向量空间。

对于 $bb(M)^(3)V$，有两种压平嵌套图的方式（结合律）：
- 先压平最底层，然后处理结果图。
- 先压平最高层，然后处理结果图。
两种过程产生相同的结果，满足结合律条件。

此外，存在一个单位变换 $eta: id -> bb(M)$，其中 $id$ 是恒等自函子。这对应于单顶点图 $*_(g,n)$ 的包含映射。

因此，自函子 $bb(M)$ 连同 $mu$ 和 $eta$，构成了 $sMod_(bb(S))$ 范畴上的一个*单子（Monad）*。
这表明费曼规则的组合结构可以被单子语言完美地捕捉。

= Modular Operads

回顾一下，一个 cyclic operad 仅仅是对应于树的特定单子上的代数。

由于我们的单子 $bb(M)$ 是使用带有亏格圈的图定义的，其代数将 operad 推广为所谓的 *modular operad*。

确切地说，一个 modular operad $cal(A)$ 是单子 $bb(M)$ 上的一个代数，配备了一个结构映射 $rho: bb(M)cal(A) -> cal(A)$，满足：
- *结合律：* $rho compose mu_(cal(A)) = rho compose bb(M)(rho)$。
- *单位律：* $rho compose eta_(cal(A)) = id_(cal(A))$。

我们将 modular operad 记为一个二元组 $(cal(A), rho)$。

= 乘法函子与重整化

既然已经通过单子定义了费曼规则，我们转向微扰 QFT 中的一个关键过程——*重整化*。

== 核心思想

威尔逊重整化群（RG）方法表明，为了获得低能标下的有效理论，我们需要：
+ 积掉（Integrate out）高能模，导致原始相互作用项“流”向有效相互作用。
+ 对场和耦合常数进行重标度。
+ 在低能下仅保留相关（relevant）和边缘（marginal）的相互作用项。

乘法函子 $mu$ 自然地描述了第一步的组合学层面：内部边的收缩对应于传播子的积分。

== Bar Construction

给定由单子 $bb(M)$ 构造的 modular operad $cal(A)$，重整化过程可以由以下映射捕捉：
$
  bb(M) cal(A) ->^rho cal(A),
$
其中 $rho$ 是 modular operad $cal(A)$ 的结构映射。

考虑迭代地应用函子 $bb(M)$。这对应于嵌套收缩（或能标）的层级结构。
我们得到一系列映射：
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
这是 $sMod_(bb(S))$ 范畴中的一个单纯对象（simplicial object），构成了 modular operad $cal(A)$ 的 *bar construction*。

单纯对象编码了面映射（face maps）${diff_(i)}$ 和退化映射（degeneracy maps）${sigma_(i)}$，从而产生同调结构。“主方程” $diff^(2) = 0$ 编码了理论的一致性条件，特别是单子的结合律和单位律公理。

考虑边界算子 $diff$ 的具体结构。
面映射 $diff_i$ 本质上对应于在第 $i$ 层嵌套处收缩图。此类映射的表达式为：
$
  diff_(i) = cases(
    bb(M)^(i) compose mu compose bb(M)^(n-1-i)\, thin & 0<=i<n,
    bb(M)^(n) compose rho\, & thin i=n\,
  )
$
这些映射满足单纯恒等式 $diff_(i) diff_(j) = diff_(j-1) diff_(i)$。

利用这些面映射，我们定义总边界映射 $diff_((n)): bb(M)^(n+1)cal(A) -> bb(M)^(n) cal(A)$ 为：
$
  diff_((n)) = sum_(i=0)^(n) (-1)^(i) diff_(i),
$
其中由于单纯恒等式，主方程 $diff^(2)_((n)) = 0$ 得到满足。

#remark([
  这个 bar construction 是同调代数中经典 bar construction 的自然推广。在那里，链复形可以被视为一维的树，而面映射对应于顶点的“分裂”。

  若将我们的图限制为树（亏格为 0），则得到 cyclic operad 的 bar construction，其中复合映射对应于连接两棵树的腿。
])

= 展望

我们主要在顶点及其复合的层面上，建立了费曼图的“范畴学描述”。

然而，仍有重要的数据未被捕捉。
例如，在微扰陈 - 西蒙斯（Chern-Simons）理论中，关联函数（在 $bb(R)^(3)$ 上）涉及高斯环绕数（Gaussian linking number），这对边的*定向*非常敏感。
因此，要发展一个完整的范畴学描述，必须将定向数据考虑在内。
这引出了 "twisted modular operads" 的概念，它与 Kontsevich 的图复形（graph complex）——陈 - 西蒙斯微扰理论的“真正”归宿——密切相关。

但这便是后话了。
