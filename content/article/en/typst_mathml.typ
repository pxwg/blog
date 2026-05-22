#import "../../../typ/templates/blog.typ": *

#let title = "Migrating Typst Blog Math from SVG to MathML"
#show: main.with(
  title: title,
  desc: [I migrated the math rendering in my Typst-based blog from SVG to the new MathML output path in Typst.],
  date: "2026-05-23",
  tags: (
    blog-tags.software-engineering,
    blog-tags.programming,
    blog-tags.typst,
  ),
  lang: "en",
  translationKey: "typst_mathml",
  llm-translated: true,
)

= Origin

Most articles on my blog are written in Typst and then rendered into a static site through Astro.
This setup has been convenient for a long time: when writing mathematical articles, I can use Typst's formula syntax and template system, while the published result is still an ordinary web page.
The awkward part has always been math in HTML.

Previously, formulas on the blog mostly went through SVG.
Typst typeset the formula, exported an inline SVG fragment, and the web page inserted that SVG back into the article body.
Visually, this worked quite well.
For many complex formulas, the SVG version stayed close to the PDF output.
But SVG is still an image.
To the browser, the formula is a set of graphic paths, so screen readers, copying, search, and semantic structure all need extra work.

Recently, Typst's main branch merged #link("https://github.com/typst/typst/pull/7436")[MathML Core output for HTML export].
I did not immediately realize that I could wire it into my own blog.
After reading #link("https://www.reddit.com/r/typst/comments/1tfoc08/native_typst_to_mathml_in_my_blog/")[a Reddit post about using native Typst-to-MathML in a blog], I realized that this path was already practical enough to try.
So I decided to move the current blog's formula rendering from SVG to MathML.
The migration took a few hours, mostly spent with Codex reading the current templates, adjusting the `astro-typst` patch, fixing CSS, and repeatedly checking real articles.

= The Old SVG Path

The SVG path originally solved a very practical problem: Typst's HTML target was still unstable, but I wanted the math in the blog to look close to Typst/PDF output.
Exporting formulas as SVG was the straightforward choice.
SVG has had solid browser support for years, so as long as Typst produced the right graphic, Chrome, Safari, and Firefox usually behaved predictably.

Inline formulas were more annoying.
A formula looks like a small image, but it occupies a character position inside a sentence.
If the bottom of the SVG is aligned directly with the bottom of the text, a formula such as $A = frac(1, z-w)$ tends to sink.
If I simply scale it down, the formula no longer matches the surrounding text size.

So I used to maintain a baseline alignment patch.
The idea was to put an invisible baseline marker into the formula SVG, then parse the SVG `height`, `viewBox`, and marker position during `astro-typst` output, and finally write the result back into `vertical-align`.
The code felt roughly like this:

```typescript
const INLINE_MATH_BASELINE_STROKE = "#ff00ff";

function getInlineMathBaselineShift(fragment: string) {
  const marker = new RegExp(
    `<svg\\b([^>]*)>[\\s\\S]*?<g transform="translate\\(([-+\\d.]+) ([-+\\d.]+)\\)">\\s*<path\\b(?=[^>]*stroke="${INLINE_MATH_BASELINE_STROKE}")`,
  ).exec(fragment);
  // height/viewBox conversion omitted
}
```

This patch fixed the position of inline formulas.
But it also meant the formula rendering had two layers: SVG for the visual result, plus an extra MathML layer for accessibility.
That came with maintenance cost.
Once Typst changed its output structure, or some package show rule affected the formula structure, debugging required looking at SVG, auxiliary MathML, CSS wrappers, and Astro output at the same time.

= Trying MathML

I had tried #link("https://codeberg.org/akida/mathyml")[mathyml] before.
Its approach is to convert formulas into MathML in Typst through show rules.
I kept that experiment around for a while, but it did not work especially well for my blog, mainly because complex formulas and third-party Typst packages exposed small edge cases.
That attempt still confirmed one thing for me: MathML was a viable direction, but if the conversion logic lived in the template layer, complex formulas still felt a bit shaky.

This time the situation changed.
Typst itself now outputs MathML Core in its HTML export path, so the conversion happens inside the compiler's math output path.
The blog template no longer needs to guess Typst's math structure or maintain a third-party conversion rule.

The first step was to make `astro-typst` use a Typst compiler package that contains the MathML output.
In this repository, that is done through overrides in `pnpm-workspace.yaml`:

```yaml
overrides:
  '@myriaddreamin/typst-ts-node-compiler': npm:@wybxc/typst-ts-node-compiler@0.7.1
  '@myriaddreamin/typst-ts-renderer': npm:@wybxc/typst-ts-renderer@0.7.1
  '@myriaddreamin/typst.ts': npm:@wybxc/typst.ts@0.7.1
patchedDependencies:
  astro-typst@0.12.3: patches/astro-typst@0.12.3.patch
```

The second step was to adjust the Typst template.
In `typ/templates/shared.typ`, formulas under the HTML target are handed directly to Typst's HTML export:

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

`visible-mathml` itself does not do much:

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

The main point is to wrap formulas in stable classes.
The actual MathML is emitted by Typst's HTML export.

= The `astro-typst` Patch

The `astro-typst` side still keeps a patch.
I did not reimplement MathML conversion there, only made a few small fixes.

First, display formulas need `displaystyle="true"`.
Otherwise some browsers typeset display math closer to inline math.
So after producing HTML, the output goes through this replacement:

```typescript
output = output.replaceAll(
  '<math display="block"',
  '<math display="block" displaystyle="true"',
);
```

Second, Typst compilation or HTML export failures should throw directly.
Previously, `astro-typst` could return empty HTML, which is hard to notice during a blog build.
During this migration, I wanted it to fail loudly instead of deploying an empty article:

```typescript
if (!docRes.result) {
  logger.error("Error compiling typst to HTML");
  docRes.printDiagnostics();
  throw new Error("Failed to compile Typst HTML output.");
}
```

Finally, the old SVG baseline fix still exists in the patch.
The main article math path now uses MathML, but some old wrappers or special HTML frames may still go through the SVG path.
I am keeping that code for now and will remove it later if there is really no remaining use case.

= Debug

The part that took the most time was CSS.

Right after switching to MathML, some formulas looked cramped in Chrome, especially tall display formulas.
It was tempting to blame Chrome first.
Chrome's MathML support is indeed weaker, and the same article usually looked better in Firefox.
But this bug was not that simple.

We built a minimal reproduction: put the same MathML into an empty HTML page, then put it back into the full Astro page.
The empty page looked normal.
Only the full page broke.
After stripping CSS further, we found the main cause: I had put `Libertinus Math` into the global `math` font stack:

```css
math {
  font-family: "Libertinus Math", math;
}
```

With Chrome's native MathML plus this font, display formulas in the `bare` comparison were compressed badly, and the integral sign became short as well.
At the same 16px size, the first integral was around `46.83px` tall with the browser default `math` font and with `STIX Two Math`, but only `28.75px` with `Libertinus Math`.
At 24px, the same pattern remained: browser default `math` / `STIX Two Math` were around `70.22px`, while `Libertinus Math` was around `42.92px`.
The reproduction looked roughly like this.
The two display formulas in the left `bare` comparison are visibly too small:

#figure(image("../assets/mathml_integral_debug.png", width: 100%))

The blog's global styles contain many rules meant for normal prose: fonts, line height, wrapping, image size, and overflow.
They make sense for paragraphs, images, and code blocks, but inheriting them into `math` can break things.
The final fix was to stop using `Libertinus Math` for display MathML and let it use the browser default `math` font or `STIX Two Math`.
The body text can still use Libertinus Serif.
There was also a secondary issue: the wrapper around display formulas must not clip vertical overflow, otherwise tall formulas may get scrollbars or be cut off.
So MathML now has a few dedicated CSS rules:

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

The important points are simple.
The `math` element should not inherit prose-oriented forced wrapping rules.
The outer display-math wrapper also should not clip `overflow-y`.
Some formulas are simply taller than an ordinary line box, and clipping them makes the browser look guilty even when the real bug is CSS.

= Result and Trade-Offs

After the migration, the overall visual result is close to the SVG version.
It looks especially good in Safari.
Chrome still has a few rough edges, but it is good enough for my use.
For me, the main gain is that formulas return to the semantics of the web.
Copying, assistive technology, and browser-native processing all feel more natural than treating formulas as images.

The biggest lesson from this migration is not to stare only at formula conversion.
The real time usually goes into the boundaries: how the Astro plugin handles failures, whether CSS leaks into MathML, and whether the browser picks the wrong math font.
Once those boundaries are handled, switching to MathML is not as complicated as I had expected.
