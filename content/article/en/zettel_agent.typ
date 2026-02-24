#import "../../../typ/templates/blog.typ": *

#let title = "Making Claude Code the Gardener of the Zettel Forest"
#show: main.with(
  title: title,
  desc: [Combining Typst Zettelkasten note system with Claude Code skills and agents to minimize note maintenance friction and bring thinking back to center.],
  date: "2026-02-24",
  tags: (
    blog-tags.software-engineering,
    blog-tags.programming,
  ),
  lang: "en",
  translationKey: "zettel_agent",
  llm-translated: true,
)

In our #link("../zettel_typst")[previous article], we introduced the Zettelkasten note system I built with Typst, but it's not without challenges.

Moving from impulsive passion to long-term persistence and ultimately smooth implementation requires wisdom. The Zettelkasten method theoretically greatly improves thinking efficiency, which can give people boundless passion. But in actual use, maintenance costs increase linearly with the number of notes: after writing a new note, you need to manually add summaries, keywords, check connections with other notes, execute tasks mentioned in the note, etc. These management tasks gradually erode the time that should be used for thinking.

This contradiction becomes particularly evident when notes exceed one hundred. I began to understand why understanding Niklas Luhmann's card index requires many assistants: the maintenance cost of the card index is proportional to the number of cards, beyond a certain scale, it's difficult for one person to bear this burden.

The difference is, my assistants don't need to be human (at my current stage, it's also hard to find human assistants).

= Automation

== AI for Automation

AI and programming actually have many similarities, the key point is that both can achieve abstraction of the `input`-`output` structure, i.e., through some explicit or implicit pattern, provide reasonable responses to inputs. Therefore, in principle, as long as a specific scenario can be abstracted as an `input`-`output` structure and the reasonableness range of output is defined, this scenario can be automated through AI or programming.

The difference between AI and programming is that AI has more flexible input-output structures: AI doesn't need to predefine a fixed input-output structure, but can dynamically adjust the format and content of inputs and outputs based on actual situations. This gives AI greater adaptability when dealing with complex and changing scenarios.

The cost of flexibility is greater 'unpredictability'; compared to programming, AI output may have more variables and uncertainty. Therefore, to achieve AI automation, we must

- Provide controllable `input`, which in AI is called `Context`, or `context`, it's the foundation for AI to make reasonable responses. This is the basic idea of #link("https://code.claude.com/docs/en/skills")[Skills].
- Provide quantifiable `output`, which will become the metric for systematically evaluating responses. An ideal framework is that if the metric is not met, output will be prohibited, and AI will be required to regenerate until it meets the metric. One implementation method is called sub-agent loop, which sets up two agents: a task execution agent and an evaluation agent. The former is responsible for generating output, the latter evaluates whether the output meets the metrics; if not, it asks the former to regenerate until satisfied. This method can effectively control AI output quality and reasonableness, thereby achieving AI automation.

Adhering to these two abstractions, we can use AI to achieve automation 'within a certain degree of freedom'.

== Problem Identification

My Typst Zettelkasten system is already quite mature: each note is named with a timestamp (`yyMMddHHmm.typ`), cross-referenced via `@timestamp`, and the system automatically generates backlinks. The note header has a standard Metadata block: Aliases, Abstract, Keyword. Combined with Neovim and Tinymist LSP, the experience of writing individual notes is smooth.

But maintaining the entire system is another matter. I identified four main friction points and built a Claude Code Agent with corresponding Skills for each. These four friction points correspond to four nodes in creating and traversing the Zettelkasten note system:
- Writing: While writing notes without pressure, I need to reduce the mental burden of creating Metadata.
- Organization: I hope that while given known or 'controllable' knowledge connections, I can discover those 'hidden' connections. This is actually the core value of Luhmann's card index: stimulating new insights by juxtaposing cards on different topics.
- Execution: As I mentioned in my #link("../zettel_typst")[previous article], I found Zettelkasten notes can be used as a task management tool, providing AI with appropriate context. If the Zettelkasten note system can be transformed into a task execution system, the barrier between thinking and execution will be further broken down, improving efficiency.
- Output: People often point out that Zettelkasten notes are 'writing-oriented', but in fact, starting from known nodes and topics, constructing a linear rather than network narrative blog still requires much repetitive work (e.g., manually traversing notes, selecting materials, organizing structure, polishing language). If AI can take on these repetitive tasks and establish the architecture, blog writing becomes easier.

== Metadata Generation

Each of Luhmann's cards had handwritten index marks. This is the prerequisite for the card index to be searchable. In my system, this corresponds to the Metadata block:

```typ
/* Metadata:
Aliases: ZK Metadata Agent, Metadata Generation Skill
Abstract: This note describes the design and implementation of a Claude Code Skill for automating Zettelkasten metadata generation.
Keyword: Zettelkasten, metadata generation, Claude Code, automation
Generated: true
*/
```

Handwriting these is extremely tedious. A note's abstract often requires reviewing other notes it references to write accurately; keyword selection needs to consider the global context. This is exactly what LLMs excel at—they can simultaneously 'see' a note and its surrounding reference network.

I chose the *Sub-agent loop* architecture. The main Claude discovers all pending `.typ` files via `git status`, launching an independent Sub-agent for each file. Each Sub-agent first calls `zk_context_builder.py` to build the note's local context—including titles, Metadata, and body of notes it references and notes referencing it—then generates Metadata based on this context and writes it to the file.

Initially, I tried having one Agent batch process all notes, resulting in note A's keywords ending up in note B's abstract. Single note per Sub-agent, context isolation, the problem disappeared.

Idempotency protection is a key design: if a file already has Metadata and lacks the `Generated: true` marker, it indicates user handwritten content, and the Agent skips it. Only system-generated Metadata can be overwritten. This rule prevents the automation pipeline from swallowing manually crafted summaries.

== Hidden Link Discovery

There's a subtlety in Luhmann's card index: he didn't just store cards by topic, but deliberately created 'unexpected adjacencies'. A card about the legal system might be placed next to a card about biological evolution, and it's precisely this juxtaposition that fosters new insights.

But discovering such associations heavily relies on familiarity with the entire system—you must remember what you wrote three months ago to connect it with today's new ideas.

My solution is to give AI an 'index catalog'. `zk_build_catalog.py` traverses all notes, extracting each note's ID, title, and Metadata into a compact plain-text catalog, totaling just a few thousand tokens. The Agent receives the target note's full content plus this Catalog, identifies potential related notes through semantic analysis, and returns a list of suggested link IDs.

A necessary filtering step: exclude notes already referenced by and referencing the target note before analysis, only recommending truly 'hidden' associations. You wouldn't want your assistant telling you things you already know.

This agent is like a librarian who has read all cards, responsible for reminding you when writing a new card: 'Hey, you wrote a related card earlier that might inspire this new idea!'

Of course, this design currently only supports relatively small note counts; if the system scales to thousands of notes, more complex indexing and retrieval mechanisms may be needed, such as `VectorDB`. But at the current scale, directly using the Catalog as context input is the simplest and most effective solution.

== Task Workflow

My notes are mixed with many to-do items. A note might describe a technical concept while also listing three checklists to implement. This is actually what I mentioned in my #link("../zettel_typst")[previous article]: the context needed to build a Zettelkasten note system can be constructed through the Zettelkasten note system itself.

The `/zk-do` Skill automates this switching. Users start Claude Code via `claude --add-dir ~/wiki/`#footnote[Must be mounted via the `--add-dir` parameter at startup; cannot use the in-session `/add-dir` command, otherwise Skills won't be loaded correctly.], then specify a note with `/zk-do @id`. The Agent reads the note content, obtains context via the context builder, goes to the corresponding code file, and executes the tasks described in the note.

After completion, automatically changes `- [ ]` to `- [x]`, updates the tag from `#tag.wip` to `#tag.done`. The most valuable step happens at the end: the Agent appends implementation notes at the note's end, recording what was actually done, and if the original plan was adjusted, the reason for the change.

When AI executes tasks, it often discovers that the original assumptions are unreasonable. Without leaving this record, looking back at the note would be confusing: the task description says A, but implementation results in B. This change log is precisely what Luhmann called 'dialogue with the card index': you write down an idea, the system (now AI) responds, and traces of the dialogue remain on the card itself.

#remark[
  Of course, I've always been wary of pollution and confusion caused by AI directly modifying notes, even for metadata we designed strict idempotency checks. For the task execution scenario, the risk of AI directly modifying notes is greater, we must
  - Isolate the Context that AI modifies.
  - Use scripted methods for modifications, rather than relying on AI's natural language generation capability.
]

== Blog Generation

This is the most complex of the four agents, and closest to the scenario of 'assistant helping Luhmann write a paper'. Of course, I don't expect (even if I give it all the context) AI to directly generate a high-quality blog, but I hope it can at least generate a readable draft, saving me a lot of repetitive work.

The essence of Zettelkasten is the strong association of single atomic notes to their related network. To maximize this feature, task input should not be an isolated note, but a Context Pool built around the core note. A script extracts Metadata and body of all related notes in the reference network, packaged as material for the Writer Agent. The Writer can create based on this Context Pool, maintaining content richness while ensuring close connection to the original notes. Meanwhile, with clear semantic lookup indexes, the Writer can locate specific information in the Context Pool according to its needs, avoiding the traditional problem of 'context too large causing information overload'.

Quality control uses the sub-agent loop we mentioned earlier, or Writer-Critic loop. The Writer (Opus model) first reads the style guide, then generates a draft based on the Context Pool. The Critic (Haiku model) scores against rating dimensions and gives improvement suggestions. If below 8.0, the Writer modifies and resubmits, up to three iterations.

Although this design is based on Anthropic models, its core idea is universal. Practice shows that even using DeepSeek models, such a loop can significantly improve output quality, reaching a readable draft level.

= Shared Infrastructure

These four agents appear independent, but they share the same core infrastructure: `zk_context_builder.py`. This script is responsible for building local knowledge networks through breadth-first algorithm; it takes a note ID as input, returning that note's title, content, Metadata, and the same information for all notes it references and is referenced by.

This design ensures each Agent doesn't need to reimplement the logic of 'understanding note relationships'. The metadata generation Agent uses it to obtain context, the hidden link discovery Agent uses it to build the Catalog, the task workflow Agent uses it to understand task dependencies, and the blog generation Agent uses it to collect writing material.

The note's Metadata format becomes a unified data contract. Each Agent knows how to read and write this format, understands the meaning of the `Generated: true` marker, and knows how to distinguish system-generated from user-written content. This consistency allows the four independent Agents to collaborate without interfering with each other.

Thus, whether generating Metadata, discovering hidden links, executing tasks, or writing blogs, all are built on the same data structure and context-building logic. This shared infrastructure controls the uncontrollability of AI automation, making them true 'agents', not just a pile of independent scripts.

= When Thinking Returns to Center

Looking back at these four agents, they don't solve any profound technical problems. Metadata generation, link discovery, task execution, content writing—these are all things that 'can be done well with help, but become lazy without help'.

The real change isn't in the tools themselves, but in the accessibility of this approach. The core value of Zettelkasten—generating new knowledge through long-term accumulation and cross-domain associations—never requires you to be a sociology professor; it requires sustained and relatively stable maintenance investment, which is precisely the part AI can undertake.

When AI takes over these 'management tasks'—indexing, associating, executing, and drafting—I can finally focus all my energy on the truly interesting part of Zettelkasten: thinking, writing down, and establishing links. Understanding Luhmann's card index requires many assistants to grasp its principles; my solution is writing a few Agent scripts. The difference is, my assistants never take leave, never forget what they wrote three months ago, and never complain about boring work.

They just quietly let the card index grow on its own.