# Agent Notes

This repository is the Astro + Typst source for the Homeward Sky blog. Before changing the blog visuals, article pages, index pages, comments, Typst templates, or MathML rendering, read `docs/spec.md` and follow its design language and build experience.

Key reminders:

- Preserve the blog language: dark paper page, heavy typography, margin-note UI, compact and low-icon.
- The main source surface is `content/article/**/*.typ`, `typ/templates`, `src/layouts/BlogPost.astro`, `src/components`, and `src/styles/global.css`.
- MathML is the primary HTML output for article formulas; do not fix formulas with temporary character substitutions.
- Run `pnpm build` before release or deployable changes.
- Use Conventional Commits for commit messages, for example `docs: document blog design language`.
