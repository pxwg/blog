#import "../../../typ/templates/blog.typ": *
#import "../../../typ/packages/physica.typ": *

#let wedge = math.and
#let title = "作为 S³ 上测地流的 Kepler 问题"
#show: main-zh.with(
  title: title,
  desc: [球极投影的余切提升将 $SS^3$ 上的测地流与正则化的负能量 Kepler 流等同起来。],
  date: "2026-07-28",
  tags: (
    blog-tags.math,
    blog-tags.physics,
    blog-tags.topology,
  ),
  lang: "zh",
  translationKey: "kepler_s3",
  llm-translated: true,
)

Kepler 问题通常从它的守恒量入手。能量和角动量将运动约化到一个平面上，随后便可以在极坐标中算出轨道。这是求解该问题的一种有效方式，但它并没有穷尽其中隐藏的几何。

对于负能量，角动量与 Runge--Lenz 矢量揭示出一种 $op("SO")(4)$ 对称性。我们不会在这里推导它们的完整代数关系，而只是将这一对称性视作一条线索：$op("SO")(4)$ 是 $RR^4$ 的旋转群，也是标准三维球面 $SS^3$ 的保向等距群。这自然引出了一个问题：负能量 Kepler 问题能否被理解为 $SS^3$ 上的自由运动？

沿着#link("https://doi.org/10.1002/cpa.3160230406")[Moser 正则化]的思路，我们将直接构造这一对应。
这个构造把正则化的 Kepler 流与 $SS^3$ 上的测地流等同起来，并让我们从大圆中重新得到 Kepler 椭圆。

= 三维球面的球极投影

将 $RR^4$ 中的一点写作 $(xi_0, xi_(perp)) in RR times RR^3$，并令
$
  SS^3
  = {(xi_0, xi_(perp)) in RR times RR^3
    | xi_0^2 + norm(xi_(perp))^2 = 1}.
$
我们将北极记为 $N=(1,0)$。从 $N$ 出发的球极投影给出一个坐标卡
$
  sigma_N: SS^3 - {N} -> RR^3,
  quad
  x = sigma_N (xi_0, xi_(perp))
  = frac(xi_(perp), 1 - xi_0).
$
其逆映射为
$
  xi_0
  = frac(norm(x)^2 - 1, 1 + norm(x)^2),
  quad
  xi_(perp)
  = frac(2x, 1 + norm(x)^2).
$
因此，$SS^3$ 是 $RR^3$ 的单点紧化：被略去的北极出现在 $norm(x) -> oo$ 处。

标准球面度规拉回为 Euclidean 度规的一个共形倍数，
$
  g_("rd")
  = frac(4, (1 + norm(x)^2)^2)
  sum_(i=1)^3 (dif x_i)^2,
$
而它的余度规为
$
  g_("rd")^(-1)
  = frac((1 + norm(x)^2)^2, 4)
  sum_(i=1)^3 partial_(x_i)^2.
$
对于一个协向量 $y in T_x^* RR^3$，标准球面上自由粒子的 Hamilton 函数因而为
$
  F(x,y)
  := frac(1, 2) g_("rd")^(-1) (y,y)
  = frac((1 + norm(x)^2)^2, 8) norm(y)^2.
$
单位速测地流位于能级集 $F=1/2$ 上。


仅有底空间上的投影还不足以给出动力系统之间的映射：Kepler 问题存在于相空间中。我们需要考虑球极投影的余切提升，其局部坐标为 $(x,y)$。这个构造中出人意料的一点在于，$x$ 对应 Kepler 动量，而 Kepler 位置则成为与它共轭的协向量 $y$。

= 负能量 Kepler 能量面

约去质心运动后，三维 Kepler 问题的相空间为
$
  cal(P) = T^* (RR^3 - {0})
$
其中位置 $q in RR^3 - {0}$、动量 $p in RR^3$，Hamilton 函数为
$
  H(q,p)
  = frac(1, 2) norm(p)^2 - frac(1, norm(q)).
$
碰撞点集 $q=0$ 被排除在外，而当一条轨道趋近碰撞时，Hamilton 向量场会变得奇异。

对能量进行缩放后，只需研究归一化能量面 $Sigma_(-1\/2)$。它的能量方程为
$
  -frac(1, 2)
  = frac(1, 2) norm(p)^2 - frac(1, norm(q)),
$
或者等价地，
$
  frac((1 + norm(p)^2)^2, 4) norm(q)^2 = 1.
$

现在引入正则变换
$
  Phi(q, p)=(-p,q)=:(x,y).
$
归一化能量条件变为
$
  frac((1 + norm(x)^2)^2, 4) norm(y)^2 = 1.
$
将这个方程与球面 Hamilton 函数 $F$ 比较，我们立即得到
$
  Phi(Sigma_(-1\/2))
  = {F=frac(1, 2)}
  = S^* (SS^3 - {N}).
$
因此，在球极投影的余切坐标中，归一化的 Kepler 能量面恰好就是标准球面的单位速约束。

= 流的对应

能量超曲面相同，还不足以等同两侧带参数的流。令
$
  K
  := H compose Phi^(-1)
  = frac(1, 2) norm(x)^2 - frac(1, norm(y)).
$
由于 $Phi$ 是正则变换，Kepler 向量场的推前就是 $K$ 的 Hamilton 向量场：
$
  Phi_* X_H
  = sum_(i=1)^3 [
    frac(y_i, norm(y)^3) partial_(x_i)
    - x_i partial_(y_i)
  ].
$

对于球面上的自由粒子 Hamilton 函数，利用
$
  dif F = -iota_(X_F) omega,
  quad
  omega = sum_(i=1)^3 dif y_i wedge dif x_i,
$
我们得到
$
  X_F
  = sum_(i=1)^3 [
    frac((1 + norm(x)^2)^2, 4)
    y_i partial_(x_i)
    - frac(1 + norm(x)^2, 2)
    norm(y)^2 x_i partial_(y_i)
  ].
$
在共同的能量超曲面
$
  Sigma = {F=frac(1, 2)} = {K=-frac(1, 2)},
$
上，约束 $(1 + norm(x)^2) norm(y)=2$ 将这个向量场化为
$
  X_F|_Sigma
  = sum_(i=1)^3 [
    frac(y_i, norm(y)^2) partial_(x_i)
    - norm(y) x_i partial_(y_i)
  ]
  = norm(y) Phi_* X_H.
$
因此，
$
  Phi_* X_H
  = frac(1, norm(y)) X_F
  quad "on" quad Sigma.
$

若以 $t$ 表示 Kepler 时间、$s$ 表示球面测地流的弧长参数，那么
$
  dif t
  = norm(y) dif s
  = norm(q) dif s,
  quad
  dif s = frac(dif t, norm(q)).
$
这就是 _Sundman 时间重参数化_。它将归一化的 Kepler 流转化为去点球面上的单位速测地流。

= 碰撞正则化

至此，这个构造给出
$
  Sigma_(-1\/2)
  tilde.equiv
  S^* (SS^3 - {N}).
$
在固定能量下，趋近碰撞意味着
$
  q -> 0,
  quad
  norm(p) -> oo.
$
在 $x=-p$ 与 $y=q$ 之下，这变为 $norm(x)->oo$，恰好对应球极投影坐标卡中缺失的北极。

仅仅把北极加入底空间还不够。在碰撞处，剩余的数据是正则化轨道的方向。自然的补全方式是加入单位协向量球面
$
  S_N^* SS^3 tilde.equiv SS^2
$
作为 $N$ 上方的纤维。因此，补全后的能量面为
$
  hat(Sigma)_(-1\/2)
  tilde.equiv S^* SS^3
  tilde.equiv T_(1) SS^3.
$
测地流在这个补全空间上是光滑的。穿过 $N$ 的大圆给出正则化的径向碰撞—弹出轨道。在固定负能量下，它们是 $L=0$ 的退化椭圆，而不是零能量的抛物线分支。

= 从大圆到 Kepler 轨道

补全后的球面图景明确给出了归一化的 Kepler 解。一条单位速大圆由 $RR^4$ 中的一对正交单位向量确定。重新选取参数原点，使得 $psi=0$ 对应近心点，并在轨道平面内选取正交单位向量 $e_1,e_2 in RR^3$。对于 $0 <= e < 1$，写作
$
        xi_0 (psi) & = e cos psi, \
   xi_(perp) (psi) & = e_1 sin psi
                     - sqrt(1-e^2) e_2 cos psi, \
       eta_0 (psi) & = -e sin psi, \
  eta_(perp) (psi) & = e_1 cos psi
                     + sqrt(1-e^2) e_2 sin psi.
$
这里 $xi(psi) in SS^3$，$eta=xi'$，而 $psi$ 是大圆的角参数。球极投影的余切提升给出
$
  x
  = frac(xi_(perp), 1-xi_0),
  quad
  y
  = (1-xi_0) eta_(perp)
  + xi_(perp) eta_0.
$
利用 $q=y$ 和 $p=-x$，我们重新得到
$
  q(psi) & = (cos psi-e)e_1
           + sqrt(1-e^2) sin psi e_2, \
  p(psi) & = frac(
             -sin psi e_1
             + sqrt(1-e^2) cos psi e_2,
             1-e cos psi
           ).
$
特别地，
$
  norm(q(psi)) = 1-e cos psi,
  quad
  frac(1, 2) norm(p(psi))^2
  - frac(1, norm(q(psi)))
  = -frac(1, 2).
$
从位置中消去 $psi$，得到
$
  (q dot e_1 + e)^2
  + frac((q dot e_2)^2, 1-e^2)
  = 1.
$
这是一个半长轴为 $1$、偏心率为 $e$ 的椭圆，力心位于它的一个焦点上。从几何上看，$e$ 也度量了相应大圆与北极的接近程度：由于 $xi_0=e cos psi$，若以 $d$ 表示相应大圆同北极 $N$ 之间的最小球面距离，便有 $e=cos d$。圆轨道对应 $e=0$，而碰撞极限 $e=1$ 则是一条穿过 $N$ 的大圆。

由于 $dif psi=dif s$，Sundman 关系变为
$
  dif t
  = norm(q(psi)) dif psi
  = (1-e cos psi) dif psi.
$
从近心点开始积分，得到
$
  t-tau = psi-e sin psi.
$
因此，大圆的角参数、正则化时间与偏近点角是同一个变量，至多相差一个加法常数。恢复质量 $m$、耦合常数 $kappa$ 与半长轴 $a$ 后，解变为
$
  q(psi)
  = a(cos psi-e)e_1
  + a sqrt(1-e^2) sin psi e_2,
$
同时 Kepler 方程为
$
  sqrt(frac(kappa, m a^3)) (t-tau)
  = psi-e sin psi.
$
由归一化能量面的缩放便可以进一步恢复每一个固定负能量分支。

至此，我们从三维球面上的测地线出发，重新得到了 Kepler 问题的负能量分支，并完成了它的求解。
