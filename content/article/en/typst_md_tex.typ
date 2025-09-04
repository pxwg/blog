#import "../../../typ/packages/metalogo.typ": *
#import "../../../typ/templates/blog.typ": *
#import "../../../typ/templates/translation-disclaimer.typ": (
  translation-disclaimer,
)

#show: main.with(
  title: [Using Typst to Mark Everything Down, Instead of TeX Them],
  desc: [Affliction is Bodhi.],
  date: "2025-08-16",
  tags: (
    blog-tags.programming,
    blog-tags.typst,
  ),
)

#translation-disclaimer(
  original-path: "../../zh/typst_md_tex/",
  lang: "en",
)

#let blank(body) = {
  underline[~~~#body~~~]
}

#link("https://github.com/typst/typst")[Typst] is an excellent typesetting tool that I've integrated into every corner of my life since I first met it—from lecture notes and math drafts to this _blog post_ you're reading now.

= Where Typst Outshines LaTeX?

How does Typst differ from traditional LaTeX? Key advantages include: _Faster_ compilation (thanks to incremental compiling), _easier_ writing (modern syntax eliminates endless `\` commands), and _simpler_ installation.
But what about *typesetting quality*? Frankly, Typst doesn't yet surpass LaTeX here.
The main value lies in offering a smoother, more intuitive writing experience—not typesetting perfection.
For instance, with the #link("https://github.com/Myriad-Dreamin/tinymist")[Tinymist] language server, you get real-time previews, bypassing LaTeX's compile-to-view workflow (though projects like #link("https://github.com/let-def/texpresso")[TeXpresso] aim to close this gap).

As a young language (still v`0.x.x`), Typst has limitations and isn't widely adopted in academia where LaTeX dominates.
When replicating LaTeX layouts in Typst, I sometimes hit roadblocks—certain features simply aren't implemented yet.

After weeks of frustration, I realized: Typst isn't a LaTeX replacement today, at least for me, for now.
What draws me to it is its _accessibility_—perfect for blogs, notes, or homework solutions, not research papers.

= People Use LaTeX for Notes Because They ONLY Have LaTeX

Using LaTeX for notes forces focus on formatting over content. While its design aiming on separation of style/content helps, waiting for compilations invites distractions from alignment issues or package conflicts.
Simply put: LaTeX is overkill for notes. People use it only because Markdown lacks essential features, leaving no middle ground.

== Typst Bridges the Gap

Typst delivers a Markdown-like writing experience with live previews and straightforward syntax, while surpassing Markdown's capabilities through built-in features like mathematical typesetting, citation and more.
Crucially, it produces PDFs natively—unlike Markdown which relies on external conversion tools. This positions Typst as the ideal middle ground, whereas LaTeX remains fundamentally mismatched for simple note-taking due to its excessive complexity.

Historically (at least in my memory), physicists used typewritten text + handwritten formulas before adopting LaTeX for papers. Now, some misuse it for notes too.
LaTeX excels at paper typesetting but fails as a note tool. Markdown is lightweight but insufficient for academia.

Extending Markdown (e.g., adding math support) caused syntax fragmentation—the same markup behaves differently across tools.

Against this backdrop, Typst naturally emerges as the balanced middle path. Once we embrace this positioning, many perceived limitations cease to matter.
Concerned about typesetting instability? Remember that Markdown can't even maintain consistent rendering across different platforms.
Worried about the ecosystem? Consider what note-takers truly need: a digital pen for capturing thoughts, not an industrial pressroom for perfect typesetting.
While writing blogs or lecture notes—and even drafting papers—we don't require elaborate publishing tools.

= Affliction is Bodhi

While framing Typst as a LaTeX alternative, we're naturally drawn to the grand vision: a unified syntax for all scientific documents—simple to use, write, and read.
But this promise collides with reality during Typst's early development phase, where growing afflictions manifest as countless minor frustrations.
One solution is patience: waiting for Typst to mature over years, just as LaTeX did. Yet how much time can we reasonably invest?
Without perspective shifts, we risk drowning in perpetual afflictions.

The breakthrough comes when we reframe the problem.
Rather than chasing for a 'perfect' tools, examine actual needs: In daily workflows, we rarely require publishing-grade precision.
What truly matters is capturing thoughts and notes with a convenient, accessible tool.
This revelation transforms Typst from 'incomplete LaTeX' into 'supercharged Markdown.'
Suddenly, frustrations dissolve—or at least fade dramatically.
You'll celebrate Typst's elegant syntax, powerful features, and live previews, instead of fixating on its limitations.
