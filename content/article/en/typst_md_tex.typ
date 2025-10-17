#import "../../../typ/packages/metalogo.typ": *
#import "../../../typ/templates/blog.typ": *

#show: main.with(
  title: [Using Typst to Mark Everything Down, Instead of TeX Them],
  desc: [Affliction is Bodhi.],
  date: "2025-08-16",
  tags: (
    blog-tags.programming,
    blog-tags.typst,
  ),
  lang: "en",
  translationKey: "typst_md_tex",
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

== Typst = Markdown + CSS + Pandoc + ...

In the world of `Markdown`, the syntax itself (and its extensions) merely defines the structure of the content, imposing no constraints on its final appearance.
This separation of content and style can lead to a loss of control, as we've discussed.
However, this very "uncontrolled" separation can become a surprising advantage in certain scenarios.

Imagine you're writing notes in a low-light environment. Your IDE or text editor renders the page in a pleasant, aesthetically pleasing dark theme.
But then, recall your painful memories with LaTeX! The generated PDF preview right next to it is almost always black text on a white background (or a crudely inverted version), which feels jarring and uncomfortable to your eyes#footnote([Of course, I admit that modern PDF viewers like #link("https://sioyek-documentation.readthedocs.io/en/latest/")[Sioyek] and #link("https://pwmt.org/projects/zathura/")[Zathura] offer sophisticated color inversion. However, they each have their own issues with usability. For instance, the former often suffers from memory spikes and frequent crashes, while the latter can lose its reverse-search functionality. I acknowledge these might be my own problems, but they were certainly a motivation for me to change.]).

#image_viewer(
  path: "../assets/typst_md_tex_2.png",
  desc: [The PDF preview is uncomfortable when writing notes with LaTeX in a dark theme.],
)

Now, if you had a smart Markdown preview tool and a CSS stylesheet tailored for a dark theme, you could happily write your notes in dark mode without being disturbed by a glaring white PDF.

Trying to achieve this in LaTeX would require some rather complex packages to correctly determine at compile-time whether you're "previewing" or "printing"—the former needing a proper dark theme, the latter a traditional black-and-white style.
But in Typst, the compiler natively supports the `--input` argument. By passing `key=value` pairs, you can easily switch themes at compile time (for example, using ```typst #isDark=true``` to indicate a dark theme).
Next, in your template file, you can use ```typst sys.inputs``` to read the passed arguments and confirm if the dark theme should be rendered:

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

Then, you just need to define the corresponding color schemes to enable theme switching.

The common practice in the `typst` community today is to use the #link("https://github.com/Myriad-Dreamin/tinymist")[Tinymist] language server for real-time previews.
This language server opens a web server on a random local port, allowing you to preview your document live in a browser.
Since `tinymist` replicates Typst's compiler logic, you can pass the `--input` argument to apply different themes.
For instance, in the example above, you would simply add the `--input isDark=true` flag.

#image_viewer(
  path: "../assets/typst\_md\_tex\_1.png",
  desc: [The effect of a dark theme preview in Typst while writing this article.],
)

You might have noticed that the font and line spacing in my preview above are also different.
This, too, is achieved by cleverly using the `--input` parameter.
The benefit is that when I use a terminal-based viewer that supports the `kitty` graphics protocol, like #link("https://github.com/chase/awrit")[awrit], I don't have to repeatedly zoom in or crop the margins.

And so, with `typst`, we have easily replicated the functionality of `Markdown + CSS`.

Furthermore, as a markup language designed for typesetting, `typst` natively outputs `pdf` and, since `v0.10.0`, has added support for `html` output.
This allows `typst` to also function as a `Pandoc`-like tool, catering to the need for different output formats.


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
