/*
#import "../../../typ/templates/blog.typ": *

#let title = "当 Zettelkasten 遇上 Claude Code：四个自动化代理如何解放思考"
#show: main-zh.with(
  title: title,
  desc: [Typst Zettelkasten 笔记系统与 Claude Code 技能结合，通过元数据生成、隐藏链接发现、任务工作流和博客生成四个自动化代理，将笔记维护的摩擦力降到最低，让思考回归中心。],
  date: "2026-02-24",
  tags: (
    blog-tags.software-engineering,
    blog-tags.programming,
  ),
  lang: "zh",
  translationKey: "zettel_agent",
)
*/

我最近在整理笔记时发现一个矛盾：Zettelkasten 方法理论上能极大提升思考效率，但实际使用中，维护成本会随着笔记数量增长而线性增加。写完一条新笔记，需要手动补摘要、加关键词、检查与其他笔记的关联、执行笔记里提到的任务……这些"管理工作"逐渐蚕食了本应用来思考的时间。

这个矛盾在笔记超过一百条后变得尤为明显。我开始理解为什么尼克拉斯·卢曼需要助手——不是因为他懒，而是因为卡片盒的维护成本和卡片数量成正比，到了某个规模之后，一个人根本兜不住。

区别在于，我的助手不需要是人类。

= 从问题到代理：四个摩擦点的自动化

我用的 Typst Zettelkasten 系统已经相当成熟：每条笔记以时间戳命名（`yyMMddHHmm.typ`），通过 `@timestamp` 互相引用，系统自动生成反向链接。笔记头部有标准的 Metadata 块——Aliases、Abstract、Keyword。配合 Neovim 和 tinymist LSP，写单条笔记的体验很流畅。

但维护整个系统是另一回事。我识别出四个主要的摩擦点，并为每个点构建了一个 Claude Code Agent。

== 元数据生成：最无聊但最关键的工作

卢曼的每张卡片都有手写的索引标记。这是卡片盒能被检索的前提。我的系统里对应的是 Metadata 块：

```typ
/* Metadata:
Aliases: ZK Metadata Agent, Metadata Generation Skill
Abstract: This note describes the design and implementation of a Claude Code Skill for automating Zettelkasten metadata generation.
Keyword: Zettelkasten, metadata generation, Claude Code, automation
Generated: true
*/
```

手写这些东西极其乏味。一条笔记的摘要往往需要回顾它引用的其他笔记才能写准确，关键词的选取要考虑全局语境。这恰恰是 LLM 擅长的——它能同时"看到"一条笔记和它周围的引用网络。

我选择了 *Sub-agent 循环* 架构。主控 Claude 通过 `git status` 发现所有待处理的 `.typ` 文件，对每个文件启动一个独立的 Sub-agent。每个 Sub-agent 先调用 `zk_context_builder.py` 构建该笔记的局部上下文——包含它引用的笔记和引用它的笔记的标题、Metadata、正文——然后基于这份上下文生成 Metadata 并写入文件。

最初我试过让一个 Agent 批量处理所有笔记，结果笔记 A 的关键词跑到笔记 B 的摘要里。单条笔记单个 Sub-agent，上下文隔离，问题消失了。

幂等性保护是关键设计：如果文件已有 Metadata 且不含 `Generated: true` 标记，说明是用户手写的，Agent 跳过。只有系统生成的 Metadata 才允许覆盖。这条规则防止了自动化流程吞掉手动编写的精心摘要。

== 隐藏链接发现：AI 图书管理员

卢曼的卡片盒有一个精妙之处：他不只是按主题存放卡片，而是刻意制造"意外的相邻"。一张关于法律系统的卡片可能紧挨着一张关于生物进化的卡片，而正是这种并置催生了新的洞见。

但这种关联的发现严重依赖对整个系统的熟悉程度——你必须记得三个月前写过什么，才能把它和今天的新想法联系起来。

我的方案是给 AI 一本"索引目录"。`zk_build_catalog.py` 遍历全部笔记，将每条笔记的 ID、标题和 Metadata 抽取成一份紧凑的纯文本目录，总共也就几千 token。Agent 拿到目标笔记的完整内容加上这份 Catalog，通过语义分析识别潜在的关联笔记，返回建议链接的 ID 列表。

一个必要的过滤步骤：分析前排除目标笔记已经引用和被引用的笔记，只推荐真正"隐藏"的关联。你不会想让助手告诉你那些你已经知道的事情。

这个代理就像一个读过所有卡片的图书管理员——不是帮你管理卡片，而是帮你发现你自己没注意到的联系。

== 任务工作流：卡片就是工单

我的笔记里混杂着大量的待办事项。一条笔记可能既描述了一个技术概念，又列了三个需要实现的 checklist。这种"知识 + 行动"的混合在实践中非常自然，但执行起来需要不断在笔记和代码之间切换。

`/zk-do` 代理把这个切换自动化了。用户通过 `claude --add-dir ~/wiki/` 启动 Claude Code#footnote[必须在启动时通过 `--add-dir` 参数挂载，不能用会话内的 `/add-dir` 命令，否则 Skills 不会被正确加载。]，然后用 `/zk-do @id` 指定一条笔记。Agent 读取笔记内容，通过 context builder 获取上下文，前往对应代码文件执行笔记中描述的任务。

完成后自动把 `- [ ]` 改为 `- [x]`，将标签从 `#tag.wip` 更新为 `#tag.done`。最有价值的一步发生在最后：Agent 在笔记末尾追加实现备注，记录实际做了什么，以及如果原始计划被调整了，变更的原因是什么。

AI 执行任务时经常发现原始设想有不合理之处，如果不留下这段记录，回头看笔记时就会困惑——任务描述说的是 A，实现出来却是 B。这段变更日志，其实就是卢曼所说的"与卡片盒的对话"：你写下想法，系统（现在是 AI）给出回应，对话的痕迹留在卡片本身。

== 博客生成：从笔记到出版物

这是四个代理中最复杂的一个，也是最接近"助手帮卢曼写论文"的场景。

输入不是一条孤立的笔记，而是围绕核心笔记构建的 Context Pool。`zk_context_builder.py` 提取引用关系网络中所有相关笔记的 Metadata 和正文，打包成 Writer Agent 的素材。Writer 不需要自己去"查资料"，所有相关信息已经摆在面前——它只需要专注于叙事组织和语言打磨。

质量控制采用 Writer-Critic 循环。Writer（Opus 模型）先读取风格指南，然后根据 Context Pool 生成初稿。Critic（Haiku 模型）对照评分维度打分并给出改进建议。低于 8.0 分则 Writer 修改后重新提交，最多迭代三次。

选择 Opus 写、Haiku 评不是随意的——写作需要更强的语言组织能力，评估主要是对照 checklist 打分，用轻量模型就够了。

输出是 Typst 文件，头部 preamble 包裹在 `/* ... */` 注释块里。这个看似奇怪的设计是为了防止 tinymist LSP 在无法解析 blog 模板时报假错——如果不这样做，Agent 会把 LSP 的误报当成真正的语法错误，进入无尽的"修复"循环。

= 共享的基础设施：Context Builder 作为数据契约

这四个代理看起来各自独立，但它们共享同一套核心基础设施：`zk_context_builder.py`。这个脚本负责构建局部知识网络，它以笔记 ID 为输入，返回该笔记的标题、内容、Metadata，以及它引用和被引用的所有笔记的相同信息。

这个设计让每个 Agent 都不需要重复实现"理解笔记关系"的逻辑。元数据生成 Agent 用它来获取上下文，隐藏链接发现 Agent 用它来构建 Catalog，任务工作流 Agent 用它来理解任务依赖，博客生成 Agent 用它来收集写作素材。

笔记的 Metadata 格式成了统一的数据契约。每个 Agent 都知道如何读取和写入这种格式，知道 `Generated: true` 标记的含义，知道如何区分系统生成和用户编写的内容。这种一致性让四个独立的 Agent 能够协同工作，而不会互相干扰。

= 当思考回归中心

回过头看这四个代理，它们解决的都不是什么高深的技术问题。元数据生成、链接发现、任务执行、内容撰写——这些都是"有人帮忙就能做好，没人帮忙就会偷懒"的事情。

真正的变化不在工具本身，而在这套方法的可及性。Zettelkasten 的核心价值——通过长期积累和跨领域关联产生新知——从来不需要你是社会学教授。它需要的是持续的维护投入，而这恰恰是 AI 可以承担的部分。

当 AI 接管了索引、关联、执行和初稿这些"管理工作"，我终于可以把全部精力放在 Zettelkasten 真正有趣的那个环节上：思考，然后写下来。卢曼需要助手才能让卡片盒工作，我的解决方案是写几个 Agent 脚本。区别在于，我的助手永远不会请假，不会忘记三个月前写过什么，也不会抱怨工作无聊。

它们只是安静地让卡片盒自己生长。