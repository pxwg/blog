# Homeward Sky Blog Spec

This document records the current blog design language and build constraints. Before changing article pages, index pages, comments, Typst templates, or MathML styling, use this as the calibration point instead of treating the site as a generic Astro blog template.

## Design Language

Homeward Sky should read like a quiet paper page, not a dashboard, landing page, or component showcase. The page should feel like long-form typesetting on dark paper: centered content, restrained measure, relatively dense typography, and UI that steps back so the article itself remains the main visual surface.

Core vocabulary:

- Paper feel: the dark theme uses a warm paper-like background and warm light text; the light theme stays clean and page-like. Avoid decorative gradients, floating cards, glass effects, and large colored panels.
- Heavy typography: body text is based on Libertinus / Source Serif / Song-style serif stacks, with JetBrains Mono for code. Headings are restrained, while body line-height and paragraph spacing are tuned tightly enough for a scholarly manuscript feel.
- Margin-note UI: notices, translation notes, search controls, article lists, theorem/example/proof blocks, and comment forms should continue the same language: left rule, transparent background, compact text.
- Low icon density: navigation and tools prefer text. Aside from existing theme switching and necessary semantics, do not introduce icon buttons, badge piles, emoji markers, or decorative illustrations. The theorem-like Typst blocks intentionally clear their icon value; that is a design decision.
- Unified links: links use pink underlined text. Hover may deepen the color or underline thickness, but links should not become buttons, pills, or cards.
- Restrained cards: do not wrap article pages, lists, or comment regions in layered cards. Real repeated items or compact tool areas may have structure, but the default vocabulary is transparent background, left rule, and typographic hierarchy.
- Compact but readable: the overall density is high, but it must not compromise mathematical formulas, Chinese line breaking, mobile inputs, or article metadata.

## Implementation Anchors

The main style sources are:

- `src/styles/global.css`: global colors, font stacks, content width, body typography, links, code, blockquotes, MathML, and list-style left rules.
- `src/layouts/BlogPost.astro`: compact article title area, date/view/like metadata, translation entry, tags, and comment-region layout.
- `src/styles/IndexPostList.css`: margin-note style for the article index search controls and list items.
- `src/components/Header.astro`: text-only navigation, site mark, language switching, and low-UI theme switching.
- `src/components/TranslationLink.astro`: transparent translation notice with a left accent rule and small explanatory text.
- `typ/templates/shared.typ`: Typst-to-HTML/PDF rules for body text, headings, code, images, translation notices, theorem environments, collapsible proofs, and MathML output.
- `typ/templates/math-baseline.typ` plus the MathML section in `src/styles/global.css`: formula rendering, selectable assistive layers, display math overflow, and baseline handling.

Concrete constraints the current design relies on:

- The main content column is about `52rem`, with responsive gutters for mobile.
- Body text defaults to `20px` and `line-height: 1.55`; paragraph and heading spacing stay compact.
- Inline code is transparent, lightweight monospace text, not a bordered pill.
- Code blocks may have a subtle background, but should not become strong decorative cards.
- MathML is the primary HTML output for article formulas; KaTeX CSS remains for comment compatibility.
- Display MathML must allow vertical overflow so tall formulas are not compressed by inherited font or line-height rules.
- Comments, translation notices, article index search, and theorem-like blocks share the transparent-background plus left-rule vocabulary.

## Build And Maintenance Experience

Stable rules from past build work:

- The article rendering surface includes `content/article/**/*.typ`, `typ/templates`, `src/layouts/BlogPost.astro`, `src/components`, and `src/styles/global.css`.
- Generated `dist/` output and Memory Dream artifacts are read-only consumption output, not design source.
- Temporary debug pages are useful for MathML / Astro rendering investigations, but must not remain in release output.
- When debugging MathML, compare the full Astro article page with a minimal MathML reproduction. Many failures come from inherited site CSS rather than MathML itself.
- Do not fix formulas with ad-hoc semantic substitutions, such as replacing a mathematical letter with a plain character. Fix the Typst compatibility layer, MathML output, or CSS constraints instead.
- When touching third-party Typst packages, avoid leaving detached submodule changes that CI cannot fetch. Small compatibility fixes should prefer a repo-owned wrapper.
- Run `pnpm build` before release or deployable changes. If a submodule changes, commit and push the submodule first, then update the parent repository pointer.
- Commit messages must follow Conventional Commits, for example `docs: document blog design language`, `fix: preserve MathML display overflow`, or `feat: add article search controls`.

## UI Change Rules

For any new blog UI, first ask whether it can be expressed as part of the paper-like typographic system:

- Prefer text, rules, font size, font weight, spacing, and underlines for hierarchy.
- Controls should be transparent, compact, and close to body typography. Inputs should use underlines or left rules, not rounded pills.
- On mobile, preserve content width and input usability; stack controls vertically when needed.
- New components should reuse `--accent`, `--gray-color`, `--main-color`, `--main-bg-color`, `--vp-font-family-base`, and `--vp-font-family-mono`.
- Unless the article content itself needs images, do not add decorative images to the site frame just to make it feel richer.
- All design changes should be checked in light and dark themes, Chinese and English articles, mobile layouts, long math formulas, and the comment area.

## Anti-Patterns

Avoid these directions:

- Wrapping articles, search, comments, or theorem blocks in layered rounded cards.
- Introducing icon-heavy toolbars, badges, chips, hero sections, or dashboard-like information cards.
- Using strong gradients, large color panels, glass effects, shadows, or illustrations that overpower the prose.
- Turning inline code into high-contrast pills.
- Adding unexplained character substitutions or browser-specific hacks for math rendering.
- Breaking MathML selection, accessibility, or display-math overflow behavior for a local visual effect.

## Git Conventions

Use Conventional Commits for every commit:

- Format: `<type>(optional-scope): <description>`.
- Keep the description imperative, concise, and lower-case unless a proper noun requires capitalization.
- Common types for this project are `docs`, `fix`, `feat`, `refactor`, `style`, `test`, `build`, and `chore`.
- Use a body when the reason, migration notes, or verification details matter.
- Prefer a focused commit that describes the user-facing or maintenance intent, not a file-by-file inventory.
