#import "../../../typ/packages/metalogo.typ": *
#import "../../../typ/templates/blog.typ": *

#show: main-zh.with(
  title: [用 Typst Mark Everything Down，而非 TeX Them],
  desc: [烦恼即菩提。],
  date: "2025-08-16",
  tags: (
    blog-tags.programming,
    blog-tags.typst,
  ),
  lang: "zh",
  translationKey: "typst_md_tex",
  llm-translated: true,
)

#let blank(body) = {
  underline[~~~#body~~~]
}

#link("https://github.com/typst/typst")[Typst] 是一款卓越的排版工具，自从我第一次遇见它，就将其融入了生活的每个角落——从课堂笔记、数学草稿到您正在阅读的这篇_博客文章_。

= Typst 在何处胜过 LaTeX？

Typst 与传统的 LaTeX 有何不同？传统的解释是：_更快的_编译（得益于增量编译）、_更轻松的_写作（现代语法消除了无尽的 `\` 命令）以及_更简单的_安装。
但*排版质量*如何？坦率地说，Typst 在这方面尚未超越 LaTeX。
其主要价值在于提供更流畅、更直观的写作体验——而非排版上的完美。
例如，借助 #link("https://github.com/Myriad-Dreamin/tinymist")[Tinymist] 语言服务器，您可以获得实时预览，绕过了 LaTeX 的编译 - 查看工作流程（尽管像 #link("https://github.com/let-def/texpresso")[TeXpresso] 这样的项目旨在缩小这一差距）。

作为一种年轻的语言（仍处于 v`0.x.x` 版本），Typst 存在局限性，并且在 LaTeX 占主导地位的学术界尚未被广泛采用。
当我在 Typst 中复制 LaTeX 的布局时，有时会遇到障碍——某些功能根本还没有实现。

经过数周的挫折，我意识到：Typst 目前还不是 LaTeX 的替代品，至少对我来说，目前还不是。
吸引我的是它的_易用性_——非常适合博客、笔记或家庭作业解答，而不是研究论文。

= 人们用 LaTeX 做笔记只是因为他们*只有* LaTeX

使用 LaTeX 做笔记会迫使注意力集中在格式而非内容上。尽管其旨在分离样式/内容的设计有所帮助，但等待编译的过程很容易让人分心于对齐问题或包冲突。
简而言之：LaTeX 对于笔记来说是大材小用。人们使用它仅仅是因为 Markdown 缺乏必要功能，导致没有中间地带。

== Typst 弥合鸿沟

Typst 提供了类似 Markdown 的写作体验，具有实时预览和直观的语法，同时通过内置的数学排版、引用等功能超越了 Markdown 的能力。
关键的是，它能原生生成 PDF——这与依赖外部转换工具的 Markdown 不同。这使 Typst 成为理想的中间选择，而 LaTeX 由于其过度复杂性，从根本上就不适合简单的笔记记录。



历史上（至少在我的记忆中），物理学家在采用 LaTeX 写论文之前，使用的是打字文本加手写公式。现在，有些人也误用它来做笔记。
LaTeX 擅长论文排版，但作为笔记工具则很失败。Markdown 轻量，但对于学术用途来说功能不足。

扩展 Markdown（例如，添加数学支持）导致了语法碎片化——相同的标记在不同的工具中行为各异。

在此背景下，Typst 自然成为了平衡的中间道路。一旦我们接受这一定位，许多感知到的限制就不再是问题。
担心排版不稳定？请记住，Markdown 甚至无法在不同平台间保持一致的渲染。
担心生态系统？想想做笔记的人真正需要什么：是一支用于捕捉思想的数字笔，而不是一个用于完美排版的工业印刷车间。
在撰写博客、课堂笔记——甚至起草论文时，我们并不需要复杂的出版工具。

== Typst = Markdown + CSS + Pandoc + ...

在 `Markdown` 的世界中，语法本身 (以及相应的扩展) 仅仅标注了基本元素的结构，而对于最终展示在人眼中的样式没有任何约束。
因此，内容与样式的分离在这里会导致失控，正如我们之前提到的那样。
但是，内容与样式分离的“失控”会在某一个方面成为这一模式的优势。

思考你在光照缺失的环境中撰写笔记，你的 IDE 或者文本编辑器以一种令人愉悦的方式，将编辑器页面渲染为美观的深色主题。
但是！回顾你用 LaTeX 的悲惨经历吧！旁边生成的 pdf 文字，几乎完全都是白底黑字 (或者粗暴的反色)，这让你感到刺眼和不适#footnote([当然我承认，目前有类似#link("https://sioyek-documentation.readthedocs.io/en/latest/")[Sioyek]、#link("https://pwmt.org/projects/zathura/")[Zathura]的 PDF 阅读器支持精细的反色，但是他们在使用的便利性等方面都存在或多或少的问题。例如，前者的内存占用常常飙升并且时常崩溃，后者则常常失去反向查找功能。当然我承认这些很多可能都是我自己的问题，但这确实是引导我改变的动机之一，])。

#image_viewer(
  path: "../assets/typst_md_tex_2.png",
  desc: [在深色主题下使用 LaTeX 撰写笔记时，PDF 预览的效果令人不适。],
)

如果此时你有一份聪明的 Markdowns 预览工具，以及一份适配了深色主题的 CSS 样式表，那么你就可以愉快地在深色主题下编写笔记，而不被高亮的白色 PDF 所打扰。

如果试图在 LaTeX 中实现这个功能，你可能需要一些比较复杂的宏包，以保证在编译期能够正确识别你究竟是“预览”还是“打印”——前者需要生成恰当的深色主题样式，而后者则需要生成传统的黑白样式。
但在 Typst 中，编译器自动支持`--input` 参数，通过传递`ket=value`，你可以轻松在编译期修改不同的主题实现 (例如，用```typst #isDark=true``` 来指示深色主题与否)。
接下来，在模板文件中利用```typst sys.inputs``` 读取传入的参数，就可以确认是否需要渲染深色主题：

```typst
#let inputs = sys.inputs
#let get_input(input_dict) = {
  let isDark = false
  for (key, value) in input_dict {
    if key == "isDark" {
      isDark = value
    }
  }
  return (isDark: isDark)
}
#let (isDark) = get_input(inputs)
```
然后，你只需要定义相应的颜色方案，即可实现对于不同主题的切换支持。

目前`typst` 社区的普遍做法是使用#link("https://github.com/Myriad-Dreamin/tinymist")[Tinymist] 语言服务器来实现实时预览功能。
这个语言服务器会在本地开放一个随机端口，通过在本地浏览器中访问该端口来实现实时预览功能。
由于`tinymist` 复刻了 Typst 的编译器逻辑，因此你可以通过`--input` 参数来传递不同的主题参数，从而实现深色主题的支持。
例如，在上面的例子中，你只需要添加额外的`--input isDark=true` 参数即可。

#image_viewer(
  path: "../assets/typst_md_tex_1.png",
  desc: [在撰写本文时，使用 Typst 实现深色主题预览的效果。],
)

你可能注意到了我在上面的预览中，字体与行距也有所不同。
这同样是巧用 `--input` 参数实现的。
这样的好处是，当我使用支持 `kitty` 图形协议的终端浏览器#link("https://github.com/chase/awrit")[awrit] 时，我不需要重复进行放大或者裁剪边缘的操作。

因此，我们利用 `typst` 工具，轻松实现了类似 `Markdown + CSS` 的功能。

此外，`typst` 作为一个面向排版的标记语言，他原生支持输出 `pdf`，并且在 `v0.10.0` 版本后，增加了对于 `html` 输出的支持。
这使得 `typst` 也可以作为一个类似 `Pandoc` 的工具，来实现不同格式的输出需求。

= 烦恼即菩提

在将 Typst 定位为 LaTeX 替代品时，我们自然会被其宏伟愿景所吸引：一种适用于所有科学文档的统一语法——简单易用、易于编写、易于阅读。
但这个承诺在 Typst 的早期开发阶段与现实发生了碰撞，成长的烦恼表现为无数细微的挫折。
一种解决方案是耐心：等待 Typst 像 LaTeX 那样经过多年发展成熟。但我们能合理投入多少时间呢？
如果没有视角的转变，我们就有可能陷入无尽的烦恼之中。

突破来自于重新定义问题。
与其追求“完美”的工具，不如审视实际需求：在日常工作流程中，我们很少需要出版级的精度。
真正重要的是用一个方便、易用的工具来捕捉思想和笔记。
这一认识将 Typst 从“不完整的 LaTeX”转变为“功能增强的 Markdown”。
突然之间，挫折消散了——或者至少大大减轻了。
您会欣赏 Typst 优雅的语法、强大的功能和实时预览，而不是执着于它的局限性。
