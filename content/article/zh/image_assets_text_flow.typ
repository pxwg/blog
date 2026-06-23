#import "../../../typ/templates/blog.typ": *
#import "../../../typ/templates/target.typ": sys-is-html-target
#import "../../../typ/templates/theme.typ": default-theme, theme-frame

#let title = "编辑器中的流动图像"
#show: main-zh.with(
  title: title,
  desc: [损之又损，以至无为。],
  date: "2026-06-23",
  tags: (
    blog-tags.software-engineering,
    blog-tags.programming,
  ),
  lang: "zh",
  translationKey: "image_assets_text_flow",
)

#let scan-flow-main(theme) = theme.main-color
#let scan-flow-muted(theme) = if theme.is-dark { rgb("#A6A39A") } else {
  rgb("#6D6D6D")
}
#let scan-flow-faint(theme) = if theme.is-dark { rgb("#938C82") } else {
  rgb("#867C72")
}
#let scan-flow-rule(theme) = if theme.is-dark { rgb("#8C847A") } else {
  rgb("#9E958B")
}
#let scan-flow-rule-strong(theme) = if theme.is-dark { rgb("#B5AEA4") } else {
  rgb("#756D64")
}
#let scan-flow-fonts = ("Source Han Serif SC", "Libertinus")
#let scan-flow-card-width = 124pt
#let scan-flow-arrow-width = 48pt
#let scan-flow-line-leading = 0.18em
#let scan-flow-chip(theme, label, fill, stroke-color) = box(
  inset: (x: 1.8pt, y: 0pt),
)[#text(size: 13.2pt, fill: scan-flow-main(theme))[#label]]
#let scan-flow-card(theme, title, body, note, fill, stroke-color) = rect(
  width: 100%,
  inset: (x: 3pt, y: 3.4pt),
  radius: 0pt,
  stroke: 0.75pt + scan-flow-rule(theme),
)[
  #set par(leading: scan-flow-line-leading, justify: false)
  #text(size: 12.8pt, weight: "semibold", fill: scan-flow-main(theme))[#title]
  #v(0.25pt)
  #align(center)[#text(size: 13.6pt, fill: scan-flow-main(theme))[#body]]
  #v(0.15pt)
  #text(size: 11pt, fill: scan-flow-muted(theme))[#note]
]
#let scan-flow-arrow(theme, title, note) = align(center)[
  #set par(leading: scan-flow-line-leading, justify: false)
  #grid(
    columns: auto,
    row-gutter: 0pt,
    text(size: 10.6pt, fill: scan-flow-muted(theme))[#title],
    text(size: 18pt, fill: scan-flow-rule-strong(theme))[→],
    text(size: 9.6pt, fill: scan-flow-faint(theme))[#note],
  )
]
#let flow-diagram-width = 540pt
#let flow-diagram(render) = if sys-is-html-target {
  theme-frame.with(class: "typst-flow-diagram")(theme => {
    html.frame(block(width: flow-diagram-width, {
      set text(font: scan-flow-fonts, fill: scan-flow-main(theme))
      render(theme)
    }))
  })
} else {
  render(default-theme)
}
#let flow-caption(body) = if sys-is-html-target {
  html.elem("div", attrs: (class: "typst-flow-caption"), [#body])
} else {
  align(center)[#text(size: 0.9em)[#body]]
}

在构建 #link("https://github.com/pxwg/math-conceal.nvim")[`math-conceal.nvim`] 这个插件的过程中，我需要构建一个能够抵御大量编辑的、理论证明可行的机制。
这个插件的目标是在 Neovim 中实现图形化公式渲染：一方面保留 ASCII 形式的标准 math conceal，并通过 `decoration-provider` 做更细粒度的展开；另一方面，将公式图片作为 overlay conceal 放回 buffer，让公式编辑变得尽可能顺畅。

#image_viewer(
  path: "../assets/image_assets_text_flow_demo.png",
  desc: [math-conceal.nvim 中公式图像随文本流显示的效果样例。],
)

对于静态 buffer 而言，这件事情并不困难。
经典机制是：
- 全 buffer 使用 Tree-sitter 扫描所有需要渲染的节点并收集起来；
- 将每一个 Tree-sitter 数学节点中的文本送到后端 renderer，编译成图片；
- Tree-sitter 数学节点附带定位信息，再通过 #link("https://neovim.io/doc/user/api/#extmarks")[extmark] 或图像协议把图片放回原处。

这事实上对于静态 buffer 完全足够。
然而，如果我们试图考察动态的 buffer，问题就会变得很大。

= 静态扫描的空窗期

给定静态的渲染后构型，我们可以粗略写成：

```text
buffer(i) = collection of { node_n(i): location + source + image binding }
```

当刷新一次构型之后，我们需要考察下一版：

```text
buffer(i+1) = collection of { node_n(i+1): location + source + image binding }
```

如果每一次都通过扫描 buffer 的方式来收集数学公式，这事实上意味着我们需要经历一段闪烁空窗期。

#flow-diagram(theme => {
  let scan-flow-chip = scan-flow-chip.with(theme)
  let scan-flow-card = scan-flow-card.with(theme)
  let scan-flow-arrow = scan-flow-arrow.with(theme)
  let scan-flow-muted = scan-flow-muted(theme)
  align(center)[
    #grid(
      columns: (
        scan-flow-card-width,
        scan-flow-arrow-width,
        scan-flow-card-width,
        scan-flow-arrow-width,
        scan-flow-card-width,
      ),
      column-gutter: 8pt,
      scan-flow-card(
        [buffer $(i)$],
        [#scan-flow-chip("N₀", rgb("#DBEAFE"), rgb("#2563EB")) #h(2pt) #text(
            fill: scan-flow-muted,
          )[+] #h(2pt) #scan-flow-chip("B₀", rgb("#DCFCE7"), rgb("#16A34A"))],
        [old image still bound],
        rgb("#EFF6FF"),
        rgb("#2563EB"),
      ),
      scan-flow-arrow([scan start], [gap]),
      scan-flow-card(
        [scan window],
        [#scan-flow-chip("N₁", rgb("#FEE2E2"), rgb("#DC2626"))],
        [image anchor absent],
        rgb("#FEF2F2"),
        rgb("#DC2626"),
      ),
      scan-flow-arrow([scan end], [match]),
      scan-flow-card(
        [after scan],
        [#scan-flow-chip("N₁", rgb("#DCFCE7"), rgb("#16A34A")) #h(2pt) #text(
            fill: scan-flow-muted,
          )[+] #h(2pt) #scan-flow-chip("B₀", rgb("#DCFCE7"), rgb("#16A34A"))],
        [old asset reattached to new node],
        rgb("#F0FDF4"),
        rgb("#16A34A"),
      ),
    )
  ]
})

#flow-caption[N₀/B₀ 表示扫描前的 node/binding 集合，N₁ 表示扫描后的 node 集合。]

过去的方案会使用 `hashmap` 等方式来减少中间的闪烁空窗期，尽可能复用资产。
也就是说，通过缓存命中，把扫描前的绑定尽可能挂回扫描后的节点。

#flow-diagram(theme => {
  let scan-flow-chip = scan-flow-chip.with(theme)
  let scan-flow-card = scan-flow-card.with(theme)
  let scan-flow-arrow = scan-flow-arrow.with(theme)
  let scan-flow-muted = scan-flow-muted(theme)
  align(center)[
    #grid(
      columns: (
        scan-flow-card-width,
        scan-flow-arrow-width,
        scan-flow-card-width,
      ),
      column-gutter: 8pt,
      scan-flow-card(
        [before match],
        [#scan-flow-chip("N₀", rgb("#DBEAFE"), rgb("#2563EB")) #h(2pt) #text(
            fill: scan-flow-muted,
          )[+] #h(2pt) #scan-flow-chip("B₀", rgb("#DCFCE7"), rgb("#16A34A"))],
        [binding before scan],
        rgb("#EFF6FF"),
        rgb("#2563EB"),
      ),
      scan-flow-arrow([hash map], [reuse]),
      scan-flow-card(
        [matched],
        [#scan-flow-chip("N₁", rgb("#DCFCE7"), rgb("#16A34A")) #h(2pt) #text(
            fill: scan-flow-muted,
          )[+] #h(2pt) #scan-flow-chip("B₀", rgb("#DCFCE7"), rgb("#16A34A"))],
        [new node reuses old asset],
        rgb("#F0FDF4"),
        rgb("#16A34A"),
      ),
    )
  ]
})

闪烁问题事实上可以通过复用上一版本的渲染图片来缓解。
更严重的问题来自资产与源码的错位。

它的来源和上一版本一样：在节点位移后，扫描阶段节点源码已经发生变换，但由于新的 Tree-sitter span 还没有算出来，因此新图片的位置是未知的。
这会导致错位现象。

#flow-diagram(theme => {
  let scan-flow-chip = scan-flow-chip.with(theme)
  let scan-flow-card = scan-flow-card.with(theme)
  let scan-flow-arrow = scan-flow-arrow.with(theme)
  let scan-flow-muted = scan-flow-muted(theme)
  align(center)[
    #grid(
      columns: (
        scan-flow-card-width,
        scan-flow-arrow-width,
        scan-flow-card-width,
        scan-flow-arrow-width,
        scan-flow-card-width,
      ),
      column-gutter: 8pt,
      scan-flow-card(
        [before scan],
        [#scan-flow-chip("N₀", rgb("#DBEAFE"), rgb("#2563EB")) #h(2pt) #text(
            fill: scan-flow-muted,
          )[+] #h(2pt) #scan-flow-chip("B₀", rgb("#DCFCE7"), rgb("#16A34A"))],
        [old binding remains],
        rgb("#EFF6FF"),
        rgb("#2563EB"),
      ),
      scan-flow-arrow([scan start], [gap]),
      scan-flow-card(
        [scan window],
        [#scan-flow-chip("N₁", rgb("#FEE2E2"), rgb("#DC2626"))],
        [image position unknown],
        rgb("#FEF2F2"),
        rgb("#DC2626"),
      ),
      scan-flow-arrow([scan end], [backfill]),
      scan-flow-card(
        [after scan],
        [#scan-flow-chip("N₁", rgb("#DCFCE7"), rgb("#16A34A")) #h(2pt) #text(
            fill: scan-flow-muted,
          )[+] #h(2pt) #scan-flow-chip("B₀", rgb("#DCFCE7"), rgb("#16A34A"))],
        [old asset reattached],
        rgb("#F0FDF4"),
        rgb("#16A34A"),
      ),
    )
  ]
})

与闪烁不同，这个问题很难通过 hack 手段完成，除非能够预测用户的行为。
这只能在有限的场景中通过劫持用户请求等方式实现，非常复杂，也非常脆弱。
在大量的编辑请求后，它还会挤爆 Neovim 的线程，然后带来卡顿。

我们可以粗略地将整个 buffer 的数学公式渲染抽象成两种基本操作的组合：
- 对非目标 node 的编辑；
- 对 node 源码的编辑。

在 Typst 中，目标 node 对应数学公式的 `math` 节点和函数对应的 `code` 节点。

第二种编辑模式是很难避免资产过时的：
当我们更新源码时，旧的资产必然会 stale，需要通过 renderer 来更新。
当然，我们可以让“新资产没有更新的时候旧资产仍绑定 node”，但由于 node 本身也在变换，这会面临一系列启发式判定。
好在实际编辑过程中必然会看源码，因此当编辑 node 源码时，可以暂时不绑定节点上的资产，直到离开节点。

第一种编辑模式则完全不同：
如果编辑发生在公式之外，资产本身并没有变化。
此时，最为理想的模式应当是资产始终与绑定的节点移动，而非在编辑过程中不断重新扫描、重新匹配、重新挂载。
如果仍然通过各种启发式行为掩盖闪烁和几何错位，那并没有解决问题，只是遮掩了这一本质问题。

#remark[
  当使用 coding agent 进行 debug 时，经常会出现这种利用启发式行为掩盖问题的行为。这并不怪 agent，毕竟在不大改架构的时候，这种启发式操作时最经济的。得益于 agent 超高效率的代码生成速度，短期内看来确实问题被解决了，但长期将遗留出一座“屎山”。
]

= 图像资产应该随文本流移动

理想方式应该是：对于不改变 node 源码的编辑行为，将图像资产视作与所绑定文本相同的资源。
在编辑器发生文本编辑事件时，它们应该同时更新。

对于文本编辑器而言，文本显示天然就应该满足这样的能力，否则这就根本不是一个合格的文本编辑器。

#flow-diagram(theme => {
  let scan-flow-chip = scan-flow-chip.with(theme)
  let scan-flow-card = scan-flow-card.with(theme)
  let scan-flow-arrow = scan-flow-arrow.with(theme)
  align(center)[
    #grid(
      columns: (
        scan-flow-card-width,
        scan-flow-arrow-width,
        scan-flow-card-width,
      ),
      column-gutter: 8pt,
      scan-flow-card(
        [edit event],
        [#scan-flow-chip("input", rgb("#DBEAFE"), rgb("#2563EB"))],
        [input anywhere],
        rgb("#EFF6FF"),
        rgb("#2563EB"),
      ),
      scan-flow-arrow([editor map], [displacement]),
      scan-flow-card(
        [new layout],
        [#scan-flow-chip("P₁", rgb("#DCFCE7"), rgb("#16A34A"))],
        [new text position],
        rgb("#F0FDF4"),
        rgb("#16A34A"),
      ),
    )
  ]
})

举例而言，当我在

```text
不用相信[cursor-position]奇迹，相信本就是奇迹
```

的 `[cursor-position]` 处插入文本时，后续的“奇迹，相信本就是奇迹”应该被“推着”往后面跑，而不是和我新输入的文本重合。
一个成熟的文本编辑器必然拥有这个功能，否则这个文本编辑器是不可用的。

这个模型与图片模型是完全重合的：
- 未被编辑的文本 $->$ 未被编辑节点的图片资产；
- 编辑其他文本使得未被编辑文本移动 $->$ 编辑其他文本使得未被编辑节点的图片资产移动。

因此，如果能够获得编辑器对于“编辑事件中文本位置的变化”的映射：

#flow-diagram(theme => {
  let scan-flow-chip = scan-flow-chip.with(theme)
  let scan-flow-card = scan-flow-card.with(theme)
  let scan-flow-arrow = scan-flow-arrow.with(theme)
  align(center)[
    #grid(
      columns: (
        scan-flow-card-width,
        scan-flow-arrow-width,
        scan-flow-card-width,
      ),
      column-gutter: 8pt,
      scan-flow-card(
        [before edit],
        [#scan-flow-chip("P₀", rgb("#DBEAFE"), rgb("#2563EB"))],
        [old text position],
        rgb("#EFF6FF"),
        rgb("#2563EB"),
      ),
      scan-flow-arrow([edit], [mapping]),
      scan-flow-card(
        [after edit],
        [#scan-flow-chip("P₁", rgb("#DCFCE7"), rgb("#16A34A"))],
        [new text position],
        rgb("#F0FDF4"),
        rgb("#16A34A"),
      ),
    )
  ]
})

再将 `text-position` 转换为对应的 node 节点，就可以实现 node 节点在编辑事件中的位移映射。
进一步地，绑定图片也可以实现 node 节点的图像资产在编辑事件中的位移映射。

整个过程不需要使用超过编辑器能力本身的位置计算资源。
因此，理论上其更新速度上限等于文本编辑器自身的渲染更新上限。

#remark[
  对于 #link("https://sw.kovidgoyal.net/kitty/graphics-protocol/")[kitty graphics protocol] 这类基于 `placeholder` 定位数学公式的协议，其天然支持“像管理文本一样地管理图片定位”，因此图片资产的更新速度基本上等同于更新文本的速度；而对于 #link("https://iterm2.com/documentation-images.html")[iTerm2 image protocol] 这类基于 terminal escape sequence 直接绘制图片的协议，图片定位并不天然属于 Neovim 的文本布局系统。我们需要手动 attach-detach 图片资产，因此性能会更差。
]

= 返本归真

这事实上确定了一个基本原则：我们不能通过直接 parse 源码的方式来定位数学节点。
直接 parse 源码会导致上述错配现象出现。
真正需要被维护的，是编辑器渲染流中的几何构型，并被后续 UI 管线消费。

在实现层面，我们需要让文本编辑器暴露出编辑事件中文本位置变化的映射，或者至少能够自己拼出这样的映射。
幸运的是，Neovim 早就提供了官方手段来表达元素随文本编辑事件位移的行为：Neovim 的 extmark 给了我们一个随文本流编辑自动演化的几何锚点，而 `on_lines` 等事件则允许我们获得编辑区域供后续使用。

然而，单纯知道文本结构是不足的，因为当我们定义 `math` 等节点将其用于图像渲染时，必然需要某种语义化的方式提取出编辑过程可能发生位移的代码块。Tree-sitter 事实上拥有这一能力，这同样是 Neovim 的原生功能，我们最开始其实便已经知晓。但在上述合理的抽象上，我们最终将其放在了一个合适的位置上，而不是试图越权处理一切编辑器事件。

在这种抽象中，我们唯一需要做的事情就是将二者联系起来：在语义上使用 Tree-sitter 保留所需节点的结构，而在编辑流中使用 extmark 保证其正确地随文本流编辑演化。Monkey-Patch？不存在的。启发式搜索？不需要。hook 用户 key stroke？你过度设计了。真正健康的设计，从来不是一个又一个脚本、逻辑、框架的堆砌，而是在海量细节之前，询问其背后的深刻结构，并思考：在这纷繁复杂的表象之下，有什么是真正本质的？当纷繁表象损之又损，剩下的“无”，便大有可“为”。
