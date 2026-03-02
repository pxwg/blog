Enrich a Typst blog post with hyperlinks to named products, tools, and services.

**Usage:** `/link-enricher <file-path>`

**Example:** `/link-enricher content/article/zh/bilibili_coding_stream.typ`

---

## Instructions

**Argument:** `$ARGUMENTS` — the path to the target `.typ` file.

Use the Agent tool to launch the `link-enricher` agent with the following prompt:

```
Please enrich the Typst blog post file at `$ARGUMENTS` by finding key product, app, company, or project names and adding hyperlinks to their official websites using Typst's `#link("url")[name]` syntax.

Read the file first, then identify all significant named entities (AI tools, developer tools, apps, platforms, open-source projects, companies, etc.) that appear without an existing `#link(...)` wrapper. Verify official URLs and apply changes. Only link the first meaningful occurrence of each entity; skip entities inside code blocks, front matter, and template calls.

After editing, provide a Link Enrichment Report summarizing: links added, already-linked entities left unchanged, and any skipped/ambiguous entities.
```
