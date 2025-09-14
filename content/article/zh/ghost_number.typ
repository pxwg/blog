#import "../../../typ/templates/blog.typ": *
#let title = "鬼数反常、Riemann-Roch 定理与顶点算子代数"
#show: main.with(
  title: title,
  desc: [bc 鬼系统中的鬼数反常可视为 Riemann-Roch 定理的体现],
  date: "2025-09-14",
  tags: (
    blog-tags.physics,
    blog-tags.quantum-field,
  ),
)

#translation-disclaimer(
  original-path: "ghost_number",
  lang: "zh",
)

= 引言：球面内的磁单极子

考虑球面$bb(S)^(2)$内的磁单极子，不存在全局良定义的规范联络$A$。需要利用开覆盖${U_(i)}$覆盖$bb(S)^(2)$，在各开集上定义$A_(i) in Omega^(1)(U_(i))$（在选定参考联络后），并通过转移函数${f_("ij")}$得到全局$U(1)$联络。

对$bb(S)^(2)$的情形，最简单的开覆盖选择是两个半球拼接，两开集的交为圆周$bb(S)^(1)$。可证明联络可写为：
$
  A(theta, phi) = cases(
    frac(1, 2) (1-cos theta) dif phi \, theta in (0, pi/2),
    frac(1, 2)(-1 - cos theta) dif phi \, theta in (pi/2, pi)
  ),
$
对应的规范曲率为$F = frac(1, 2) dif S$，转移函数为$upright(e)^(upright(i) phi): A |-> A + dif phi$。通量计算为：
$
  "Flux" = integral_(bb(S)^(2)) F = integral_(U_(1)) dif A + integral_(U_(2)) dif A = integral_(partial U_(1)) A + integral_(partial U_(2)) A = integral_(bb(S)^(1)) dif phi in ZZ.
$

= 鬼系统与鬼数流

考虑共形权重为$(lambda, 0)$和$(1 - lambda, 0)$的鬼系统在黎曼曲面$X$上的作用量：
$
  S = frac(1, 2pi) integral_(X) b overline(diff) c,
$
其中$b in Gamma(X, L^(times.circle lambda))$, $c in Gamma(X, K times.circle L^(- times.circle lambda))$，$L$为全纯线丛，$K$为典范丛。能量 - 动量张量为
$
  T(z) = - lambda :b diff c: + (1-lambda) : diff b c :,
$
$U(1)$流为：
$
  J(z) = :b c: := lim_(w -> z) b(w) c(z) - frac(dif z, w - z),
$
流的 OPE 为：
$
  T(z)J(w) = frac(1 - 2 lambda, (z - w)^(3)) dif z + frac(J(w), (z-w)^(2)) + frac(diff_(z) J(w), z- w) + :T(z)J(w):,
$
表明在共形变换$z |-> w$下流的变换：
$
  J(w) = J'(z) + frac(1-2 lambda, 2) diff (ln diff_(z) w),
$
故$J(w)$不是初级场。守恒量可形式上写为$overline(partial) J(z) = 0$。此式在各开集$U_(i)$上成立，但考虑场论的全局结构时需要更精确的表述。

将开集粘合成一维复流形时，满足$diff_(z) f(p) != 0$的全纯函数$f$作为转移函数（即共形变换$z |-> w$）将起作用。回忆引言中的讨论，$overline(partial) J$在$X$上的积分应表述为通过共形变换粘合开覆盖的积分：
$
  integral_(X) overline(diff) J := sum_(i) integral_(U_(i)) overline(diff) J(z_(i)).
$

先考虑简单例子$X = bb(S)^(2)$：转移函数为$omega = frac(1, z)$，积分计算为：
$
  integral_(X) overline(diff) J = integral_(bb(S)^(1)) (1-2lambda) frac(dif w, w) = 2pi upright(i) (1 - 2lambda).
$
转换为更熟悉的形式：由$dif^(2) sigma = 2 upright(i) dif z dif overline(z)$和$J(z) = j(z) dif z$得：
$
  integral_(X) dif^(2) sigma thin overline(partial)_(z) j(z) = pi(1-2 lambda).
$

一般情形下，$J(z)$的转移函数由$f_(i j): z_(j) |-> f_(i j)(z_(i))$给出。对$X$的好覆盖${U_(i)}$，两两相交部分的转移函数为$f_("ij")$, $f_("jk")$, $f_("ki")$，而三重交上的转移函数将会给出对三个开集上的积分结果，其表达式为：
$
  integral_(U_("ij")) f_("ij") + integral_(U_("jk")) f_("jk") + integral_(U_("ki")) f_("ki") = integral_(U_("ijk")) (f_("ij") + f_("jk") + f_("ki")) = 2pi upright(i) n_("ijk").
$
可验证该积分为$2 pi upright(i)$的整数倍，且在$f_("ij") |-> f_("ij") + phi_("i") - phi_("j") := f_("ij") + delta phi_("ij")$变换下不变，即整数$n_("ijk")$的等价类属于$H^(2)(X, ZZ)$。因此，$overline(partial) J$在黎曼曲面$X$上的积分为：
$
  integral_(X) overline(diff) J = (1 - 2 lambda) pi upright(i) c_(1)(L),
$
其中$c_(1)(L) in H^(2)(X, ZZ)$为线丛$K$的第一陈类。代入$c_(1)(L) = Chi(L) = 2 - 2g$得：
$
  integral_(X) dif^(2) sigma thin overline(partial)_(z) j(z) = pi frac(1 - 2 lambda, 2) Chi(L).
$

= 零模、Riemann-Roch 与指标

$b c$鬼系统的零模方程为：
$
  overline(diff) c = 0, quad overline(diff) b = 0.
$
记$b$, $c$场的零模数分别为$B$和$C$。易识别$C = ker(overline(diff)_(K times.circle L^(-lambda)))$, $B = ker(overline(diff)_(L^(lambda)))$，故零模差为：
$
  C - B = dim(H^(0)(X, cal(O)(K times.circle L^(-lambda)))) - dim(H^(0)(X, cal(O)(L^(lambda)))),
$
利用 Serre 对偶$H^(i)(X, cal(O)(K times.circle L^(-lambda))) approx H^(n-i)(X, cal(O)(L^(lambda)))^(or)$（$n=1$）得：
$
  C - B = dim(H^(1)(X, cal(O)(L^(lambda)))) - dim(H^(0)(X, cal(O)(L^(lambda)))) := h^(1)(X, cal(O)(L^(lambda))) - h^(0)(X, cal(O)(L^(lambda))),
$
故椭圆算子$overline(diff)$的指标可重述为：
$
  "ind"(overline(diff)) = B - C.
$
即零模差为$overline(diff)$算子在线丛$L^(lambda)$截面空间上的指标。零模差也可表示为鬼数流的荷，即$U(1)$生成元：
$
  Q := integral_(X) (c frac(delta, delta c) + b frac(delta, delta b)) = frac(1, pi)integral_(X) overline(diff) J(z) = frac(2 upright(i), pi) integral_(X) dif^(2) z thin overline(diff)_(z) j(z),
$
负号源于$b$场的费米性。

结合前文结果，可得鬼数与流形 Euler 示性数的关系：
$
  Q = (1 - 2 lambda) Chi(L) = "deg"(L^(lambda))+ 1- g,
$
由鬼数与指标的等价性，最终得到椭圆算子$overline(partial)$的指标定理：
$
  "ind"(overline(partial)_(L^(lambda))) = (1 - 2 lambda) Chi(L) = "deg"(L^(lambda)) + 1 - g,
$
利用指标表达式$"ind"(overline(diff)) = h^(0)(X, cal(O)(L^(lambda))) - h^(1)(X, cal(O)(L^(lambda)))$，此即 Riemann-Roch 定理：
$
  h^(0)(X, cal(O)(L^(lambda))) - h^(1)(X, cal(O)(L^(lambda))) = "deg"(L^(lambda)) + 1 - g.
$
通过线丛 - 除子对应，可转换为教科书常见的 Riemann-Roch 定理形式。
