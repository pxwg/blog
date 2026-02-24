Translate a Chinese Typst blog post to English, or vice versa

**Usage:** `/translate-post <source-path>`

**Example:** `/translate-post content/article/zh/zettel_typst.typ`

---

## Instructions

You are translating a Chinese (English) `.typ` blog post to English (Chinese). The blog uses Astro + Typst; posts live in `content/article/zh/` (Chinese) and `content/article/en/` (English).

**Argument:** `$ARGUMENTS` — the path to the source `.typ` file.

### Step 1 — Resolve paths

- Source: `$ARGUMENTS`
- Output: derive by replacing `content/article/zh/` with `content/article/en/` in the source path (keep the same filename).

### Step 2 — Read & check

1. Read the source file.
2. Check whether the output file already exists. If it does, warn the user and ask for confirmation before overwriting.

### Step 3 — Front matter transformation

Apply these rules to the front matter (the `#show: main*.with(...)` block and the `#let title` line):

| Element | Rule |
|---|---|
| `#import "..."` lines | Copy verbatim |
| `#let title = "中文"` | Translate the string value to English |
| `#show: main-zh.with(` | Change to `#show: main.with(` |
| `#show: main.with(` | Keep as-is |
| `title: title` | Keep verbatim |
| `title: [中文]` or `title: "中文"` | Translate the text content |
| `desc: [中文文本]` | Translate content inside `[...]` |
| `date:` | Keep verbatim |
| `tags: (...)` | Keep verbatim — `blog-tags.xxx` are already English identifiers |
| `lang: "zh"` | Change to `lang: "en"` |
| `region: "cn"` | **Remove this line entirely** |
| `translationKey:` | Keep verbatim |
| `llm-translated: false` | Change to `llm-translated: true` |
| `llm-translated: true` | Keep as-is |
| `llm-translated` absent | Add `  llm-translated: true,` as the last item before the closing `)` |

**Important:** `main-zh` is shorthand for `main.with(lang: "zh", region: "cn")`. After converting `main-zh.with(` → `main.with(`, always ensure `lang: "en"` is present in the argument list (add it if missing).

### Step 4 — Body translation

**Translate these elements:**
- Free prose paragraphs
- Heading text at all levels: `= 中文` → `= English` (preserve the `=` prefix and level)
- List item text (preserve bullet markers `-`, `+`, and indentation)
- `#footnote([中文])` — translate content inside `[...]`
- `#link("url")[中文展示文字]` — translate display text only; keep URL verbatim
- `desc:` string/content arguments in `#image_viewer(...)` and `#image_gallery(...)`
- Theorem/remark environment bodies: `#remark[...]`, `#definition[...]`, `#theorem[...]`, `#lemma[...]`, etc. — translate text content inside `[...]`
- `title:` string args in environments, if they contain Chinese
- `// 中文注释` line comments — translate the comment text

**Never translate these elements:**
- Math formulas: `$...$` (inline) and `$ ... $` (display) — copy verbatim
- Fenced code blocks `` ```lang ... ``` `` — copy code content verbatim
- Inline code `` `...` `` — copy verbatim
- `<label>` syntax and `@reference` syntax
- `blog-tags.xxx` identifiers
- `translationKey:`, `date:` values, URLs, file paths
- `#let` function/macro definitions (except the title string variable)
- Already-English technical terms (GitHub Copilot, Token, API, Compiler, Runtime, etc.)

**Special case — prose inside code fences:** When a code fence demonstrates a Chinese-language document (e.g., a Zettelkasten note with Chinese prose inside a ` ````typ ``` ` fence), translate the Chinese natural language content while preserving all Typst syntax tokens verbatim.

### Step 5 — Translation quality

- Preserve the author's voice and register (technical blog prose).
- **Use standard English technical terminology** — never translate professional terms to Chinese-derived approximations:
  - "态射" → "morphism"
  - "和乐" → "holonomy"
  - "贝里相位" → "Berry phase"
  - "配范畴" → "functor category"
  - "主纤维丛" → "principal fiber bundle"
  - "规范联络" → "gauge connection"
  - CS/programming terms that are already English (Token, API, Compiler, Runtime) — keep unchanged
- Render Chinese idioms as natural English equivalents that preserve meaning.
- Preserve emoji, paragraph boundaries, and list structure exactly.

### Step 6 — Write output

Write the translated content to the output path derived in Step 1.

### Step 7 — Report

After writing, report:
- The output file path
- Any judgment calls made during translation (ambiguous terms, idioms rendered non-literally, etc.)
- A reminder to run `pnpm build` to verify the post compiles without errors
