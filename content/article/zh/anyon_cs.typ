#import "../../../typ/templates/blog.typ": *
#import "../../../typ/packages/typst-fletcher.typ": *
#import "../../../typ/packages/physica.typ": *

#let title = "陈 - 西蒙斯理论的任意子起源"
#show: main.with(
  title: title,
  desc: [通过研究二维空间中的任意子来介绍陈 - 西蒙斯理论，其薛定谔方程即是 Knizhnik-Zamolodchikov 方程。],
  date: "2025-11-02",
  tags: (
    blog-tags.math,
    blog-tags.physics,
    blog-tags.topology,
  ),
  lang: "zh",
  translationKey: "anyon_cs",
  llm-translated: true,
)
#let CS = math.upright("CS")
#let wedge = math.and
#let GL = math.upright("GL")
#let Conf = math.upright("Conf")
#let Hol = math.upright("Hol")


我们可以通过研究二维空间中具有分数统计的任意子，来自然地导出陈 - 西蒙斯理论。
这种任意子系统的时间演化可以表示为一个贝里相位 (Berry phase)，它与共形场论中产生的 Knizhnik-Zamolodchikov 联络密切相关。

作为引言，下面的讨论是直观和非形式化的。
然而，由于这个故事非常简单（但深刻），将所有内容变得严格和精确是很容易的。

= 具有分数统计的任意子

众所周知，在三维（或更高维）空间中，存在两种基本粒子：玻色子和费米子，它们因交换统计的不同而相异。
然而，在二维空间中，存在一种更奇特的粒子，称为“任意子” (_anyons_)，它们表现出介于玻色子和费米子行为之间的分数统计。
简而言之，当两个任意子交换时，波函数会获得一个相位因子 $e^(i theta)$，其中 $theta$ 可以在 $0$（玻色子）和 $pi$（费米子）之间取任何值。

我们可以考虑一个具有两个大质量任意子和统计相位 $theta$ 的系统。
因此，在（例如）复平面 $CC$ 上，该系统的有效拉格朗日量可以写为：
$
  L_(theta) := sum_(i=1)^(2) p_(z)^(i) dot(z)_(i) + sum_(i=1)^(2) A_(z)^(i) dot(z)_(i) =sum_(i=1)^(2) p_(z)^(i) dot(z)_(i) + frac(theta, 2 pi i) frac(dot(z)_1-dot(z)_2, z_1 - z_2),
$
其中 $z_1, z_2 in CC$ 分别表示两个任意子的位置。
根据留数定理，这个规范联络 $A ~ (d z) / z$ 围绕一个任意子的和乐 $(Hol)$ 将产生所需的相位因子 $e^(i theta)$。

现在我们考虑这个系统的量子化。
注意，我们已经为这个规范联络 $A$ 固定了一个规范（全纯规范），而原始理论具有规范冗余。
因此，相关的薛定谔方程可以从约束方程中产生：
$
  (p_(z)^(i) + A_(z)^(i)) psi(z_1, z_2) = 0, quad p_(overline(z))^(i) psi(z_1, z_2) = 0, thin forall i = 1, 2.
$
执行正则量子化 $p_(z)^(i) = - i diff_(z_(i))$，并切换到新坐标 $z = z_1-z_2$，这样的方程可以写为：
$
  (diff_(z) - frac(theta, 2 pi) frac(1, z)) psi(z, overline(z)) = 0, quad diff_(overline(z)) psi(z, overline(z)) = 0.
$
第二个方程意味着 $psi$ 在 $z$ 中是全纯的，第一个方程可以直接求解，得到：
$
  psi(z_1, z_2) = C (z_1 - z_2)^(theta / (2 pi)),
$
这是一个在 $CC$ 上的多值函数，在 $z_1 = z_2$ 处有一个分支切割，围绕这个分支切割的单值性 (monodromy) 恰好是所需的相位因子 $e^(i theta)$。

一个自然的假设是，这样的波函数在环绕 $k$ 次后会回到自身。
因此，统计相位 $theta$ 被量子化为 $theta = 2 pi / k$，其中 $k in ZZ_(>0)$（电荷 $q$ 将被吸收到 $U(1)$ 表示中），这使得波函数变为：
$
  psi(z_1, z_2) = C (z_1 - z_2)^(1 / k).
$
这样一个方程正是在共形场论中著名的 _Knizhnik-Zamolodchikov 方程_！
并且相关的 KZ 联络可以被解释为我们上面介绍的规范联络 $A$，它描述了任意子之间的统计相互作用。

当推广到 $n$ 个任意子时，规范联络可以表示为：
$
  A_(z)^(i) = frac(1, k) sum_(j != i) Omega_(i j) / (z_i - z_j),
$
其中 $Omega_(i j) = q_(i) q_(j)$，并且上述步骤可以直接重复。

= 时间演化

现在我们考虑这种任意子系统的时间演化。
注意，该系统的哈密顿量是平凡的 $H = 0$，因此，时间演化将完全由规范联络 $A$ 产生的贝里相位决定。

因此，我们唯一需要考虑的是 $U(t_(b), t_(a)) := cal(T) exp(i integral z^(*)(A_z) thin d t)$，其中 $z: t -> RR^(2)$ 是任意子的世界线， $cal(T) exp$ 表示时间排序指数。
这样的时间演化算符可以展开为戴森级数 (Dyson series)：
$
  U(t_(b), t_(a)) = 1 + sum_(n=1)^(oo) i^(n) frac(1, n!) integral_(t_(a) <= t_1 <= ... <= t_n <= t_(b)) A_z (z(t_1)) ... A_z (z(t_n)) thin d t_1 ... d t_n := 1 + sum_(n=1)^(oo) (frac(i, k))^(n) cal(A)_(n).
$
将规范联络的定义 $A_z = frac(1, k) sum_(i < j) 1 / (z_i - z_j)$ 代入上式，我们可以将时间演化算符重写为：
$
  cal(A)_(n) = sum_(P) wedge.big_(l in P) integral_(t_(a) <= t_1 <= ... <= t_n <= t_(b)) frac(d z_(l_1) - d z_(l_2), z_(l_1) - z_(l_2)) Omega_(l),
$
其中 $P$ 是集合 ${1, ..., n}$ 的一个配对， $P$ 中的每一对 $l$ 由两个元素 $(l_1, l_2)$ 组成， $Omega_(l) = q_(l_1) q_(l_2)$ 是在世界线上的点 $z(t_(l_1))$ 和 $z(t_(l_2))$ 处的电荷的双重插入，可以写为 $Omega_(i j) := q_(i) q_(j)$，这实际上标记了 $U(1)$ 表示。

这样的表达式（在非阿贝尔情况下，经过适当的正则化）是#link("https://ncatlab.org/nlab/show/Kontsevich+integral")[Kontsevich 积分公式]，用于计算“环路不变量” (_link invariant_)，它是某个环路多项式（例如，琼斯多项式）的泰勒系数，被称为#link("https://ncatlab.org/nlab/show/universal+Vassiliev+invariant")[“普适 Vassiliev 不变量” (_universal Vassiliev invariant_)]。

= 阿贝尔陈 - 西蒙斯理论

现在我们考虑这种任意子系统的场论描述。
描述任意子低能行为的有效场论是“陈 - 西蒙斯理论” (_Chern-Simons theory_)，它是一个定义在三维时空中的拓扑量子场论。
阿贝尔陈 - 西蒙斯作用量由下式给出：
$
  CS_(X)[A] = frac(k, 4 pi) integral_(X) A d A,
$
在全纯规范 $A = A_t d t + A_z d z$ 下，陈 - 西蒙斯作用量简化为：
$
  CS_(X)[A] := frac(k, 4 pi) integral_(X) A overline(diff)_(t) A,
$
其中 $overline(diff)_(t) := d t overline(partial)$。
并且任意子拉格朗日量将通过最小耦合引入到该作用量中，可以表示为：
$
  S_("anyon")[A, z] = integral_(RR) [A_z (z(t)) dot(z)(t) + A_(0) (z(t)) ] thin d t,
$
这本质上是陈 - 西蒙斯理论中的威尔逊线 (Wilson line) 可观测量，其中时间是沿着任意子世界线的自然参数。

为了获得该理论的有效作用量，我们需要积分掉规范场 $A$。
由于陈 - 西蒙斯作用量是 $A$ 的二次型，这样的积分可以精确执行。
注意，在全纯规范下，规范场 $A$ 的关联函数（传播子）可以计算为：
$
  angle.l A(z_1, t_1) A(z_2, t_2) angle.r = frac(1, i k) frac(d z_1 - d z_2, z_1 - z_2) delta(t_1 - t_2).
$
执行高斯积分后，有效作用量可以表示为：
$
  S_("eff")[z] = frac(1, k) integral_(RR) frac(d z(t) - d z(t), z(t) - z(t)) (dot(z)(t) - dot(z)(t)) thin d t = integral_(RR) L_(2pi \/ k) thin d t,
$
这正是我们上面构造的任意子拉格朗日量！
因此，我们可以得出结论，陈 - 西蒙斯理论为我们上面构造的具有分数统计的任意子提供了自然的场论描述。

= 关于 CS-WZW 对应的一些说明

虽然我们不会详细讨论非微扰陈 - 西蒙斯理论，但仍然值得一提的是威腾 (Witten) 工作中的一些重要结果。

我们已经知道，任意子系统的波函数满足 Knizhnik-Zamolodchikov 方程。
这个方程在 Wess-Zumino-Witten (WZW) 模型中自然产生，它是 WZW 模型的共形块（可以解释为局域关联函数）所满足的方程。

另一方面，陈 - 西蒙斯理论的波函数可以被解释为我们上面构造的任意子波函数。
因此，CS-WZW 对应关系可以被解释为
$
  Psi_(CS)[X, {K_(i), rho_(i)}] <--> angle.l product_(i) V_(K_(i))(rho_(i)) angle.r_("WZW", partial X),
$
其中 $V_(K)(rho)$ 表示在 WZW 模型中，线 $K$ 与边界 $partial X$ 相交点处的顶点算符插入，而 ${K, rho}$ 表示一个由规范群的表示 $rho$ 着色的威尔逊线 $K$。
在这里，$rho$ 扮演了我们上面介绍的电荷 $q$ 的角色。
