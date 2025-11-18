#import "../../../typ/templates/blog.typ": *
#import "../../../typ/packages/typst-fletcher.typ": *
#import "../../../typ/packages/physica.typ": *
#import "../../../typ/packages/ctez/src/canvas.typ": canvas
#import "../../../typ/packages/ctez/src/draw.typ"

#let title = "Chern-Simons 理论与 Yang-Baxter 方程"
#show: main.with(
  title: title,
  desc: [Kontsevich 积分可以在微扰 Chern-Simons 理论中找到，它与 Yang-Baxter 方程和 R 矩阵相关联。],
  date: "2025-11-18",
  tags: (
    blog-tags.math,
    blog-tags.physics,
    blog-tags.topology,
  ),
  lang: "zh",
  translationKey: "cs_ybe",
  llm-translated: true,
)
#let CS = math.upright("CS")
#let wedge = math.and
#let GL = math.upright("GL")
#let Conf = math.upright("Conf")
#let Hol = math.upright("Hol")


#let string-diagram(top-conn, bottom-conn, color: color) = {
  let x = (0, 4, 8)
  let y = (3, 9)
  let height = 12

  let hline(conn, y-level) = {
    let (x1, x2) = if conn == "12" {
      (x.at(0), x.at(1))
    } else if conn == "13" {
      (x.at(0), x.at(2))
    } else {
      (x.at(1), x.at(2))
    }

    draw.line((x1, y-level), (x2, y-level), stroke: color)
    draw.circle((x1, y-level), radius: 0.6, stroke: color)
    draw.circle((x2, y-level), radius: 0.6, stroke: color)
  }

  canvas(length: 2pt, {
    for i in (0, 1, 2) {
      draw.line((x.at(i), 0), (x.at(i), height), stroke: color)
    }
    hline(top-conn, y.at(1))
    hline(bottom-conn, y.at(0))
  })
}

#let equation-frame(content) = {
  let target = get-target()
  if target == "web" or target == "html" {
    theme-frame(
      tag: "div",
      theme => {
        let edge = edge.with(stroke: theme.main-color)
        let diagram = string-diagram.with(color: theme.main-color)

        let it = [$
            #{ if type(content) == function { content(diagram) } else { content } }
          $]
        set text(fill: theme.main-color, size: math-size, font: math-font)
        span-frame(attrs: (class: "block-equation"), it)
      },
    )
  } else {
    if type(content) == function {
      content(string-diagram.with(color: white))
    } else {
      content
    }
  }
}

= Chern-Simons 理论
Chern-Simons 理论是定义在三维流形 $X$ 上的 Yang-Mills 理论的拓扑版本。
在这种情况下，规范联络 $A$ 取值于规范群 $G$ 的李代数 $frak(g)$ 中，Chern-Simons 作用量由下式给出：
$
  CS_(X)[A] = integral_(X) tr(A d A + 2/3 A^(3)),
$
其中 $A$ 是 $X$ 上主 $G$-丛的联络 1-形式。
在物理文献中，人们通常考虑带有耦合常数 $k$ 的 Chern-Simons 作用量：
$
  S^(k)_(CS)[A] = k / (4 pi) CS_(X)[A].
$
其中 $k$ 被量子化以确保量子层面的规范不变性。
形式上，使用路径积分形式，Chern-Simons 理论的配分函数形式地由下式给出：
$
  Z^(k)_(CS)(X) = integral d mu_(X)[A] thin e^(i S^(k)_(CS)[A]),
$
即对 $X$ 上 $G$-丛中所有联络的空间模规范变换的商空间进行积分。

在微扰层面，配分函数在满足 $F_(A_0) = 0$ 的平坦联络 $A_0$ 附近展开，这是从 Chern-Simons 作用量导出的经典运动方程。

== Wilson 圈

Chern-Simons 理论中的规范不变观测量是 _Wilson 圈_，它由数据 $(K, rho)$ 定义，其中 $K: SS^(1) arrow.hook X$ 是嵌入 $X$ 中的纽结，$rho: G -> GL(V)$ 是规范群 $G$ 在向量空间 $V$ 上的表示，可以写为：
$
  W_(K)(rho) = tr_(rho) cal(P) exp(integral_(K) i A),
$
其中 $cal(P) exp$ 表示沿纽结 $K$ 的路径有序指数。

在我们之前关于#link("../anyon_cs/")[任意子]的博客中，这样的 Wilson 圈观测量可以被理解为在 $X$ 中运动并携带规范群 $G$ 下某种电荷的粒子的世界线。
其中该粒子的电荷由表示 $rho$ 标记。

#remark(
  [从物理角度讲，Wilson 圈可以如下理解：
    - 处于一般位置的 $K$（Morse 纽结）$<=>$ 在 $X$ 中运动的粒子的世界线。
    - $rho$ $<=>$ 该粒子在规范群 $G$ 下的电荷。
    其中 Morse 纽结指的是限制在纽结上的高度函数（相对于某个固定方向，在物理语境中即时间方向）是 Morse 函数。
  ],
)

Wilson 圈的量子期望值可以形式地定义为：
$
  angle.l W_(K_1)(rho_1) ... W_(K_(n))(rho_(n)) angle.r = frac(1, Z_(CS)(X)) integral d mu_(X)[A] thin e^(i S_(CS)[A]) W_(K_1)(rho_1) ... W_(K_(n))(rho_(n)).
$
值得注意的是，根据 #link("https://link.springer.com/article/10.1007/BF01217730")[Witten] 的工作，这些期望值给出了 $X = SS^(3)$ 中纽结和链环的拓扑不变量（Jones 多项式）。

Witten 的方法使用非微扰方法，将 Chern-Simons 理论与 $X$ 边界上的共形场论（Wess-Zumino-Witten 理论）联系起来，并采用手术技术来计算这些不变量。

一个自然的问题是：我们能用微扰方法恢复这些纽结不变量吗？
在这个层面上，一个自然的期望是，结果将（至少形式上）对应于某些纽结多项式不变量的 Taylor 系数，而每个系数可能是一个新的纽结不变量。
在这篇博客中，我们将看到这确实是事实。
= 从 Chern-Simons 理论得到 Kontsevich 积分

从现在开始，我们假设 $X = RR times Sigma$，其中 $Sigma$ 是黎曼曲面，$RR$ 表示时间方向。
在这种情况下，Morse 纽结可以相对于沿 $RR$ 方向的高度函数定义。

我们还为规范李代数 $frak(g)$ 选择一组基 ${t_(a)}$，使得 $tr(t_(a) t_(b)) = delta_(a b)$，$[t_i, t_j] = f_(i j)^(k) t_(k)$。
然后规范联络 $A$ 可以表示为 $A = A^(a) t_(a)$，其中 $A^(a) in Omega^(1)(X)$ 是 $X$ 上的普通 1-形式（在选择主 $G$-丛的参考平凡化后）。

为了进行微扰展开，我们需要固定一个规范。
在这种情况下，一个自然的规范固定条件可以按如下方式实现。
首先，给定 $Sigma$ 上的复结构，我们可以在 $Sigma$ 上引入复坐标 $(z, overline(z))$。
然后规范联络 $A$ 可以分解为：
$
  A(z, overline(z), t) = A_t d t + A_z d z + A_(overline(z)) d overline(z).
$
我们将施加 _轴向规范_ 条件（又称 _全纯规范_）$A_(overline(z)) = 0$。
因此，规范联络简化为 $A(z, t) = A_(0) d t + A_(z) d z$，Chern-Simons 作用量简化为：
$
  CS_(X)[A] := integral_(X) A overline(diff)_(t) A,
$
其中 $overline(diff)_(t) := d t overline(partial)$。
在这种规范固定下，路径积分将简化为纯粹的高斯积分。

要使用微扰方法，我们需要计算规范场 $A$ 的传播子（两点关联函数）。
在轴向规范下，传播子可以计算为：
$
  angle.l A_(i)^(a)(z_1, t_1) A_(j)^(b)(z_2, t_2) angle.r = delta^(a b) frac(1, i k) frac(d z_1 - d z_2, z_1 - z_2) delta(t_1 - t_2).
$

因此，Wilson 圈的期望值可以使用 Wick 定理计算。
为了计算这个期望值，我们选择嵌入在 $X$ 中的 Morse 纽结 $K$ 和纽结的参数化 $gamma: [0, 1] arrow.hook K subset X$。
然后 Wilson 圈观测量可以展开为：
$
  W_(K)(rho) = 1 + sum_(n=1)^(oo) i^(n) tr_(rho) integral_(0 <= t_1 <= ... <= t_n <= 1) A(gamma(t_1)) ... A(gamma(t_n)),
$
使用规范场的分解 $A = A^(a) t_(a)$，我们可以将其重写为：
$
  W_(K)(rho) & = 1 + sum_(n=1)^(oo) i^(n) sum_(a_1, ..., a_n) tr_(rho)(t_(a_1) ... t_(a_n)) integral_(0 <= t_1 <= ... <= t_n <= 1) A^(a_1)(gamma(t_1)) ... A^(a_n)(gamma(t_n)).
$
因此，期望值可以通过以下方式计算：
$
  angle.l A^(a_1)(z(t_1), t_1) ... A^(a_(2n))(z(t_(2n)), t_(2n))angle.r = (frac(1, i k))^(n) tr_(rho) sum_(P) (-1)^(\# arrow.b P) wedge.big_(l in P) frac(d z_(l_1) - d z_(l_2), z_(l_1) - z_(l_2)) delta(t_(l_1) - t_(l_2)),
$
其中 $P$ 是集合 ${1, ..., 2n}$ 的配对，每个配对 $l in P$ 由两个元素 $(l_1, l_2)$ 组成，$\# arrow.b P$ 表示当赋予从 $K$ 继承的定向时，向下定向的弧的数量。

在积掉 delta 函数后，连接的顶点将位于沿 $RR$ 方向的同一时间切片上。
因此，Wilson 圈的期望值可以表示为：
$
  angle.l W_(K)(rho) angle.r = sum_(n=0)^(oo) frac(1, k^(n)) tr_(rho)Phi_(n)(K),
$
其中 $Phi_(n)(K)$ 称为纽结 $K$ 的 _Kontsevich 积分_，可以表示为：
$
  Phi_(n)(K) = sum_(P) wedge.big_(l in P) (-1)^(\# arrow.b P) integral_(0 <= t_1 <= ... <= t_(n) <= 1) frac(d z_(l_1) - d z_(l_2), z_(l_1) - z_(l_2)) Omega_(l).
$
其中 $Omega_(l) = rho(t_(l_1)) times.circle rho(t_(l_2))$ 是在纽结上点 $gamma(t_(l_1))$ 和 $gamma(t_(l_2))$ 处李代数元素的双重插入，可以理解为在这两点处用权重 $Omega_(l)$ "连接"纽结。

不难看出，$Phi_(n)(K)$ 的定义是（我们在 #link("../anyon_cs")[前一篇博客] 中讨论的任意子系统构造的时间演化算符的非阿贝尔推广）。
因此，你可以认为 Kontsevich 积分可以被理解为某个任意子系统沿世界线 $K$ 运动时在统计相互作用存在下的时间演化算符。

#remark(
  [嗯，在 $Phi_(n)(K)$ 的定义中有一个额外的因子 $(-1)^(\# arrow.b P)$，这在任意子系统中是不存在的。
    这是因为，在任意子系统中，高度函数沿世界线不应该有临界点，因此，这样的因子总是平凡的。
    因此，从这个意义上说，Chern-Simons 理论自然地包含了"反任意子"效应，这在我们上面构造的简单任意子系统中是不存在的。

    一个有趣的问题是，我们能否构造某个包含这种"反任意子"效应的任意子系统？
  ],
)

== 例子：从 Kontsevich 积分得到 R-矩阵

我们考虑两条链的简单辫子构型，这是嵌入在 $RR times CC$ 中的简单 Morse 纽结。

时间切片上两条链的交点将在 $CC$ 中成为两个不同的点 $z_1, z_2$。
使用 Kontsevich 积分的构造，唯一的非平凡贡献来自这两点上规范联络的 $n$ 次方，这给出#footnote([这是量子场论中所谓连通图展开的最简单情况。])：
$
  angle.l W_(K)(rho) angle.r = tr_(rho) sum_(n=0)^(oo) frac(1, k^(n)) frac(1, n!) (Phi_(1)(K))^(n) ,
$
其中 $Phi_1(K)$ 可以计算为：
$
  Phi_1(K) = integral.cont frac(d z, z) Omega = 2 pi i Omega,
$
因此，期望值可以表示为：
$
  angle.l W_(K)(rho) angle.r = tr_(rho) exp(frac(2 pi i, k) Omega),
$
这（在取迹之前）恰好与作用在张量积表示 $rho^(times.circle 2): frak(g) times.circle frak(g) -> GL(V times.circle V)$ 上的量子 _R-矩阵_ 相关。

= Knizhnik-Zamolodchikov 联络

现在我们考虑上面构造的期望值的物理解释。
为了实现这个目标，让我们考虑一个（看似）独立的来自共形场论的问题。

在研究具有规范对称性的共形场论时，Knizhnik 和 Zamolodchikov 发现了 Wess-Zumino-Witten (WZW) 模型中初级场关联函数满足的一个显著的微分方程。

考虑复平面 $CC$ 中的 $n$ 个不同点 ${z_1, ..., z_n}$，并将李代数 $frak(g)$ 的表示 $rho_i: frak(g) -> GL(V_i)$ 关联到每个点 $z_i$。
Knizhnik-Zamolodchikov (KZ) 方程是关于函数 $F: Conf_(n)(CC) -> V_1 times.circle ... times.circle V_n$ 的一阶微分方程组，其中 $Conf_(n)(CC) = {(z_1, ..., z_n) in CC^(n) | z_i != z_j, forall i != j}$ 是 $CC$ 中 $n$ 个不同点的位形空间：
$
  (diff F) / (diff z_i ) - 1 / (k + h^(or)) sum_(i > j) Omega_(i j) / (z_i - z_j) F = 0, thin forall i = 1, ..., n,
$
其中 $h^(or)$ 是李代数 $frak(g)$ 的对偶 Coxeter 数，$Omega_(i j)$ 是作用在张量积 $V_1 times.circle ... times.circle V_n$ 的第 $i$ 和第 $j$ 个因子上的 _Casimir 元_，定义为：
$
  Omega_(i j) = sum_(a) rho_i (t_(a)) times.circle rho_j (t_(a)).
$

根据定义，KZ 方程描述了位形空间 $Conf_(n)(CC)$ 上的局部系统，可以被理解为平坦联络 $nabla_("KZ")$。

平坦性的证明是直接计算。
然而，这个平坦性有一些非常重要的结果，所以我强烈建议你阅读它。

#proof(
  [
    由于 $(d z)/z$ 已经是闭形式，我们只需要检查 $A_("KZ") wedge A_("KZ") = 0$，其中 $A_("KZ") = 1 / (k + h^(or)) sum_(i < j) Omega_(i j) d log(z_i - z_j)$。
    我们记 $g_(i j) = d log(z_(i) - z_(j))$，我们有一个重要的恒等式（Arnold 恒等式）：
    $
      g_(i j) wedge g_(j k) + g_(j k) wedge g_(k i) + g_(k i) wedge g_(i j) = 0.
    $
    因此，验证 $A_("KZ") wedge A_("KZ") = 0$ 可以归结为检查以下恒等式：
    $
      [Omega_(i j), Omega_(i k) + Omega_(j k)] = 0,
    $
    这本质上是 _经典 Yang-Baxter 方程_，可以使用 $Omega_(i j)$ 的定义和李代数关系直接验证。
  ],
  title: "平坦性的证明",
  collapsed: false,
)

一个自然的问题是：这个局部系统的单值性是什么？
我们首先考虑 $n=2$ 的情况，它可以归结为单个常微分方程：
$
  frac(diff F, diff z) - frac(1, planck.reduce) Omega/z F = 0.
$
解可以表示为 $F(z) = z^(frac(1, planck.reduce) Omega) C$。
在 $z$ 绕原点转一圈后，即 $z |-> e^(2 pi i) z$，解将变换为：
$
  F(z) |-> e^(2 pi i frac(1, planck.reduce) Omega) F(z),
$
因此，单值矩阵由 $M = e^(2 pi i frac(1, planck.reduce) Omega)$ 给出。
这恰好是我们从微扰 Chern-Simons 理论中找到的 R-矩阵！#footnote([嗯，你可能会争辩说在 CS 和 KZ 情况下 $planck.reduce$ 的定义中有一个（轻微的）因子 $h^(or)$ 的差异。然而，由于微扰展开是在大 $k$ 极限（小 $planck.reduce$）下进行的，这个差异可以被忽略。此外，从微扰 CS 理论的角度恢复这个因子 $h^(or)$ 是相当有趣的，我不知道如何做到这一点。])

事实上，这不是巧合。
根据 Drinfeld 和 Kohno 的工作，KZ 联络的单值表示等价于从相应量子群的 R-矩阵获得的辫群表示。

另一个自然的问题是：$n$ 个点的一般情况如何？
由于 KZ 联络是平坦的，单值性等价于这个联络的和乐，这样的和乐可以重新表述为：
$
  Hol_(nabla_("KZ"))(gamma) = cal(P) exp(integral_(gamma) A_("KZ")),
$
其中 $A_("KZ") = 1 / (k + h^(or)) sum_(i < j) Omega_(i j) d log(z_i - z_j)$。
这样的和乐可以展开并直接计算：
$
  Hol_(nabla_("KZ"))(gamma) = sum_(m=0)^(oo) frac(1, m!) integral_(0 <= t_1 <= ... <= t_m <= 1) A_("KZ")(gamma(t_1)) ... A_("KZ")(gamma(t_m)).
$
代入 $A_("KZ")$ 的表达式后，和乐可以表示为：
$
  Hol_(nabla_("KZ"))(gamma) = sum_(m=0)^(oo) frac(1, (k + h^(or))^(m)) sum_(P) wedge.big_(l in P) integral_(0 <= t_1 <= ... <= t_m <= 1) frac(d z_(l_1) - d z_(l_2), z_(l_1) - z_(l_2)) Omega_(l),
$
将 $t$ 解释为时间方向，这恰好是我们从微扰 Chern-Simons 理论构造的 Kontsevich 积分（在取 $k >> h^(or)$ 极限后）。

此外，我们可以得出结论，微扰 Chern-Simons 理论中 Wilson 圈的期望值是 KZ 联络的（形式）Dyson 级数展开。

= 从 Chern-Simons 理论得到 Yang-Baxter 方程

与其使用 KZ 联络及其 Dyson 公式来手摇论证 Chern-Simons 理论产生 Yang-Baxter 方程的解，我们将给出一个更直接的来自紧化位形空间的论证。
这样的构造最初由 Kontsevich 在关于 Poisson 流形形变量子化的工作中引入。

== Kontsevich 积分的不变性

我们首先回到从微扰 Chern-Simons 理论对 Kontsevich 积分的定义：
$
  Phi_(n)(K) = sum_(P) wedge.big_(l in P) (-1)^(\# arrow.b P) integral_(0 <= t_1 <= ... <= t_(n) <= 1) frac(d z_(l_1) - d z_(l_2), z_(l_1) - z_(l_2)) Omega_(l).
$
这个构造可以用 Feynman 图重新解释。
为了实现这个目标，我们注意到：
- 坐标 ${t_(i)}$ 表示 $SS^(1)$（或 $RR^(1)$）上的一些点
- 配对 $P$ 可以被理解为连接 $SS^(1)$（或 $RR^(1)$）上这些点的一组 _弦_
第一个观察引入了 Feynman 图中的顶点，而第二个观察引入了 Feynman 图中的边（传播子）。
因此，弦图可以自然地嵌入 Feynman 规则。

#remark(
  [在弦图的世界中，Feynman 图中的顶点称为 _弦_，而边称为 _弦_。
  ],
)

#image_viewer(
  path: "../assets/cs_ybe_1.png",
  desc: [在 $SS^1$ 上的弦图。],
  dark-adapt: true,
  adapt-mode: "invert-no-hue",
)

不难想象，由于 Kontsevich 积分是从 Chern-Simons 理论的微扰展开构造的，它应该在纽结 $K$ 的同痕下不变。

然而，这种朴素的期望在纽结 $K$ 的任意同痕下并不成立。
例如，考虑一个会在沿纽结 $K$ 的高度函数中创建或湮灭一对临界点的同痕，Kontsevich 积分在这样的同痕下不会不变。

如果我们限制在保持纽结 $K$ 的 Morse 性质的同痕，Kontsevich 积分将在这样的同痕下不变。

Morse 纽结类中任何纽结的形变都可以用三种类型的形变序列来近似：
- 保持定向的重新参数化，验证 Kontsevich 积分的不变性是平凡的。
- 水平形变：保持所有水平平面 ${t = "const"}$ 并固定所有临界点（连同一些小邻域）。
- 临界点的移动。

现在我们关注后两种类型的形变。

=== 水平形变

水平形变可以看作是固定边界点的缠结的同痕。
考虑两个缠结 $T_(0)$ 和 $T_(1)$，它们通过水平形变 $T_(lambda)$，$lambda in [0, 1]$ 相关。

$T_1$ 和 $T_0$ 上的 Kontsevich 积分可以与参数空间 $Delta = Delta_(0) times [0, 1]$ 的边界上的积分相关，其中 $Delta_(lambda) := {0<t_1<...<t_(n)<1} times {lambda}$ 是固定 $lambda$ 时 $[0,1]$ 上的标准 $n$-单纯形。
通过 Stokes 定理，我们有：
$
  integral_(partial Delta) omega = integral_(Delta) d omega -->^(d omega = 0) 0,
$
其中 $partial Delta = Delta_(1) - Delta_(0) + ...$，$...$ 表示来自（余维 $1$）边界层的贡献，其特征是某两点坍缩构型，即：
$
  integral_(Delta_(1)) omega - integral_(Delta_(0)) omega + integral_(diff Delta times [0,1]) omega = 0.
$
使用 Fubini 定理，我们只需要检查来自 $diff Delta$ 的贡献来验证 Kontsevich 积分在水平形变下的不变性，即，我们需要检查来自 $diff Delta$ 的贡献会消失。

有四种类型的这样的坍缩构型：
- 时间平面碰到临界点。
- 两条弦终止于两个相同点。
- 两条弦的端点属于四条不同的弦。
- 两条弦的端点属于三条不同的弦。

*第一种类型* 的边界层不会对积分有贡献，因为被积形式会在这样的边界上消失。

*第二种类型* 的边界层也不会对积分有贡献，因为由于楔积的反对称性，被积形式会在这样的边界上消失：
$
  (d z_(k) - d z'_(k)) wedge (d z_(k) - d z'_(k)) = 0,
$
而 $z_(k) = z_(k+1)$ 且 $z'_(k) = z'_(k+1)$。

*第三种类型* 的边界层不会天真地为零。
我们将四条不同的弦记为 $1, 2, 3, 4$，以及两条坍缩的弦，例如 $(1, 3)$ 和 $(2, 4)$，用它们的端弦来表示。

可能的坍缩构型可以通过以下两种方式构造：
- 第 $k$ 条弦是 $(1,3)$，第 $k+1$ 条弦是 $(2,4)$。
- 第 $k$ 条弦是 $(2,4)$，第 $k+1$ 条弦是 $(1,3)$。
并且有两条额外的弦分别连接 $(1,2)$ 和 $(3,4)$。
因此，来自这两个坍缩构型的贡献可以表示为：
$
  (1,2) wedge (3,4) wedge (d z_(k) - d z'_(k)) / (z_(k) - z'_(k)) wedge (d z_(k+1) - d z'_(k+1)) / (z_(k+1) - z'_(k+1)) + (1,2) wedge (3,4) wedge (d z_(k+1) - d z'_(k+1)) / (z_(k+1) - z'_(k+1)) wedge (d z_(k) - d z'_(k)) / (z_(k) - z'_(k)) = 0,
$
（其中这种构型的 $D_(p)$ 是相同的）因此，第三种类型的边界层也不会对积分有贡献。

*最后一种类型* 的边界层是最有趣的。
我们可以通过遍历所有连接情况，用以下 $6$ 种方式构造这样的坍缩构型：
#equation-frame(
  diagram => {
    [$
        mat(
          (-1)^↓ #diagram("12", "23") " " omega_12 wedge omega_23,
          + (-1)^↓ #diagram("12", "13") " " omega_12 wedge omega_13;
          + (-1)^↓ #diagram("13", "12") " " omega_13 wedge omega_12,
          + (-1)^↓ #diagram("13", "23") " " omega_13 wedge omega_23;
          + (-1)^↓ #diagram("23", "12") " " omega_23 wedge omega_12,
          + (-1)^↓ #diagram("23", "13") " " omega_23 wedge omega_13;
          delim: #none
        ) "."
      $
    ]
  },
)

使用 $omega_(i j) = omega_(j i)$ 的事实，上面的方程与 Arnold 恒等式一致：
$
  omega_(12) wedge omega_(23) + omega_(23) wedge omega_(13) + omega_(13) wedge omega_(12) = 0,
$
因此，最后一种类型的边界层也不会对积分有贡献。
因此，我们得出结论：
#theorem(
  [Kontsevich 积分在 Morse 纽结 $K$ 的水平形变下不变。],
)

=== 临界点的移动

Kontsevich 积分在临界点移动下不是不变量。
在这样的形变下，Kontsevich 积分会改变 $Phi(oo)^(1/2)$，这是未知结的 Kontsevich 积分（进一步讨论，请查看 #link("https://arxiv.org/pdf/1103.5628")[此文]）。
因此，归一化的 Kontsevich 积分定义为：
$
  hat(Phi)_(n,c)(K) = frac(Phi_(n)(K), (Phi(oo))^(c/2)),
$
其中 $c$ 是 Morse 纽结 $K$ 的临界点数量。
这个归一化因子也将抵消 Chern-Simons 理论中的框架异常。
这被称为 _泛 Vassiliev 不变量_。

== 应用：量子 Yang-Baxter 方程

Yang-Baxter 方程可以理解为纽结理论中 III 型 Reidemeister 移动下 Kontsevich 积分的不变性。
在任意子的语境中，这可以被解释为三个任意子之间辫状的一致性条件。

因此，积分将由 $3$-链缠结建模，对 $Delta times [0,1]$ 的边界上的积分将导致：
$
  Phi_(n)(T_(1)) - Phi_(n)(T_(0)) + integral_(diff Delta times [0,1]) omega = 0,
$
其中 $T_(0)$ 和 $T_(1)$ 是通过 III 型 Reidemeister 移动相关的两个缠结。

这与上面讨论的水平形变情况完全相同。
因此，使用与之前相同的论证，来自边界层的贡献将消失。
我们剩下的是 $Phi_(n)(T_1) = Phi_(n)(T_(0))$，这是 $planck.reduce^(n)$ 阶（量子）Yang-Baxter 方程。
