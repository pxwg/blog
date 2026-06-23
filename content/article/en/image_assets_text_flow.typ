#import "../../../typ/templates/blog.typ": *
#import "../../../typ/templates/target.typ": sys-is-html-target
#import "../../../typ/templates/theme.typ": default-theme, theme-frame

#let title = "Flowing Images in the Editor"
#show: main.with(
  title: title,
  desc: [Diminish and diminish again, until reaching non-action.],
  date: "2026-06-23",
  tags: (
    blog-tags.software-engineering,
    blog-tags.programming,
  ),
  lang: "en",
  translationKey: "image_assets_text_flow",
  llm-translated: true,
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

While building the #link("https://github.com/pxwg/math-conceal.nvim")[`math-conceal.nvim`] plugin, I needed to construct a mechanism that could withstand heavy editing and remain theoretically defensible.
The goal of this plugin is to implement graphical formula rendering in Neovim: on one side, it preserves standard ASCII-form math conceal and uses `decoration-provider` for finer-grained expansion; on the other side, it places formula images back into the buffer as overlay conceal, making formula editing as smooth as possible.

#image_viewer(
  path: "../assets/image_assets_text_flow_demo.png",
  desc: [An example of formula images in math-conceal.nvim displayed along with the text flow.],
)

For a static buffer, this is not difficult.
The classical mechanism is:
- Scan the whole buffer with Tree-sitter and collect all nodes that need rendering;
- Send the text in each Tree-sitter math node to the backend renderer and compile it into an image;
- Tree-sitter math nodes carry location information, and then #link("https://neovim.io/doc/user/api/#extmarks")[extmarks] or an image protocol place the images back where they came from.

This is in fact completely sufficient for a static buffer.
However, if we try to examine a dynamic buffer, the problem becomes much larger.

= The Flicker Window in Static Scanning

Given a static rendered configuration, we can roughly write:

```text
buffer(i) = collection of { node_n(i): location + source + image binding }
```

After refreshing the configuration once, we need to examine the next version:

```text
buffer(i+1) = collection of { node_n(i+1): location + source + image binding }
```

If we collect mathematical formulas by scanning the buffer every single time, this effectively means that we must pass through a flickering gap window.

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

#flow-caption[N₀/B₀ denote the node/binding collections before scanning; N₁ denotes the node collection after scanning.]

Past approaches would use methods such as `hashmap` to reduce the intervening flicker gap and reuse assets as much as possible.
That is, through cache hits, the bindings before scanning are reattached to the nodes after scanning as much as possible.

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

The flicker problem can in fact be mitigated by reusing the rendered image from the previous version.
The more serious problem comes from the misalignment between assets and source code.

Its source is the same as in the previous version: after a node is displaced, the node's source code has already changed during the scanning stage, but because the new Tree-sitter span has not yet been computed, the position of the new image is unknown.
This causes misalignment.

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

Unlike flicker, this problem is hard to solve through hacks unless we can predict the user's behavior.
That can only be achieved in limited scenarios by intercepting user requests and similar means; it is extremely complex and extremely fragile.
After a large number of edit requests, it can also overload Neovim's thread and bring lag with it.

We can roughly abstract the mathematical formula rendering of the entire buffer as a combination of two basic operations:
- Editing a non-target node;
- Editing the source code of a node.

In Typst, the target nodes correspond to the `math` nodes for mathematical formulas and the `code` nodes for functions.

The second editing mode makes it very hard to avoid stale assets:
when we update the source code, the old asset inevitably becomes stale and needs to be updated through the renderer.
Of course, we can let "the old asset remain bound to the node while the new asset has not yet updated", but since the node itself is also changing, this faces a series of heuristic judgments.
Fortunately, in the actual editing process one necessarily looks at the source code, so when editing the source code of a node, we can temporarily avoid binding the asset on the node until leaving the node.

The first editing mode is completely different:
if the edit happens outside the formula, the asset itself has not changed.
At this point, the most ideal mode should be that the asset always moves with its bound node, instead of being constantly rescanned, rematched, and remounted during editing.
If we still rely on all kinds of heuristic behaviors to cover up flicker and geometric misalignment, then we have not solved the problem; we have only covered up this essential problem.

#remark[
  When using a coding agent for debugging, this behavior of covering up problems with heuristics often appears. This is not the agent's fault; after all, when the architecture is not being substantially changed, this kind of heuristic operation is the cheapest. Thanks to the agent's extremely high code-generation speed, in the short term it really can look as though the problem has been solved, but in the long term it leaves behind a mountain of "shit code".
]

= Image Assets Should Move with the Text Flow

The ideal approach should be this: for edits that do not change the source code of a node, treat the image asset as the same kind of resource as the text it is bound to.
When a text editing event happens in the editor, they should update at the same time.

For a text editor, text display should naturally satisfy this capability; otherwise, it is simply not a qualified text editor.

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

For example, when I insert text at `[cursor-position]` in

```text
Do not believe in [cursor-position]miracles; believing is itself a miracle
```

the subsequent "miracles; believing is itself a miracle" should be "pushed" backward, rather than overlapping with the text I just entered.
A mature text editor must have this function; otherwise, the text editor is unusable.

This model completely coincides with the image model:
- Unedited text $->$ image assets of unedited nodes;
- Editing other text makes unedited text move $->$ editing other text makes the image assets of unedited nodes move.

Therefore, if we can obtain the editor's mapping for "changes in text positions during edit events":

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

then converting `text-position` into the corresponding node can implement the displacement mapping of nodes during edit events.
Further, binding images can also implement the displacement mapping of a node's image asset during edit events.

The whole process does not need to use position-computation resources beyond the editor's own capabilities.
Therefore, in theory, its update-speed ceiling is equal to the text editor's own rendering-update ceiling.

#remark[
  Protocols such as the #link("https://sw.kovidgoyal.net/kitty/graphics-protocol/")[kitty graphics protocol], which locate mathematical formulas based on `placeholder`, naturally support "managing image positioning the way text positioning is managed", so the update speed of image assets is basically equal to the speed of updating text. By contrast, for protocols such as the #link("https://iterm2.com/documentation-images.html")[iTerm2 image protocol], which draw images directly based on terminal escape sequences, image positioning is not naturally part of Neovim's text layout system. We need to manually attach and detach image assets, so performance is worse.
]

= Returning to First Principles

This in fact determines a basic principle: we cannot locate mathematical nodes by directly parsing the source code.
Directly parsing the source code leads to the mismatch phenomenon described above.
What truly needs to be maintained is the geometric configuration inside the editor's rendering flow, which is then consumed by the subsequent UI pipeline.

At the implementation level, we need the text editor to expose the mapping of text position changes during edit events, or at least to let us piece together such a mapping ourselves.
Fortunately, Neovim has long provided an official means to express the behavior of elements moving along with text edit events: Neovim's extmarks give us geometric anchors that automatically evolve with text-flow edits, while events such as `on_lines` allow us to obtain the edited region for subsequent use.

However, knowing the text structure alone is not enough, because when we define nodes such as `math` and use them for image rendering, we inevitably need some semantic way to extract the code blocks whose positions may change during editing.
Tree-sitter in fact has exactly this capability, and this too is a native Neovim capability; we actually knew this from the very beginning.
But within the reasonable abstraction above, we finally put it in the right place, rather than trying to overstep and handle every editor event.

In this abstraction, the only thing we need to do is connect the two: semantically use Tree-sitter to preserve the structure of the nodes we need, and use extmarks in the editing flow to ensure that they evolve correctly along with text-flow edits.
Monkey-Patch? No such thing.
Heuristic search? Not needed.
Hook user keystrokes? You have overdesigned it.
A truly healthy design is never a pile-up of one script, logic block, and framework after another. Instead, before the ocean of details, it asks about the deep structure behind them and thinks: beneath these tangled and complex appearances, what is truly essential? When the tangled appearances are diminished and diminished again, the remaining "non-action" is precisely where much can be done.
