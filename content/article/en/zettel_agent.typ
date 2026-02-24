#import "../../../typ/templates/blog.typ": *

#let title = "Let Claude Code Be the Gardener of the Zettel Forest"
#show: main.with(
  title: title,
  desc: [Combining the Typst Zettelkasten note system with Claude Code skills and agents reduces the friction of note maintenance to a minimum, bringing thinking back to center.],
  date: "2026-02-24",
  tags: (
    blog-tags.software-engineering,
    blog-tags.programming,
  ),
  lang: "en",
  translationKey: "zettel_agent",
  llm-translated: true,
)

In the #link("../zettel_typst")[previous article], I introduced my Typst-based Zettelkasten note system, but it's not without challenges.

Moving from the passion of a moment to long-term persistence and finally stable implementation requires wisdom. The Zettelkasten method can theoretically greatly improve thinking efficiency, which can give people infinite passion. But in actual use, maintenance costs increase linearly with the number of notes: after writing a new note, you need to manually add an abstract, keywords, check associations with other notes, execute tasks mentioned in the note, etc. These management tasks gradually erode the time that should be used for thinking.

This contradiction becomes especially apparent when notes exceed one hundred. I began to understand why Niklas Luhmann needed an assistant: the maintenance cost of the card box is proportional to the number of cards; beyond a certain scale, one person finds it difficult to bear this burden.

The difference is, my assistant doesn't need to be human (at my current stage, it's also hard to find a human assistant).

= Automation

== AI for Automation

AI and programming actually have many similarities; the key point is that both can achieve abstraction of the `输入`-`输出` structure, i.e., through some explicit or implicit pattern, provide a reasonable response to input. Therefore, in principle, as long as a specific scenario can be abstracted into an `输入`-`输出` structure and the validity range of the output is defined, this scenario can be automated via AI or programming.

The difference between AI and programming is that AI has a more flexible input-output structure: AI doesn't need to predefine a fixed input-output structure but can dynamically adjust the format and content of inputs and outputs based on actual situations. This gives AI greater adaptability when dealing with complex and changing scenarios.

The price of flexibility is greater 'unpredictability'; compared to programming, AI output may have more variables and uncertainty. Therefore, to achieve AI automation, we must

- Provide controllable `输入`, which in the AI field is called `Context`, or `上下文` (context), serving as the basis for AI's reasonable responses. This is the fundamental idea behind #link("https://code.claude.com/docs/en/skills")[Skills].
- Provide quantifiable `输出`, which will become the metric for systematically evaluating responses. An ideal framework is that if the metric is not met, output will be prohibited, and the AI will be asked to regenerate until the metric is satisfied. One implementation method is called the sub-agent loop, where two agents are set up: a task execution agent and an evaluation agent; the former is responsible for generating output, the latter for evaluating whether the output meets the metric; if not, it asks the former to regenerate until satisfied. This approach can effectively control the quality and reasonableness of AI output, thereby achieving AI automation.

Adhering to these two abstractions, we can use AI to achieve automation 'with a certain degree of freedom.'

== Problem Identification

My Typst Zettelkasten system is already quite mature: each note is named with a timestamp (`yyMMddHHmm.typ`), references each other via `@timestamp`, and the system automatically generates backlinks. The note header has a standard Metadata block: Aliases, Abstract, Keyword. Combined with Neovim and Tinymist LSP, the experience of writing a single note is smooth.

But maintaining the entire system is another matter. I identified four main friction points and built a Claude Code Agent with corresponding Skills for each. These four friction points correspond to the four nodes of creating and traversing the Zettelkasten note system:
- In writing, while writing notes without pressure, I need to reduce the mental burden of creating Metadata.
- In organization, I hope that while given known or 'controllable' knowledge connections, I can discover those 'hidden' connections. This is actually the core value of Luhmann's card box: stimulating new insights by juxtaposing cards on different topics.
- In execution, as I mentioned in the #link("../zettel_typst")[previous article], I found that Zettelkasten notes can be used as a task management tool, providing suitable context for AI. If the Zettelkasten note system can be transformed into a task execution system, the barrier between thinking and execution will be further broken down, improving efficiency.
- In output, people often point out that Zettelkasten notes are 'writing-oriented,' but in fact, starting from known nodes and themes, constructing a linear rather than networked narrative for a blog still requires a lot of repetitive work (e.g., manually traversing notes, selecting material, organizing structure, polishing language). If AI can take on these repetitive tasks and establish the architecture, writing a blog becomes much easier.

== Metadata Generation

Each of Luhmann's cards had handwritten index marks. This is the prerequisite for the card box to be searchable. In my system, this corresponds to the Metadata block:

```typ
/* Metadata:
Aliases: ZK Metadata Agent, Metadata Generation Skill
Abstract: This note describes the design and implementation of a Claude Code Skill for automating Zettelkasten metadata generation.
Keyword: Zettelkasten, metadata generation, Claude Code, automation
Generated: true
*/
```

Writing these by hand is extremely tedious. A note's abstract often requires reviewing other notes it references to write accurately; keyword selection must consider the global context. This is precisely what LLMs excel at: they can 'see' a note and its surrounding reference network simultaneously.

I chose the *Sub-agent loop* architecture. The main Claude discovers all pending `.typ` files via `git status`, launching an independent Sub-agent for each file. Each Sub-agent first calls `zk_context_builder.py` to build the note's local context—including the titles, Metadata, and content of notes it references and notes that reference it—then generates Metadata based on this context and writes it to the file.

Initially I tried having one Agent batch-process all notes, resulting in note A's keywords ending up in note B's abstract. One note per Sub-agent, context isolated, the problem disappeared.

Idempotency protection is a key design: if the file already has Metadata and lacks the `Generated: true` marker, it indicates user-written content, and the Agent skips it. Only system-generated Metadata is allowed to be overwritten. This rule prevents the automation pipeline from swallowing carefully crafted manual abstracts.

== Hidden Link Discovery

There's a subtlety in Luhmann's card box: he didn't just store cards by topic but deliberately created 'unexpected adjacencies.' A card about the legal system might be placed next to a card about biological evolution, and it's precisely this juxtaposition that sparks new insights.

But discovering such associations heavily relies on familiarity with the entire system—you must remember what you wrote three months ago to connect it with today's new idea.

My solution is to give the AI an 'index catalog.' `zk_build_catalog.py` traverses all notes, extracting each note's ID, title, and Metadata into a compact plain‑text catalog, totaling just a few thousand tokens. The Agent receives the target note's full content plus this Catalog, identifies potential related notes via semantic analysis, and returns a list of suggested link IDs.

A necessary filtering step: before analysis, exclude notes that the target note already references and notes that already reference it, recommending only truly 'hidden' associations. You wouldn't want an assistant telling you things you already know.

This agent is like a librarian who has read all the cards, responsible for reminding you when you write a new card: 'Hey, you previously wrote a related card that might inspire this new idea!'

Of course, this design currently only supports a relatively small number of notes; if the system scales to thousands of notes, more complex indexing and retrieval mechanisms may be needed, such as `VectorDB`. But at the current scale, directly feeding the Catalog as context is the simplest and most effective solution.

== Task Workflow

My notes are mixed with a large number of to‑do items. A note may both describe a technical concept and list three checklists that need to be implemented. This is actually what I mentioned in the #link("../zettel_typst")[previous article]: the context needed to build a Zettelkasten note system can be built through the Zettelkasten note system.

The `/zk-do` Skill automates this switching. The user starts Claude Code via `claude --add-dir ~/wiki/`#footnote[It must be mounted via the `--add-dir` parameter at startup; the `/add-dir` command within a session cannot be used, otherwise Skills won't be loaded correctly.], then specifies a note with `/zk-do @id`. The Agent reads the note content, obtains context via the context builder, goes to the corresponding code file, and executes the task described in the note.

After completion, it automatically changes `- [ ]` to `- [x]` and updates the tag from `#tag.wip` to `#tag.done`. The most valuable step occurs at the end: the Agent appends implementation remarks to the note, recording what was actually done, and if the original plan was adjusted, the reason for the change.

When AI executes tasks, it often discovers that the original conception is unreasonable; without leaving this record, looking back at the note would be confusing: the task description says A, but the implementation is B. This change log is precisely what Luhmann called a 'conversation with the card box': you write down an idea, the system (now AI) gives a response, and the traces of the conversation remain on the card itself.

#remark[
  Of course, I've always been wary of the pollution and chaos caused by AI directly modifying notes; even for metadata, we designed strict idempotency checks. For the task execution scenario, the risk of AI directly modifying notes is greater, necessitating
  - Isolating the Context of AI modifications.
  - Using scripted methods for modifications rather than relying on AI's natural language generation capabilities.
]

== Blog Generation

This is the most complex of the four agents and the closest to the scenario of 'an assistant helping Luhmann write a paper.' Of course, I don't expect (even if I give it all the context) that AI can directly produce a high‑quality blog, but I hope it can at least generate a readable draft, saving me a great deal of repetitive work.

The essence of Zettelkasten is the strong connectivity of a single atomic note to its associated network. To maximize this characteristic, the task input should not be an isolated note but a Context Pool built around the core note. A script extracts the Metadata and body of all related notes in the reference network, packaging them as material for the Writer Agent. The Writer can create based on this Context Pool, maintaining content richness while ensuring a tight connection to the original note. Simultaneously, with an explicit semantic lookup index, the Writer can locate specific information in the Context Pool according to its needs, avoiding the traditional problem of 'context too large causing information overload.'

Quality control employs the sub‑agent loop mentioned earlier, or Writer‑Critic loop. The Writer (Opus model) first reads the style guide, then generates a draft based on the Context Pool. The Critic (Haiku model) scores it against evaluation dimensions and gives improvement suggestions. If the score is below 8.0, the Writer revises and resubmits, up to three iterations.

Although this design is based on Anthropic's models, its core idea is universal. Practice shows that even with DeepSeek models, such a loop can significantly improve output quality, reaching a readable draft level.

= Shared Infrastructure

These four agents appear independent, but they share the same core infrastructure: `zk_context_builder.py`. This script is responsible for constructing a local knowledge network via breadth‑first search; it takes a note ID as input and returns that note's title, content, Metadata, and the same information for all notes it references and that reference it.

This design ensures each Agent doesn't need to re‑implement the logic of 'understanding note relationships.' The metadata generation Agent uses it to obtain context, the hidden link discovery Agent uses it to build the Catalog, the task workflow Agent uses it to understand task dependencies, and the blog generation Agent uses it to collect writing material.

The note's Metadata format becomes a unified data contract. Each Agent knows how to read and write this format, understands the meaning of the `Generated: true` marker, and knows how to distinguish system‑generated from user‑written content. This consistency allows the four independent Agents to cooperate without interfering with each other.

Thus, whether generating Metadata, discovering hidden links, executing tasks, or writing blogs, everything is built on the same data structures and context construction logic. This shared infrastructure controls the uncontrollability of AI automation, making them true 'agents' rather than a pile of independent scripts.

= When Thinking Returns to Center

Looking back at these four agents, they solve no profound technical problems. Metadata generation, link discovery, task execution, content drafting—these are things that 'can be done well with help, but will be neglected without help.'

The real change is not in the tools themselves but in the accessibility of this approach. The core value of Zettelkasten—generating new knowledge through long‑term accumulation and cross‑domain association—never required you to be a sociology professor; it requires sustained and relatively stable maintenance input, which is precisely the part AI can undertake.

When AI takes over the 'management tasks' of indexing, association, execution, and drafting, I can finally devote all my energy to the truly interesting part of Zettelkasten: thinking, writing down, and establishing links. Luhmann needed an assistant to make the card box work; my solution was to write a few Agent scripts. The difference is, my assistant never takes leave, never forgets what was written three months ago, and never complains about boring work.

They just quietly let the card box grow by itself.