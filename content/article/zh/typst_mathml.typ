#import "../../../typ/templates/blog.typ": *

#let title = "将 Typst 博客公式从 SVG 迁移到 MathML"
#show: main-zh.with(
  title: title,
  desc: [我将 Typst 博客的数学公式从 SVG 展示迁移到了基于 Typst 最新 MathML 输出的渲染方案。],
  date: "2026-05-23",
  tags: (
    blog-tags.software-engineering,
    blog-tags.programming,
    blog-tags.typst,
  ),
  lang: "zh",
  translationKey: "typst_mathml",
)

#remark[
  在最新的#link("https://github.com/typst/typst/releases")[Typst 0.15.0 版本]中，typst 已经原生支持 MathML 公式输出，因此本文所描述的方案已经不必被使用。
]

= 缘起

我的博客文章主要用 Typst 写，再交给 Astro 生成静态网页。
这套方案用起来一直比较顺手：写数学文章时可以直接用 Typst 的公式和模板系统，发布时又能得到普通网页。
唯一比较麻烦的地方是 HTML 里的数学公式。

之前博客里的公式基本走 SVG。
Typst 负责把公式排好，然后导出一段内嵌 SVG，网页再把这段 SVG 放回正文中。
这个方案的观感其实一直可以，尤其是很多复杂公式，SVG 版本和 PDF 版本差距不大。
但 SVG 终究是一张图。
浏览器看到的是图形路径，读屏器、复制、搜索、语义结构都要靠额外补丁处理。

最近 Typst 主分支合并了 #link("https://github.com/typst/typst/pull/7436")[MathML Core output for HTML export]。
不过我一开始并没有立刻想到可以把它接到自己的博客里。
后来看到 Reddit 上 #link("https://www.reddit.com/r/typst/comments/1tfoc08/native_typst_to_mathml_in_my_blog/")[一篇把原生 Typst-to-MathML 用到博客里的文章]，才意识到这条路已经可以实际尝试。
看完之后我决定把当前博客的公式渲染从 SVG 切到 MathML。
这个迁移花了几个小时，中间主要是和 Codex 一起读当前模板、改 `astro-typst` 补丁、修 CSS，然后用实际文章反复看效果。

= 之前的 SVG 方案

SVG 方案最早是为了解决一个问题：Typst 的 HTML target 还不稳定，但我又希望博客里的数学公式看起来接近 Typst/PDF 输出。
当时把公式导成 SVG 基本是顺手的做法。
浏览器对 SVG 的支持已经过了很多年，只要 Typst 导出的图形没问题，Chrome、Safari、Firefox 一般不会出现太奇怪的差异。

行内公式会麻烦一些。
公式虽然看起来像一个小图片，但它其实在句子里占一个字符位置。
如果直接把 SVG 底边和文字底边对齐，$A = frac(1, z-w)$ 这种带分式的公式会显得往下掉。
如果粗暴缩小，又会让公式字号和正文不一致。

所以之前我写过一套 baseline 对齐逻辑。
做法是在公式 SVG 里塞一个不可见的基线标记，然后在 `astro-typst` 输出阶段解析 SVG 的 `height`、`viewBox` 和标记位置，最后把结果写回 `vertical-align`。
代码大概就是这种感觉：

```typescript
const INLINE_MATH_BASELINE_STROKE = "#ff00ff";

function getInlineMathBaselineShift(fragment: string) {
  const marker = new RegExp(
    `<svg\\b([^>]*)>[\\s\\S]*?<g transform="translate\\(([-+\\d.]+) ([-+\\d.]+)\\)">\\s*<path\\b(?=[^>]*stroke="${INLINE_MATH_BASELINE_STROKE}")`,
  ).exec(fragment);
  // 省略后面的 height/viewBox 换算
}
```

这个补丁解决了行内公式的位置问题。
但它也让公式渲染变成了两层：视觉层是 SVG，辅助层再补一份 MathML。
这就会带来维护成本。
一旦 Typst 的输出结构变了，或者某个包的 show rule 影响了公式结构，调试时就要同时看 SVG、辅助 MathML、CSS wrapper 和 Astro 输出。

= 尝试 MathML

我以前也试过 #link("https://codeberg.org/akida/mathyml")[mathyml]。
它的思路是在 Typst 层通过 show rule 把公式转换成 MathML。
这个项目我试过一阵子，但在我的博客里效果一般，主要是复杂公式和第三方 Typst 包配合时容易出现边角问题。
这个方向算是帮我确认了一件事：MathML 这条路是可以走的，但如果转换逻辑还在模板层，遇到复杂公式时还是会有点不踏实。

这次情况变了。
Typst 自己开始在 HTML export 里输出 MathML Core，所以转换发生在编译器的数学输出路径中。
博客模板不需要自己猜 Typst 数学结构，也不用再维护一套第三方转换规则。

第一步是让 `astro-typst` 用上包含 MathML 输出的 Typst 编译器包。
当前仓库里通过 `pnpm-workspace.yaml` 做了 override：

```yaml
overrides:
  '@myriaddreamin/typst-ts-node-compiler': npm:@wybxc/typst-ts-node-compiler@0.7.1
  '@myriaddreamin/typst-ts-renderer': npm:@wybxc/typst-ts-renderer@0.7.1
  '@myriaddreamin/typst.ts': npm:@wybxc/typst.ts@0.7.1
patchedDependencies:
  astro-typst@0.12.3: patches/astro-typst@0.12.3.patch
```

第二步是改 Typst 模板。
在 `typ/templates/shared.typ` 里，HTML target 下的公式直接交给 Typst HTML export：

```typst
#let equation-rules(body) = {
  show math.equation: set text(font: math-font)
  show math.equation.where(block: false): it => context if sys-is-html-target {
    set text(size: math-size, font: math-font)
    visible-mathml(
      it,
      attrs: (class: "typst-inline-math typst-native-math"),
    )
  } else {
    it
  }
  show math.equation.where(block: true): it => context if sys-is-html-target {
    set text(size: math-size, font: math-font)
    visible-mathml(
      it,
      tag: "div",
      attrs: (class: "typst-display-math typst-native-math"),
    )
  } else {
    it
  }
  body
}
```

`visible-mathml` 本身没有做什么复杂事情：

```typst
#let visible-mathml(body, tag: "span", attrs: (:)) = html.elem(
  tag,
  attrs: attrs,
  {
    show math.equation: it => it
    body
  },
)
```

这里主要是给公式套上稳定的 class。
真正的 MathML 由 Typst HTML export 输出。

= `astro-typst` 补丁

`astro-typst` 这边保留了一个 patch。
我没有在这里重新实现 MathML 转换，只做了几个小修。

首先，块级公式需要 `displaystyle="true"`。
否则有些浏览器会把 display math 排得更接近 inline math。
因此输出 HTML 后有一行替换：

```typescript
output = output.replaceAll(
  '<math display="block"',
  '<math display="block" displaystyle="true"',
);
```

其次，Typst 编译或 HTML 导出失败时直接抛错。
之前 `astro-typst` 会返回空 HTML，这在博客构建时很难看出来。
公式迁移时我更希望它直接炸掉，省得最后部署出一篇空文章：

```typescript
if (!docRes.result) {
  logger.error("Error compiling typst to HTML");
  docRes.printDiagnostics();
  throw new Error("Failed to compile Typst HTML output.");
}
```

最后，旧的 SVG baseline 修复还在 patch 里。
现在正文公式主路径已经切到 MathML，但一些旧 wrapper 或特殊 HTML frame 可能还会经过 SVG 路径。
这部分代码先保留，等之后确认没有使用场景再删。

= Debug

这次最花时间的坑来自 CSS。

刚切到 MathML 时，Chrome 里有些公式看起来很挤，尤其是比较高的 display 公式。
一开始很容易怪 Chrome。
Chrome 的 MathML 支持确实弱一些，Firefox 里同一篇文章看起来通常更顺眼。
但这次问题没有这么简单。

我们做了一个最小复现：把同一段 MathML 放进一个空 HTML 页面，再放回完整 Astro 页面。
空页面里看起来正常，完整页面里才出问题。
后来继续拆 CSS，发现主因是我把 `Libertinus Math` 放进了全局 `math` 字体里：

```css
math {
  font-family: "Libertinus Math", math;
}
```

Chrome 原生 MathML 加上这个字体后，`bare` 对照里的 display 公式会被压得很小，积分符号也跟着变矮。
当时测过同样 16px 下，浏览器默认 `math` 和 `STIX Two Math` 的第一条积分高度大约都是 `46.83px`，换成 `Libertinus Math` 后只有 `28.75px`。
24px 下也是同样趋势：默认 `math` / `STIX Two Math` 大约 `70.22px`，`Libertinus Math` 大约 `42.92px`。
复现截图大概是下面这样，左侧 `bare` 对照里的两条 display 公式整体明显偏小：

#figure(image("../assets/mathml_integral_debug.png", width: 100%))

博客的全局样式为了普通正文做了很多设置，比如字体、行高、换行、图片大小和 overflow。
这些东西对段落、图片、代码块都合理，但继承到 `math` 元素上就可能出事。
最后修复方向是 display MathML 不再使用 `Libertinus Math`，改用浏览器默认 `math` 或 `STIX Two Math`，正文仍然可以继续使用 Libertinus Serif。
另外还有一个次要问题：块级公式的外层不能把纵向 overflow 裁掉，否则高公式会出现滚动条或被截断。
所以 CSS 里给 MathML 单独加了几条规则：

```css
math {
  overflow-wrap: normal;
  white-space: normal;
  word-break: normal;
  word-wrap: normal;
}
math[display="block"] {
  math-style: normal;
  margin: 0;
  overflow: visible;
  text-align: initial;
}
.typst-native-math math {
  overflow: visible;
}
.typst-native-math.typst-inline-math {
  display: inline;
  line-height: normal;
  vertical-align: baseline;
}
.typst-display-math {
  margin: 0.75em 0;
  overflow: visible;
  text-align: center;
}
```

这里主要是两点。
`math` 内部不要吃正文的强制换行规则。
块级公式外层的 `overflow-y` 也不能裁掉。
有些公式高度就是会超过普通行高，裁掉之后看起来就像浏览器排坏了一样。

= 效果与取舍

迁移完成后，整体效果和 SVG 版本比较接近。
Safari 里看起来尤其好。
Chrome 里有些细节还是差一点，但已经在可接受范围内。
对我来说，MathML 最大的收益是公式回到了网页语义里。
复制、辅助技术、浏览器原生处理，都比“把公式当图片”更自然。

这次迁移最大的经验是：不要只盯着公式转换。
真正花时间的地方通常在边界上，比如 Astro 插件怎么处理失败、CSS 会不会继承到 MathML、浏览器会不会吃错字体。
把这些边界处理好之后，切到 MathML 其实没有想象中复杂。
