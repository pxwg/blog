#import "../../../typ/templates/blog.typ": *
#let title = "Zettelkasten Forest's Self-Growth"
#show: main.with(
  title: title,
  desc: [Using Zettelkasten methodology with AI collaboration to achieve self-growth of a Typst note-taking system.],
  date: "2026-02-15",
  tags: (
    blog-tags.software-engineering,
    blog-tags.programming,
  ),
  lang: "en",
  translationKey: "zettel_typst",
  llm-translated: true,
)

// {content: start}

There are many Markdown-based Zettelkasten note-taking systems on the market, the most famous being Obsidian. However:
- I don't want to use Markdown.
  - As I discussed in #link("../typst_md_tex")[this article], Typst is a more powerful hybrid of Markdown and LaTeX, offering stronger expressiveness and better readability. I wanted my Zettelkasten note-taking system to write notes directly using Typst.
  - Since my blog and thematic notes are written in Typst, maintaining the same technology stack would allow seamless integration between note organization and blog writing, improving efficiency.
- I wanted a Zettelkasten system based on my personal editing environment.
  For me, that's Neovim.

The benefit of Neovim is its high extensibility; the drawback is that we need to implement the features ourselves. Fortunately, with AI Agents available now, we can achieve very high efficiency on script-type, personal development environments. The key challenge lies in practicing #link("https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents")[Context Engineering]. The central insight I want to convey with this blog is that *the context needed to build a Zettelkasten note-taking system can itself be built through the Zettelkasten note-taking system*.

= What is Zettelkasten

You can refer to #link("https://zettelkasten.de/overview/")[this overview] for a good introduction. Here I'll provide only a very brief introduction:
- Zettelkasten is a German word meaning "slip box"
- The objects within this "slip box" are a series of "slips," which carry information on a single topic—such as a concept, an idea, or a question—called "atomic" notes
- We've mentioned objects, and naturally there should also be morphisms. Morphisms in Zettelkasten are links, which build relationships between notes. For example, when writing notes about the relationship between Flat Connection and Local Systems, I might write:
  ```typ
  = Flat/Integrable Connection and Local Systems <2602151850>
  #tag.geometry

  Let $X$ be a complex-analytic variety.
  The following are equivalent:

  - Local system $->$ Holomorphic vector bundle + Flat connection
    - The complex @2602150951 $V$;
    - The @2602151916 $cal(V) = cal(O) times.o V$ endowed with its canonical connection.
  ```
  Here `@2602151916` and `@2602150951` are links pointing to the note objects for "Holomorphic vector bundle" and "Local system" respectively. This way, we:
  - When writing, don't need to repeat the definition of these concepts in each note, saving time and ensuring consistency
  - When reading, if uncertain about these concepts, can quickly jump to related notes via links; if familiar, can skim over them

#image_viewer(
  path: "../assets/zettel_typst_1.png",
  desc: "Example of Zettelkasten notes. I configured Neovim Extmarks to display linked note titles overlaid on the links, maintaining link uniqueness while improving readability.",
)

This perhaps feels very familiar: indeed, Wikipedia, nLab, and Stack Project all use this Zettelkasten methodology:
- Each entry atomically carries a single concept
- Links build associations between different concepts
In a sense, building a personal Zettelkasten note-taking system is building a personal Wikipedia/nLab/Stack Project.

= Growth of the Zettelkasten Forest

Like all AI coding projects, the biggest challenge is designing good prompts. In our project, prompt design manifests in two aspects:
- Long-term battles: We have a long-term maintenance project, meaning each new AI session faces a fresh AI Agent as a stateless object. We need to manually maintain a massive context, including:
  - Overall project architecture, containing the project's vision and structure
  - Current development progress, including completed and pending features
- Short-term tasks: Iterating on the note-taking system isn't our main occupation; agile development with AI participation is the only way to keep notes evergreen

We notice that requirements for building a note-taking system are inherently "atomic," describable through single-topic language. For example: "add a keyboard shortcut," "add a feature to Telescope plugin," etc. However, when we need to feed these "atomic" requirements to AI, we must include their dependencies. This actually aligns well with the core principle of Zettelkasten: each note is an independent atomic object, with relationships between them built through links. This is why we use Zettelkasten methodology to implement context engineering.

Now let me demonstrate how I combine Zettelkasten methodology with AI to achieve self-growth of the note-taking system.

First, we need an idea, which in Zettelkasten methodology corresponds to a note. Of course, we're now in the "primordial" stage with nothing yet, so we need to build a basic project structure ourselves. My plan is to build my knowledge base in the `~/wiki/` directory, containing some entry and template files, with the main content in `~/wiki/note/`, using timestamps as filenames, like `2602151850.typ`. Writing down this "idea" becomes our first note in this Zettelkasten system (since it's primarily terminal-oriented, ASCII-style tree structures suffice):

#remark[For convenience, all tags here are written in the format `<1>` rather than proper timestamps, mainly for reader comprehension.]

````typ
= Typst ZK Note Taking <1>

We want to build a `Typst`-based ZK note-taking system to manage our notes and knowledge base.

== Structure

The structure under `~/wiki/` is as follows:
```
wiki/
├── index.typ
├── link.typ
├── note/
│   ├── 2602072319.typ
│   ├── 2602082037.typ
│   ├── 2602082106.typ
```
`index.typ` is the entry file for the entire wiki, containing all function calls, style configurations, and definitions. `link.typ` contains all `#include` statements for notes under `note/`. Each `.typ` file in the `note/` directory is a note with the filename being its timestamp in `yyMMddHHmm` format.
- The format of `#include` statements is `#include "note/xxxx.typ"`, where `xxxx` is the note file's timestamp in `yyMMddHHmm` format
- The overall structure is:
```typ
// index.typ
// ... other content ...
#include "note/<YYMMDDHHMM>.typ"

// note/YYMMDDHHMM.typ
#import "../include.typ": *
#show: zettel

= Note Title <YYMMDDHHMM> // Note title updated by user, label auto-generated by system
@YYMMDDHHMM linking to other notes
```
````

Now we need to continue thinking within this topic. First, I realize I need some scripts to help me:
- Auto-compile `link.typ` to include `#include` statements for all notes in the `note/` directory
- Implement keyboard shortcuts in Neovim to help CRUD note content and search notes
- Implement forward and backward navigation to help jump quickly through dependencies

Recording all of these in the note above, I can start initial development.

The first two tasks seem straightforward. To help AI understand what we're doing, suppose we want to write a `lua` script to implement the second feature as a Neovim plugin. We can write a new note describing this feature (in my practice, I actually separated several notes to manage these features; here we'll keep them together):

````typ
= ZK and Neovim Tools <2>

We need to build editor workflows. Current specifications reference @1

Automating this workflow requires:
- Auto-generate id based on current date/time, create corresponding `.typ` file, open for editing
- When creating the file, automatically add `#include` statement in `link.typ` to reference this note

This will be implemented as Neovim scripts:
- [ ] `ze` combines link relationships, exports all directly or indirectly dependent notes from current note, copies to clipboard for AI context
- [ ] `zn` triggers note creation workflow
  - `cd` to `~/wiki/` directory, execute note creation commands, including:
    - [ ] Generate id, create file from template, open for editing, cursor at title
    - [ ] Add `#include` statement in `link.typ`
- [ ] `zs` binds to Telescope plugin, search notes by title etc., jump after selection
- [ ] `zr` binds to delete current note, requires:
  - [ ] Delete current note file
  - [ ] Remove corresponding `#include` statement in `link.typ`
````

Now we can start! Since `ze` isn't written yet, we still need to manually copy the content of two notes to clipboard to provide to AI. But every beginning is hard—once we get this initial goal done, it'll go faster later.

After editing several notes, I found writing `- [ ]` extremely tedious, having to manually input `[ ]`. Not letting this idea slip, I recorded it:

````typ
= ZK TDL Keymap <3>
#tag.done

The Neovim plugin in @2 still needs:
- [x] Quick-add `- [ ]` to mark TODOs (`ctrl+t`), and use keyboard shortcut to toggle `- [ ]` and `- [x]` to mark completion status (if already exists, use `ctrl+t` to toggle)
````

Directly call `ze` to export current note and context, hand to AI to complete and verify.

As I wrote more, I found the `@yyMMddHHmm` format, while convenient for indexing, wasn't convenient for reading notes. I noticed Neovim can use Extmarks to draw additional content on buffers, and the idea suddenly emerged: use Extmarks to display note titles over `@yyMMddHHmm`, maintaining filename uniqueness and indexing convenience while making note content more readable. Not letting this idea slip, I created a note to record it:

````typ
= Extmark and ZK Link <4>

- [ ] Use Neovim's Extmark functionality to display `@yyMMddHHmm` format as corresponding note titles, e.g., `@2602151850` displays as `@Flat/Integrable Connection and Local Systems`, improving note readability.
````

Directly call `ze` to export current note and context, hand to AI to complete and verify.

Writing further, I realized I might need tags to mark note status and category, like `todo`, `wip`, `neovim`. This can be implemented directly in Typst template functions. Of course, I also need to implement tag-based search in Telescope, so I add another note:

````typ
= ZK Tag Search <5>

We need to add to the Neovim plugin in @2:
- [x] Tag-based note search functionality using Telescope
  - After `zs` opens Telescope, press `ctrl+t` to switch search modes; after switching to tag search mode, input tag name to search corresponding notes
````

Export context and continue implementation.

Gradually, we discover that through continuous use of this system:

- Since the barrier to creating notes is removed at the first step, we can quickly record ideas, forming atomic note objects
- Improvement ideas arising during note use are continuously recorded, forming atomic feature requirement objects
- By continuously linking them during writing and organization to previous note objects, we form linking-relationship objects, constituting complete requirement documentation
- We feed this context-containing, atomically-organized documentation to AI for implementation
Finally, through:
- Good note structure and format design
- Disciplined recording norms and linking habits

We almost effortlessly, very naturally built a Typst-based Zettelkasten note-taking system and achieved its self-growth through AI Agents.

Since feature additions are recorded as atomic note objects in the Zettelkasten system, whenever we want to add a feature, we simply create a new note describing it. Compared to creating new Prompts and Context for each feature, this approach has far less friction and higher efficiency.

Of course, this construction is just the beginning; many ideas remain to implement: multi-device sync, LSP-based link forward/backward navigation, tag-based smart search, and more. These can all be implemented the same way: record them as atomic note objects, build relationships through links, and finally hand to AI for implementation and verification. I've implemented all these features, but since they involve considerable technical details, they might be better showcased in follow-up articles.
