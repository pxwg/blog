#import "../../../typ/templates/blog.typ": *
#import "../../../typ/packages/typst-fletcher.typ": *
#import "../../../typ/packages/physica.typ": *
#let title = "Čech-de Rham 复形作为导出全局截面的模型"
#show: main.with(
  title: title,
  desc: [我们使用导出函子和层上同调的工具来理解在之前的博客中介绍的 Čech-de Rham 复形，它是 Deligne 复形的导出全局截面的一个模型。],
  date: "2025-10-15",
  tags: (
    blog-tags.math,
    blog-tags.physics,
    blog-tags.topology,
    blog-tags.abstract-nonsense,
  ),
  lang: "zh",
  translationKey: "cech_hyper",
  llm-translated: true,
)
#let target = get-target()

#let u1_grav = "../u1_grav/"
#let check(it) = math.attach(it, t: math.arrowhead.b)
#let tot = math.upright("Tot")
#let cech = math.upright("Čech")
#let Cech = "Čech"
#let Hom = math.upright("Hom")
#let Ext = math.upright("Ext")
#let Tor = math.upright("Tor")

在#link("../u1_grav/")[之前的博客]中，我们介绍了 Čech-de Rham 复形来计算 $b c$ 共形场论中的反常 $U(1)$ 荷。
我们从经典 BV 形式中获得的一个（粗略的）直觉是，导出对象可以通过为原始对象添加一些额外的自由度（反场）来获得，这或许可以被解释为原始对象的某种_分解_或_导出对象_。

同样的想法也适用于我们在#link(u1_grav)[之前的博客]中介绍的 Čech-de Rham 复形，它在原始的 de Rham 复形上引入了一个额外的次数（Čech 次数）。

因此，很自然地会提出以下问题：
- 首先，我们能否使用导出函子来理解我们之前介绍的 Čech-de Rham 复形？
- 其次，我们能否使用 $b c$ 共形场论的 BV 形式来捕捉我们之前讨论过的非平凡拓扑信息？
在这篇博客中，我们将探讨第一个问题。

= Derived (Something) 速成课

我们不会对导出函子进行全面的介绍，而只会简要回顾一下本博客中将要用到的概念。
若想全面了解，请参阅 Gelfand 和 Manin 的《同调代数方法》（_Methods of Homological Algebra_）。


== 导出范畴

给定一个阿贝尔范畴 $cal(A)$，我们可以通过以下方式构造其导出范畴 $D(cal(A))$：
- 将“坏”对象替换为某些“好”对象。
- 将“坏”态射替换为“好”态射。
所以，问题在于，什么是“好”的对象和“好”的态射？

Gelfand 和 Manin 的书中有一些例子：
- 朴素的张量积是“坏”的（它只是右正合的，而非正合的），我们需要使用_平坦分解_来正确地定义它，即，给定 $X, Y in cal(A)$，“好”的张量积应定义为：
  $
    X times.circle^(L)Y := P^(bullet) times.circle Y,
  $
  其中 $P^(bullet)$ 是 $X$ 的一个平坦分解。
  根据平坦分解的定义，函子 $- times.circle Y$ 在 $P^(bullet)$ 上是正合的，因此导出的张量积（取同调后可等同于 $Tor_(i)(-,-)$）是“好”的。
  也就是说，给定一个短正合列 $0 -> A -> B -> C ->0$，序列：
  $
    ... -> Tor_(i)(X, A) -> Tor_(i)(X, B) -> Tor_(i)(X, C) -> ...
  $
  是正合的。
- 朴素的 Hom 函子是“坏”的（它只是左正合的，而非正合的），我们需要使用_内射分解_来正确地定义它，即，给定 $X, Y in cal(A)$，“好”的 Hom 函子应定义为：
  $
    R Hom(X, Y) := Hom(X, I^(bullet)),
  $
  其中 $I^(bullet)$ 是 $Y$ 的一个内射分解。
  根据内射分解的定义，函子 $Hom(X, -)$ 在 $I^(bullet)$ 上是正合的，因此导出的 Hom 函子（取上同调后可等同于 $Ext^(i)(-,-)$）是“好”的。
  也就是说，给定一个短正合列 $0 -> A -> B -> C ->0$，序列：
  $
    ... -> Ext^(i)(X, Y) -> Ext^(i+1)(X, Y) -> ...
  $
  是正合的。

以上的教训是，为了定义一些好的函子，我们需要将原始对象替换为某些“好”的对象（平坦或内射分解）。
这暗示了我们将一个对象与和它拟同构的其他对象等同起来。

然而，与链复形范畴 $"Ch"(cal(A))$（它将链同伦的两个对象视为等同）不同，要获得一个拟同构的“逆”映射是相当困难的。
通过使用一种称为_范畴的局部化_的技术，我们可以形式上地将 $"Ch"^(bullet)(cal(A))$ 中所有的拟同构都反转，从而得到导出范畴 $D(cal(A))$。
因此，我们发现了导出范畴的第一个性质：
- 存在一个函子：
  $
    Q: "Ch"^(bullet)(cal(A)) -> D(cal(A)),
  $
  当 $f$ 是 $"Ch"(cal(A))$ 中的一个拟同构时，$Q(f)$ 是 $D(cal(A))$ 中的一个同构。
这样的函子是万有的，即，对于任何将拟同构映为同构的函子 $F: "Ch"(cal(A)) -> cal(B)$，都存在一个唯一的函子 $F': D(cal(A)) -> cal(B)$ 使得 $F = F' o Q$。

现在我们回到寻找“好”态射的问题。
在（上）同调的层面上，正合列是一个“好”的对象。
如果想在链复形的层面上找到这样一个“好”的对象，我们会发现_正合三角_，其定义为：
$
  A -> B -> C -> A[1].
$
当某些“好”的函子作用在正合三角上时，其像仍然是一个正合三角。
此外，如果对一个正合三角取（上）同调，将会得到一个（长）正合列，这就回到了最初在（上）同调层面上的讨论（关于这一事实的证明，请看#link("https://mathoverflow.net/questions/257495/what-is-a-triangle")[这里]）。
因此，保持正合三角的态射就是“好”的态射。

例如，导出 $Hom$ 函子 $R Hom(-, -)$ 就保持正合三角。

== 导出全局截面

现在我们来考虑一个导出函子的重要例子，即全局截面函子 $Gamma(X, -)$ 的_导出全局截面_ $R^(bullet) Gamma(X, -)$，这将在后续的讨论中使用。

原始的全局截面函子 $Gamma(X, -)$ 是一个典型的“坏”函子，它是左正合的但非正合的。
为了定义它的导出函子，我们需要将原始的层替换为其内射分解。
注意到内射分解是 $Gamma$-非循环的，导出全局截面可以简单地定义为：
$
  R Gamma(X, cal(F)) := Gamma(X, cal(I)^(bullet)),
$
它是正合的，并且在取 $0$ 阶上同调时回到原始的全局截面函子。

== 关于分解的一些注记

在正文中，我们声称导出函子“恢复”了其朴素对应物所失去的正合性。
这个性质并非一个公理，而是同调代数中一个强大机制的直接结果。

分解的选择（内射 vs. 投射/平坦）是精确地根据我们想要修正的函子类型来定制的。在这里，我们展示了为什么这套机制能够奏效的一般性论证。

关键在于，内射/平坦（投射）分解将会恢复左/右正合函子所失去的正合性。

#custom-block(
  [
    设 $F: cal(A) -> cal(B)$ 是一个_左正合函子_。给定一个短正合列 $0 -> A -> B -> C -> 0$，我们知道对其应用 $F$ 会得到一个序列 $0 -> F(A) -> F(B) -> F(C)$，这个序列是正合的，但在 $F(C)$ 处可能不再正合。右导出函子 $R^i F$ 就是为了度量和修正这种失效而设计的。

    其基石是#link("https://en.wikipedia.org/wiki/Horseshoe_lemma")[马蹄引理]（Horseshoe Lemma），它允许我们将整个短正合列提升到分解的层面上。
    我们可以为 $A$、$B$ 和 $C$ 找到_内射分解_ $cal(I)_A^(bullet)$、$cal(I)_B^(bullet)$ 和 $cal(I)_C^(bullet)$，它们可以组合成一个_上链复形的短正合列_：
    $
      0 -> cal(I)_A^(bullet) -> cal(I)_B^(bullet) -> cal(I)_C^(bullet) -> 0.
    $
    因为每个 $cal(I)^n$ 都是内射的，所以这个序列不仅是正合的，而且在每个次数上都是_分裂正合_的。

    现在，我们将左正合函子 $F$ 应用于这个复形序列。因为任何可加函子都保持分裂正合列，所以 $F$ 将这个分解序列映为另一个新的_上链复形的短正合列_：
    $
      0 -> F(cal(I)_A^(bullet)) -> F(cal(I)_B^(bullet)) -> F(cal(I)_C^(bullet)) -> 0.
    $
    也就是说，分解的内射性质确保了函子能够完美地保持其结构。

    同调代数的基本引理（#link("https://en.wikipedia.org/wiki/Zig-zag_lemma")[Z字形引理]）指出，任何上链复形的短正合列都会导出一个_上同调长正合列_。
    将该定理应用于上述序列，我们得到：
    $
      ... -> H^i (F(cal(I)_A^(bullet))) -> H^i (F(cal(I)_B^(bullet))) -> H^i (F(cal(I)_C^(bullet))) -> H^(i+1) (F(cal(I)_A^(bullet))) -> ...
    $
    根据右导出函子的定义，我们有 $R^i F(X) := H^i(F(cal(I)_X^(bullet)))$。
    代入后，我们就得到了 $F$ 的导出函子的标准长正合列。
    这展示了内射分解是如何系统地生成修复任何左正合函子所需的结构。
  ],
  title: "左正合函子的内射分解",
  collapsible: true,
  collapsed: true,
)

#custom-block(
  [
    对于右正合函子的论证是完全对偶的。设 $F: cal(A) -> cal(B)$ 是一个_右正合函子_。给定 $0 -> A -> B -> C -> 0$，序列 $F(A) -> F(B) -> F(C) -> 0$ 是正合的，但在 $F(A)$ 处可能失效。左导出函子 $L_i F$ 修正了这一点。

    我们使用对偶的马蹄引理来找到_投射分解_ $cal(P)_A^(bullet)$、$cal(P)_B^(bullet)$ 和 $cal(P)_C^(bullet)$，它们构成一个_链复形的短正合列_：
    $
      0 -> cal(P)_A^(bullet) -> cal(P)_B^(bullet) -> cal(P)_C^(bullet) -> 0
    $
    因为每个 $cal(P)_n$ 都是投射的，这个序列在每个次数上都是_分裂正合_的。（对于像张量积这样的许多右正合函子，使用更广泛的_平坦分解_类就足够了，而且通常更方便）。

    可加函子保持分裂正合列。应用 $F$ 会得到另一个_链复形的短正合列_：
    $
      0 -> F(cal(P)_A^(bullet)) -> F(cal(P)_B^(bullet)) -> F(cal(P)_C^(bullet)) -> 0
    $

    长正合列定理的同调版本给出了一个_同调长正合列_：
    $
      ... -> H_i (F(cal(P)_A^(bullet))) -> H_i (F(cal(P)_B^(bullet))) -> H_i (F(cal(P)_C^(bullet))) -> H_(i-1) (F(cal(P)_A^(bullet))) -> ...
    $
    根据定义，$L_i F(X) := H_i (F(cal(P)_X^(bullet)))$，所以这正是 $F$ 的左导出函子的长正合列。
    这是投射/平坦分解修复右正合函子的通用机制。
  ],
  title: "右正合函子的投射/平坦分解",
  collapsed: true,
  collapsible: true,
)

= 复形层的 Čech 复形

在本节中，我们将遵循#link("https://stacks.math.columbia.edu/tag/01FP")[stack project]中的处理方式，回顾有下界复形层的 Čech 复形的构造。

考虑一个环空间 $(X, cal(O)_(X))$，其上有一个阿贝尔群预层的有下界复形 $cal(K)^(bullet)$。

#remark(
  [
    在#link("../u1_grav")[之前的博客]中，$X$ 是一个黎曼面，$cal(O)_(X)$ 是光滑函数层，而 $cal(K)^(bullet)$ 是微分形式层复形 $Omega^(bullet)$，其中 $-1$ 次部分被替换为圆周群（$U(1)$）值的算子函数层 $underline(U(1)) := C^(oo)(-, U(1))$：
    $
      cal(K)^(bullet) := [... -> 0 -> C^(oo)(-, U(1)) ->^(d log) Omega^(1) ->^(d) Omega^(2) -> ... ->^(d) Omega^(n) -> 0 -> ...],
    $
    这个复形也被称为#link("https://ncatlab.org/nlab/show/Deligne+cohomology#TheSmoothDeligneComplex")[_Deligne 复形_]。

    更准确地说，我们在之前博客中真正考虑的是由短正合列导出的复形：
    $
      0 -> ZZ arrow.hook RR arrow.long^(exp(2pi i-)) U(1) -> 0,
    $
    它与上面定义的复形是弱等价的。
    在导出范畴中，它们是同构的。
  ],
)

我们可以使用 Čech 上循环来计算上同调 $H^(n)(X, cal(K)^(bullet))$。
具体来说，我们考虑 $X$ 的一个开覆盖 $cal(U) = {U_i}_{i in I}$，并构造一个 Čech 复形
$
  cal(C)^(bullet)_(upright("Čech"))(cal(U), cal(K)^(bullet)),
$
这是一个双重复形。
其关联的全复形是一个复形，其 $n$ 次部分为：
$
  "Tot"^(n) (cal(C)^(bullet)_(upright("Čech"))(cal(U), cal(K)^(bullet))) := plus.big_(p + q = n) product_(i_0, ..., i_(p)) cal(K)^(q)(U_(i_0,...,i_(p))),
$
其中我们记 $U_(i_(0), ..., i_(p)) := U_(i_0) inter ... inter U_(i_p)$，并规定 $p$ 个交集的次数为 $p-1$。
考虑一个位于 $cal(K)^(q)(U_(i_0,...,i_(p)))$ 中的元素 $alpha$，其中 $n = p + q$，全复形上的微分由下式给出：
$
  d(alpha)_(i_0,...,i_(p+1)) = sum_(j=0)^(p+1) (-1)^j alpha_(i_0,..., hat(i)_(j),...,i_(p+1)) + (-1)^(p+1) d_(cal(K))(alpha)_(i_0,...,i_(p)),
$
其中 $d_(cal(K))$ 是层复形 $cal(K)^(bullet)$ 的微分，而表达式 $alpha_(i_0, ..., hat(i)_(j),...,i_(p+1))$ 表示将 $alpha_(i_0,...,hat(i)_(j)...,i_(p))$ 限制到 $U_(i_0,...,i_(p+1))$ 上。
因此，全复形可以定义为：
$
  upright("Tot")(cal(C)_("Čech")^(bullet)(cal(U), cal(K)^(bullet))) := (plus.big_(n) "Tot"^(n)(cal(C)_("Čech")^(bullet)(cal(U), cal(K)^(bullet))), d),
$
其中 $d$ 和 $"Tot"^(n)$ 如上定义。

#claim(
  [
    - $"Tot"(cal(C)^(bullet)_("Čech")(cal(U), cal(K)^(bullet)))$ 的构造对 $cal(K)^(bullet)$ 是_函子性_的。
    - 变换：$ Gamma(X, cal(K)^(bullet)) -> "Tot"(cal(C)^(bullet)_("Čech")(cal(U), cal(K)^(bullet))), $ 是_函子性_的，该变换将一个全局截面 $s in Gamma(X, cal(K)^(n))$ 映为一个元素 $alpha$，其中 $alpha_(i_0) = s|_(U_(i_0))$ 且当 $p >= 1$ 时 $alpha_(i_0,...,i_(p)) = 0$。
  ],
)

= Čech 复形作为导出全局截面的模型

现在是时候揭示 Čech-de Rham 复形构造背后的结构了。
结论是，Čech-de Rham 复形是层复形 $cal(K)^(bullet)$ 的导出全局截面 $R^(bullet) Gamma(X, cal(K)^(bullet))$ 的一个_模型_。
这里的“模型”意味着 Čech-de Rham 复形的上同调与 $R^(bullet) Gamma(X, cal(K)^(bullet))$ 同构。

在仓促得出这个结论之前，我们首先考虑一个更一般的情况，它对于拓扑空间 $X$ 上的任何有下界阿贝尔群层复形 $cal(K)^(bullet)$ 都成立（不限于 Čech-de Rham 复形）。

#theorem(
  [(参见 #link("https://stacks.math.columbia.edu/tag/08BN")[Stack Project]) 设 $(X, cal(O)_(X))$ 是一个环空间。
    设 $cal(U): X = union.big_(i in I) U_(i)$ 是 $X$ 的一个开覆盖。
    对于一个 $cal(O)_(X)$-模的有下界复形 $cal(K)^(bullet)$，存在一个典范映射：
    $
      "Tot"(cal(C)^(bullet)_(upright("Čech"))(cal(U), cal(K)^(bullet))) -> R Gamma(X, cal(K)^(bullet)),
    $
    该映射：
    - 对 $cal(K)^(bullet)$ 是函子性的。
    - 与之前定义的函子性映射 $Gamma(X, cal(K)^(bullet)) -> "Tot"(cal(C)^(bullet)_(upright("Čech"))(cal(U), cal(K)^(bullet)))$ 兼容。
    - 与开覆盖的加细兼容。
  ],
)

证明的思路是找到一个与 $cal(K)^(bullet)$ 拟同构的_内射层_复形 $cal(I)^(bullet)$，
$
  cal(K)^(bullet) -> cal(I)^(bullet),
$
然后导出截面就会下降为 $cal(I)^(bullet)$ 的全局截面。
$
  R Gamma(X, cal(K)^(bullet)) = Gamma(X, cal(I)^(bullet)).
$
因此，这个映射可以简单地通过将 Čech 复形的最低 Čech 次数部分“下降”到全局截面来构造，这其实就是 Čech 复形的增广映射。

总而言之，我们想要构造的映射是两个映射的复合：
$
  "Tot"(cal(C)_("Čech")^(bullet)(cal(U), cal(K)^(bullet))) -> "Tot"(cal(C)^(bullet)_(upright("Čech"))(cal(U), cal(I)^(bullet))) -> Gamma(X, cal(I)^(bullet)).
$
可以很自然地期望这个映射是函子性的，并与之前定义的函子性映射兼容。

#proof(
  [
    （我们遵循 #link("https://stacks.math.columbia.edu/tag/08BN")[Stack Project] 中的证明。）

    *步骤 1*：
    设 $cal(I)^(bullet)$ 是一个有下界的内射层复形，且存在一个拟同构 $cal(K)^(bullet) -> cal(I)^(bullet)$。
    根据导出函子的定义，我们有：
    $
      R Gamma(X, cal(K)^(bullet)) = Gamma(X, cal(I)^(bullet)).
    $
    *步骤 2*：
    我们分别对 $cal(I)^(bullet)$ 和 $cal(K)^(bullet)$ 应用 Čech 复形构造，得到一个双重复形的映射：
    $
      cal(C)^(bullet)_(upright("Čech"))(cal(U), cal(K)^(bullet)) -> cal(C)^(bullet)_(upright("Čech"))(cal(U), cal(I)^(bullet)).
    $
    由于 Čech 复形的构造是逐项的，并且在每个开集上是正合的，即上述映射导出了一个复形的映射：
    $
      "Tot"(cal(C)^(bullet)_(upright("Čech"))(cal(U), cal(K)^(bullet))) -> "Tot"(cal(C)^(bullet)_(upright("Čech"))(cal(U), cal(I)^(bullet))),
    $
    这是一个拟同构。

    *步骤 3*：
    现在我们只需要构造一个映射：
    $
      "Tot"(cal(C)^(bullet)_(upright("Čech"))(cal(U), cal(I)^(bullet))) -> Gamma(X, cal(I)^(bullet)).
    $
    // TODO: 在之前的博客中定义增广映射
    这样的映射可以通过双重复形 $cal(C)^(bullet)_(upright("Čech"))(cal(U), cal(I)^(bullet))$ 的增广来构造，它将一个元素 $alpha in cal(I)^(q)(U_(i_0,...,i_(p)))$ 映为：
    - 如果 $p >= 1$，则为 $0$。
    - 如果 $p = 0$，则为 $alpha in Gamma(X, cal(I)^(bullet))$。
    这样的映射是一个链映射，因此我们得到了所需的映射。
  ],
)

剩下的部分是证明上面构造的映射的函子性和兼容性。
也就是说，我们需要证明：
- 函子性：以下图表在导出范畴中是交换的：
  #diagram-frame(
    edge => [$
        #align(center, diagram(
          cell-size: (1mm, 1mm),
          $edge("d", "Tot"(cal(C)_("Čech")^(bullet), f), ->) "Tot"(cal(C)^(bullet)_("Čech") (cal(U), cal(F)^(bullet))) edge(->) & R Gamma(X, cal(F)^(bullet)) edge("d", R Gamma(f), ->) \
          "Tot"(cal(C)^(bullet)_("Čech") (cal(U), cal(K)^(bullet))) edge(->) & R Gamma(X, cal(K)^(bullet)).\ $,
        ))\
        quad
      $],
  )

#proof(
  [
    考虑一个阿贝尔范畴 $cal(A)$，其导出范畴为 $D(cal(A))$。
    给定一个拓扑空间 $X$，我们考虑一个链态射层 $f: cal(F)^(bullet) -> cal(K)^(bullet)$。
    该映射的函子性等价于以下图表的交换性：
    #diagram-frame(
      edge => [$
          #align(center, diagram(
            cell-size: (1mm, 1mm),
            $edge("d", "Tot"(cal(C)_("Čech")^(bullet), f), ->) "Tot"(cal(C)^(bullet)_("Čech") (cal(U), cal(F)^(bullet))) edge(->) & R Gamma(X, cal(F)^(bullet)) edge("d", R Gamma(f), ->) \
            "Tot"(cal(C)^(bullet)_("Čech") (cal(U), cal(K)^(bullet))) edge(->) & R Gamma(X, cal(K)^(bullet)).\ $,
          ))\
          quad
        $],
    )
    证明这个交换性的一个标准方法是考虑带有拟同构的内射层复形：
    $
      phi.alt_(F): cal(F)^(bullet) -> cal(I)^(bullet)_(F), quad phi.alt_(K): cal(K)^(bullet) -> cal(I)^(bullet)_(K),
    $
    因此，上面的图表可以展开为：
    #diagram-frame(
      edge => [$
          #align(center, diagram(
            cell-size: (1mm, 1mm),
            $edge("d", "Tot"(cal(C)_("Čech")^(bullet), f), ->) "Tot"(cal(C)^(bullet)_("Čech") (cal(U), cal(F)^(bullet))) edge(->) & "Tot"(cal(C)^(bullet)_( "Čech")(cal(U), cal(I)^(bullet)_(F))) edge(->) edge("d", "Tot"(cal(C)_("Čech")^(bullet), f'), ->) & Gamma(X, cal(I)_(F)^(bullet)) edge("d", Gamma(f'), ->) \
            "Tot"(cal(C)^(bullet)_("Čech") (cal(U), cal(K)^(bullet))) edge(->) & "Tot"(cal(C)^(bullet)_( "Čech")(cal(U), cal(I)^(bullet)_(K))) edge(->) & Gamma(X, cal(I)_(K)^(bullet)),\ $,
          ))\
          quad
        $],
    )
    这里我们利用了内射层的提升性质来获得一个链映射 $f'$，它在同伦意义下是唯一的，并通过以下交换图定义：
    #diagram-frame(
      edge => [$
          #align(center, diagram(
            cell-size: (1mm, 1mm),
            $ edge("d", ->) cal(F)^(bullet) edge(f, ->) & cal(K)^(bullet) edge("d", ->) \
                     cal(I)^(bullet)_(F) edge(f', ->) & cal(I)^(bullet)_(K). \ $,
          ))\
          quad
        $],
    )
    现在，交换性的证明可以分解为证明上述图表中每个小方块的交换性。

    *左方块*：
    由于 Čech 复形的构造是函子性的，左边的方块是交换的（在同伦等价意义下，这在导出范畴中即为等价）。

    *右方块*：
    由于增广映射是函子性的，右边的方块是严格交换的。
  ],
  title: "函子性证明",
)

- 兼容性：以下图表是交换的：
  #diagram-frame(
    edge => [$
        #align(center, diagram(
          cell-size: (1mm, 1mm),
          $edge("dr", ->) Gamma(X, cal(K)^(bullet)) edge(->) & R Gamma(X, cal(K)^(bullet)) \
          & "Tot"(cal(C)^(bullet)_("Čech") (cal(U), cal(K)^(bullet))) edge("u", ->), quad \ $,
        ))
        #align(center, diagram(
          cell-size: (1mm, 1mm),
          $edge("dr", ->) "Tot"(cal(C)^(bullet)_("Čech") (cal(U), cal(K)^(bullet))) edge(->) & R Gamma(X, cal(K)^(bullet)) \
          & "Tot"(cal(C)^(bullet)_("Čech") (cal(V), cal(K)^(bullet))) edge("u", ->),\ $,
        ))\
        quad
      $
    ],
  )
  它们分别表示与全局截面和开覆盖加细的兼容性。

#proof(
  [
    *与全局截面的兼容性*：
    兼容性可以写为以下图表的交换性：
    #diagram-frame(
      edge => [$
          #align(center, diagram(
            cell-size: (1mm, 1mm),
            $edge("dr", ->) Gamma(X, cal(K)^(bullet)) edge(->) & R Gamma(X, cal(K)^(bullet)) \
            & "Tot"(cal(C)^(bullet)_("Čech") (cal(U), cal(K)^(bullet))) edge("u", ->).\ $,
          ))\
          quad
        $
      ],
    )
    给定一个内射层 $cal(I)_(K)^(bullet)$，上面的图表可以改写为：
    #diagram-frame(
      edge => [$
          #align(center, diagram(
            cell-size: (1mm, 1mm),
            $edge("dr", ->) Gamma(X, cal(K)^(bullet)) edge(->) & Gamma(X, cal(I)_(K)^(bullet)) \
            & "Tot"(cal(C)^(bullet)_("Čech") (cal(U), cal(K)^(bullet))) edge("u", ->).\ $,
          ))\
          quad
        $
      ],
    )
    我们可以在上图中追踪一个元素 $s in Gamma(X, cal(K)^(n))$ 的路径。
    沿着下方的路径，我们有：
    $
      s |-> { alpha_(i_0) = s|_(U_(i_0)), alpha_(i_0,...,i_(p)) = 0, p >= 1 } |-> { alpha_(i_0) = phi.alt_(K)(s|_(U_(i_0))), alpha_(i_0,...,i_(p)) = 0, p >= 1 } -> {phi_(K)(s|_(U_(i_0)))}.
    $
    其中 $phi.alt_(K): cal(K)^(bullet) -> cal(I)_(K)^(bullet)$ 是之前定义的拟同构。
    层态射应该与增广映射交换，即 $phi.alt_(K)(s|_(U_(i_0))) = phi_(K)(s)|_(U_(i_0))$，这意味着上方路径和下方路径是相同的。

    *与加细的兼容性*：
    考虑 $X$ 的两个开覆盖 $cal(U) = {U_i}_I$ 和 $cal(V) = {V_i}_J$，其中 $cal(V)$ 是 $cal(U)$ 的一个加细。
    给定一个内射 $cal(K)^(bullet) -> cal(I)_(K)^(bullet)$，兼容性可以写为以下图表的交换性：
    #diagram-frame(edge => [$
        #align(center, diagram(
          cell-size: (1mm, 1mm),
          $edge("dr", ->) "Tot"(cal(C)^(bullet)_("Čech") (cal(U), cal(K)^(bullet))) edge(->) & Gamma(X, cal(I)^(bullet)) \
          & "Tot"(cal(C)^(bullet)_("Čech") (cal(V), cal(K)^(bullet))) edge("u", ->),\ $,
        ))\
        quad
      $
    ])
    使用与上面相同的增广映射，交换性是显而易见的。

  ],
  title: "兼容性证明",
)

构造内射分解的一个常用方法是使用#link("https://en.wikipedia.org/wiki/Cartan%E2%80%93Eilenberg_resolution")[Cartan-Eilenberg 分解]：$cal(K)^(bullet) -> cal(I)^(bullet, bullet)$，其中 $cal(K)^(bullet) -> tot(cal(I)^(bullet, bullet))$ 是一个内射分解。
因此，Čech 复形：
$
  tot(cal(C)^(bullet)_cech (cal(U), tot(cal(I)^(bullet, bullet)))),
$
可以用来计算导出全局截面 $R Gamma(X, cal(K)^(bullet))$，正如我们上面讨论的。
现在我们考虑一个相关的双重复形：
$
  A^(n, m) := plus.big_(p+q = n) cal(C)^(p)_cech (cal(U), cal(I)^(q, m)).
$
与双重复形 $A^(n, m)$ 相关的谱序列的 $E_1$ 页是复形 $A^(n, bullet)$ 的上同调。注意到 $cal(I)^(bullet)$ 是一个内射分解，这个上同调就是 Čech 复形 $cal(C)^(p)_cech (cal(U), underline(H)^(q)(cal(K)^(bullet)))$。
因此，$E_2$ 页是 Čech 上同调 $H^(p)_(cech)(cal(U), underline(H)^(q)(cal(K)^(bullet)))$。
// TODO: 证明收敛性。

最后，如果能证明这样的谱序列收敛于原始的上同调，那么这个谱序列确实可以用来计算该上同调。
以上的讨论可以用下面的定理来表述：
#theorem([存在一个谱序列 $(E_(r), d_(r))_(r >0)$，其 $E_2$ 页为：
  $
    E_2^(p,q) = H^(p)(cal(U), underline(H)^(p)(cal(K)^(bullet))),
  $
  它收敛于 $H^(bullet)(X, cal(K)^(bullet))$。
])
#proof(
  [参见 #link("https://stacks.math.columbia.edu/tag/0132")[stacks project]],
  title: "收敛性证明",
)

现在我们可以将上述定理应用于层复形
$
  cal(K)^(bullet) := [... -> 0 -> C^(oo)(-, U(1)) ->^(d log) Omega^(1) ->^(d) Omega^(2) -> ... ->^(d) Omega^(n) -> 0 -> ...],
$
利用庞加莱引理，我们知道，对于任何可缩开集 $U$，复形 $cal(K)^(bullet)(U)$ 只在次数 $0$ 处有上同调。
然后，利用上面的谱序列，映射：
$
  tot(cal(C)_(cech)^(bullet)(cal(U), cal(K)^(bullet))) -> R Gamma(X, cal(K)^(bullet)),
$
确实是一个同构！
因此，我们最终证明了，在之前的博客中介绍的 Čech-de Rham 复形确实是层复形 $cal(K)^(bullet)$ 的导出全局截面的一个模型，即 $R Gamma(X, cal(K)^(bullet))$。
