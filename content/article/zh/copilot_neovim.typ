#import "../../../typ/templates/blog.typ": *
#let title = "在 Neovim 中便宜地使用 GitHub Copilot"
#show: main-zh.with(
  title: title,
  desc: [在 Neovim 中使用 GitHub 插件，需要一些细致的修改以获得最经济体验。],
  date: "2025-09-01",
  tags: (
    blog-tags.software-engineering,
    blog-tags.programming,
  ),
  lang: "zh",
  translationKey: "copilot_neovim",
)

利用 AI 辅助程序设计应该已经不是一个非常新鲜的话题了。从年初的 GitHub Copilot，再到后面的 Cursor 以及 Claude Code 等更接近 Agent 架构的 AI 辅助甚至自动化编程工具，AI 与 vibe coding 在程序设计中已经变得越来越普遍。

= 需求

作为一个长期使用 Neovim 的编程爱好者，我
+ 并不完全信任将代码完全交给 AI，并通过 Agent 等架构来自动生成代码的方式
  - 好吧我其实试过，但是最终还是需要很多 Code Review，对代码的掌控感其实是减弱了的
+ 但是我也非常希望能够利用 AI 来辅助编程工作
  - 例如代码补全、代码片段生成、文档生成等
  - 甚至于一些简单的 Agent 功能，例如在会话中调用工具 (MCP, function calling 或者其他) 帮助我快速理解某些代码库的结构，以及一定范围地编写代码，我要做的就是手动批准他的工具调用，并且理解它相对较为简洁的回复 (不像直接让 AI vibe coding 出所有代码那般，我需要大量工作以理解代码)
+ 我不想在我熟悉的语言中离开已经配置的“赛博包浆”的 Neovim 环境
  - 例如我已经配置好了各种插件、LSP、调试器等
  - 我不想为了使用 AI 辅助编程而切换到 VSCode 或者其他 IDE，即使他们已经存在了官方的 AI 支持

当然，这些需求显然可以购买某些大模型服务商的 API 来解决，但这对于我来说有一些问题：
- 贵，如果我使用频繁 (chat、工具调用等)，成本会非常高
好吧我也承认没有别的问题了，但这个问题就足够让我不想使用这些服务商的 API 了。而对于 GitHub Copilot 来说，学生优惠可以在一定时间内获得基础模型 `GPT-4.5` 的无限次使用权限，并获得一定的高级模型请求额度。

= 计费模型

这里涉及到了“请求额度”这个关键词。GitHub Copilot 的计费模型与常见服务商 API 的计费模型不同。常见服务商 API (例如 OpenAI, Anthropic 等) 通常是按照 Token 数量计费的，而 GitHub Copilot 则是按照“请求次数”计费的 (参考#link("https://docs.github.com/zh/billing/concepts/product-billing/github-copilot-licenses")[计费标准])。这意味着对于一些复杂的任务 (例如代码补全、代码片段生成等)，GitHub Copilot (只算作一次请求，与发送闲聊的价格相同) 的成本会远低于常见服务商 API (可能需要消耗大量 Token)。当然，如果只是进行闲聊，GitHub Copilot 的成本可能会高于常见服务商 API (但我肯定不会拿着一个编码 Orientation 的 Copilot 账号去闲聊人生)。

总之，在这个“按次计费”的框架下，我希望能够在 Neovim 中使用 GitHub Copilot 来辅助我的编程工作。

= 方案

虽然说 GitHub Copilot 官方并没有提供 Neovim 的 Copilot Chat 插件 (只提供了自动补全插件，社区实现了 `lua` 版本)，但是社区中有很多人已经实现了 Copilot Chat 的 Neovim 插件，例如#link("https://github.com/CopilotC-Nvim/CopilotChat.nvim")[CopilotChat.nvim], #link("https://github.com/yetone/avante.nvim")[avante.nvim] 等等。这些插件基本的思想都是
- 利用公开的 GitHub OAuth 认证方式登录 Copilot 服务
- 逆向 VSCode 中 Copilot Chat 的 API，并在 Neovim 中实现一个客户端访问
不过由于这些插件的目标均为 Neovim + 某个大模型服务商作为后台，因此架构上都抽象为了：
- 前端：Neovim
- 适配层：一个通用的结构体，包含抽象化的消息发送、接收等方法
- 后端：特定的服务商
这意味着人们可以通过实现不同的后端来支持不同的服务商 (例如 OpenAI, Anthropic, GitHub Copilot 等等)。

这些设计的好处是可以不对某一个特定 API 服务商或 GitHub Copilot Chat 进行绑定，从而实现更好的灵活性和可扩展性，同时可以做到代码复用，因为在完成逆向 Copilot Chat API 之后，只要获得 OAuth token，适配层和前端的代码都可以复用。

然而，由于 Copilot Chat 在计费模型 (回忆一下，是按次收费) 上与常见服务商 API (Token 数量收费) 有所不同，我们可以预期将会出现一些问题。
