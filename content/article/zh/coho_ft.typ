#import "../../../typ/templates/blog.typ": *
#let title = "上同调场论"
#show: main-zh.with(
  title: title,
  desc: [在 $L_oo$ BV 构造下对上同调场论的简要介绍，这是 Witten 最初考虑 Donaldson 理论的数学基础（关于 L-infinity BV 的第一部分已完成）。],
  date: "2025-08-17",
  tags: (
    blog-tags.physics,
    blog-tags.quantum-field,
  ),
  lang: "zh",
  translationKey: "coho_ft",
)

*警告*: Typst 的 html 输出为实验性功能，可能无法如预期工作。例如，非文件/非 URL 链接可能无法正常工作。

= $L_oo$ BV 构造
在局部上，我们可以将 BV 代数与带有循环结构 $omega$ 的 $L_oo$ 代数 $( V , {mu_i}_n )$ 进行识别，其次数为 $0$ 的形式可视为物理场，$mu_1$ 可解释为自由场运动方程产生的线性算子，更高阶的括号 $mu_n$ 需要满足同伦雅可比恒等式，并使经典运动方程成为 MC 方程。

循环结构可视为局部移位 $-1$ 辛结构，即非退化配对 $omega : V times.circle V arrow.r bb(R)$，其在 Koszul 符号规则下满足循环性条件
$
  omega ( mu_n ( a_1 , dots.h , a_n ) , a_(n + 1) ) = ( - 1 )^(lr(|a_0|) ( lr(|a_1|) + dots.h + lr(|a_n|) )) omega ( a_(n + 1) , mu_n ( a_1 , dots.h , a_n ) ) ,
$
其中 $lr(|a_i|)$ 是元素 $a_i$ 的次数。

一个有用的构造是将所有（降阶的）场收集到一个“超场” $Phi$ 中，这意味着我们实质上在 $S^c V = xor.big_i V^(and n)$ 上工作，遵循 Koszul 符号规则，而括号可定义为 $B = mu_1 + dots.h.c$，满足 $B^2 = 0$，即 $S^c V$ 上的余导子。

$B$ 的作用如下理解：考虑投影 $pi_n : S^c V arrow.r V^(and n)$，则 $b_n$ 可定义为 $pi_1 B$ 在 $V^(and n)$ 上的部分。同伦雅可比恒等式可识别为 $B^2 = 0$。

利用超场 $Phi$ 和局部移位 $-1$ 辛配对 $omega$，BV 作用量可定义为
$
  S = omega (pi_1 B times.circle I) : S^c V times.circle S^c V arrow.r bb(R) ,
$
$
  Phi mapsto sum_i frac(1, ( i + 1 ) !) omega (Phi , mu_i ( Phi , dots.h.c , Phi )) ,
$
其欧拉 - 拉格朗日运动方程在投影到 $V$ 后，确实就是 $L_oo$ 代数 $V$ 上的 MC 方程。

我们以 $d$ 维 Yang-Mills 理论为例，其“物理”场为联络
$A in Omega_(frak(g))^1 ( X ) [ 1 ]$，其 $L_oo$ 次数为 $0$。需要引入幽灵场
$psi in Omega_(frak(g))^0 ( X ) [ 1 ]$，反场
$A^(star) in Omega_(frak(g))^(d - 1) ( X ) [ 1 ]$ 以及反幽灵场
$psi^(star) in Omega_(frak(g))^d ( X ) [ 1 ]$。考虑线性化的 Yang-Mills 方程，可以得到如下 $L_oo$ 代数结构：
$
  & mu_1 (psi_1) := dif psi_1 , quad
  mu_1(A_1) := dif star A_1 , quad
  mu_1(A_1^(star)) := dif A_1^star , quad mu_1(psi^(star)_1) = 0 ,\
  & mu_2(psi_1 , psi_2) := [ psi_1 , psi_2 ] , quad
  mu_2(psi_1 , A_1) := [ psi_1 , A_1 ] , quad \
  & mu_2(psi_1 , A_2) := [psi_1, A_2^(star)] , quad
  mu_2(psi_1 , psi_2^(star)) := [psi_1, psi_2^(star)] , quad \
  & mu_2(A_1 , A_2^(star)) := [A_1, A_2^(star)] , quad
  mu_2 (A_1 , A_2) = dif star [A_1 , A_2] + [A_1, star dif A_2] + [A_2, star dif A_1] , \
  & mu_3(A_1, A_2, A_3) = [A_1, star [A_2, A_3]] + [A_2, star [A_1, A_3]] + [A_3, star [A_1, A_2]] ,
$
非平凡的辛形式 $omega$ 定义为：
$
  omega ( A , A^(star) ) = integral_X angle.l A , A^star angle.r , quad omega ( psi , psi^(star) ) = integral_X angle.l psi , psi^(star) angle.r ,
$
其中 $angle.l dot.op , dot.op angle.r$ 是李代数 $frak(g)$ 上的 Killing 形式。

特别地，在链级别，$mu_1$ 部分会诱导一个上链复形
$
  cal(E)_(upright(Y M))^(upright(B V)) := {Omega_(frak(g))^0 ( X ) arrow.r.long^(mu_1 = dif) Omega_(frak(g))^1 ( X ) arrow.r.long^(mu_1 = dif star dif) Omega_(frak(g))^(d - 1) ( X ) arrow.r.long^(mu_1 = dif) Omega_(frak(g))^d ( X )} ,
$
满足 $mu_1^2 = 0$，作用量可写为
$
  S [ A , A^(star) , psi , psi^(star) ] = integral_X [1 / 2 angle.l F , star.op F angle.r - angle.l A^(star) , dif_A psi angle.r + 1 / 2 angle.l psi^(star) , [ psi , psi ] angle.r ] ,
$
其中 $dif_A = dif + [ A , dot.op ]$ 是由规范联络 $A$ 诱导的协变导数。若记 $mu_1$ 为上同调向量场 $Q$，BV 作用量可写为
$
  S [ cal(A) ] = integral_X [1 / 2 angle.l cal(A) , Q cal(A) angle.r + frac(1, 3 !) angle.l cal(A) , mu_2 ( cal(A) , cal(A) ) angle.r + frac(1, 4 !) angle.l cal(A) , mu_3 ( cal(A) , cal(A) , cal(A) ) angle.r ] ,
$
这被称为同伦 Chern-Simons 作用量，其中 $cal(A)$ 是超场。

另一个重要例子是三维的 Chern-Simons 理论，其 $L_oo$ 代数结构为：
$ & mu_1 ( psi_1 ) := dif psi_1 , quad mu_1 ( A_1 ) := dif A_1 , quad mu_1 ( A_1^(star) ) := dif A_1^(star) , \
& mu_2 ( psi_1 , psi_2 ) := [ psi_1 , psi_2 ] , quad mu_2 ( psi_1 , A_1 ) := [ psi_1 , A_1 ] , \
& mu_2 ( psi_1 , A_2 ) := [ psi_1 , A_2^(star) ] , quad mu_2 ( psi_1 , psi_2^(star) ) := [ psi_1 , psi_2^(star) ] , \
& mu_2 ( A_1 , A_2^(star) ) := [ A_1 , A_2^(star) ] , quad mu_2 ( A_1 , A_2 ) = [ A_1 , A_2 ] $，非平凡的辛形式 $omega$ 定义同上。作用量可写为
$
  "CS" [ cal(A) ] = integral_X [1 / 2 angle.l cal(A) , dif cal(A) angle.r + 1 / 6 angle.l cal(A) , [cal(A) , cal(A)] angle.r ] ,
$
其中 $cal(A) = A + A^(star) + psi + psi^(star)$ 是超场。可以直接看到，这个作用量就是 Chern-Simons 作用量，只是用超场 $cal(A)$ 替换了原本（无 BV）场 $A$ #footnote[实际上，如果理论关联到平坦丛，即一阶经典运动方程为 $dif A = 0$，
  总可以用同样的机制 $A arrow.r cal(A)$ 得到 BV 作用量。];。

= 四维上同调场论：Witten 的原始构造
<four-dimensional-cohomological-field-theory-wittens-original-consideration>
现在我们来考虑 Witten 所构造的所谓
#emph[上同调场论]，它将导向 Donaldson 理论。考虑四维流形 $M$ 上的自对偶 Yang-Mills 方程：
$ F = star.op F , $<eq:self_dual_yang_mills_instanton>
Witten 构造的目标是构造一个上同调场论，其
解或模空间就是
#link(<eq:self_dual_yang_mills_instanton>)[\[eq:self\_dual\_yang\_mills\_instanton\]];。

== 可观测量
<observables>
BRST 对称性定义为：
$
  [Q , A] = psi , quad [Q , psi] = - dif_A phi.alt , quad [Q , phi.alt] = 0 ,
$<eq:brst_symmetry_1>
其中 $A^a$ 取值于李代数 $frak(g)$，幽灵 $psi^a$ 是取值于 $frak(g)$ 的费米场，交换场 $phi.alt^a$ 是规范变换的生成元，它将通过
$[ Q , [ Q , A ] ] = - dif_A phi.alt$ 产生规范变换。

可以直接验证 $Q^2 = 1 / 2 [ Q , Q ] = 0$（在规范变换意义下），括号是否反对称由 Koszul 符号规则决定。这样的构造可视为 $G$ 等变上同调的 Cartan 模型。

幽灵数分别为 $U = 0 , 1 , 2$，$A^a , psi^a$ 的微分形式次数为 $1$，$phi.alt^a$ 的次数为 $0$。

现在我们用 BRST 对称性
#link(<eq:brst_symmetry_1>)[\[eq:brst\_symmetry\_1\]] 构造可观测量，这实际上只依赖于时空流形 $M$ 的同调类。

首先，考虑 #emph[零阶] 可观测量
$cal(O)_(k,0)(x) = tr phi^(k)(x)$，它是 $M$ 上的局部函数且 BRST 不变，即
$[Q , cal(O)_(k , 0) ( x )] = 0$。

接下来考虑
$
  dif cal(O)_(k, 0) = k tr phi^(k - 1) dif_A phi = [ Q, - tr phi^(k - 1) psi ] ,
$
因此 $dif cal(O)_(k , 1)$ 是 BRST 恰当的可观测量，即它在全局上是常数加上一个 BRST 恰当项。
进一步定义 $cal(O)_(k,1) = - tr phi^(k-1) psi$
它是 $M$ 上的一阶微分形式，有
$
  dif cal(O)_(k,1) = - k (k-1) tr phi^(k-2) psi dif_A phi - k tr phi^(k-1) dif_A psi = [ Q, cal(O)_(k, 2) ] ,
$
其中 $cal(O)_(k,2) = -k tr ((k-1) phi^(k-2)[psi, psi] + phi F )$。用上述机制，可以递归构造第 $n$ 阶可观测量：
$
  dif cal(O)_(k , 0) = & [Q , cal(O)_(k , 1)] , quad dif cal(O)_(k , 1) = [Q , cal(O)_(k , 2)] , \
  dif cal(O)_(k , 2) = & [Q , cal(O)_(k , 3)] , quad dif cal(O)_(k , 3) = [Q , cal(O)_(k , 4)] , \
  dif cal(O)_(k , 4) = & 0 ,
$
这就是所谓的
#emph[拓扑后裔方程]。考虑 $M$ 的 $n$ 维闭子流形 $Y subset M$，可引入如下可观测量：
$ W_k ( Y_n ) = integral_(Y_n) cal(O)_(k , n) , $ 这些都是 BRST 闭合的，只依赖于流形 $M$ 的 $n$ 阶同调类，
因为
$ [ Q , W_k ( Y_n ) ] = integral_(Y_n) dif cal(O)_(k , n) = 0 , $
若 $Y_n$ 是平凡同调类，即 $Y_n = partial X_(n + 1)$，
则
$
  W_k ( partial X_(n + 1) ) = integral_(X_(n + 1)) dif cal(O)_(k , n) = integral_(X_(n + 1)) [Q , cal(O)_(k , n + 1)] = [ Q , W_(k , n + 1) ] = 0 .
$
我们构造的是一族只依赖于流形 $M$ 的同调类 $H_bullet ( M )$ 的 BRST 不变量 $W_k ( Y_n )$。

更一般的场可以加入 BRST 对称性，这称为反场，从而将带有 BRST 对称性的理论扩展为 BV 场论。在 Witten 的构造中，这意味着加入场 $( lambda , eta )$，其幽灵数分别为 $( - 2 , - 1 )$，
其中 $lambda$ 具有与 $phi.alt$ 相同的量子数#footnote[即它作为规范群 $G$ 的李代数变换。]，$eta$ 是 $lambda$ 的伴侣。还引入 $( chi , H )$，其幽灵数为 $( - 1 , 0 )$，$H$ 是 $chi$ 的伴侣，$chi$ 具有与运动方程相同的量子数但自旋统计不同。

新加场的 BRST 对称性如下：
$ [Q , lambda] = eta , quad [Q , eta] = [ lambda , phi.alt ] , $
$ [Q , chi] = & H , quad [Q , H] = [ chi , phi.alt ] , $
这些可以直接由原始 BRST 对称性
#link(<eq:brst_symmetry_1>)[[eq:brst_symmetry_1]] 通过加入新场及其 BRST 变换得到。

== 拉格朗日量
<lagrangian>
= 四维上同调场论：与 $L_oo$ BV 构造的关系
<four-dimensional-cohomological-field-theory-relation-to-l_infty-bv-construction>

= 二维上同调场论：Chiral 场论及其形变
