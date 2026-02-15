#import "../../../typ/templates/blog.typ": *
#let title = "在 Neovim 中便宜地使用 GitHub Copilot"
#show: main-zh.with(
  title: title,
  desc: [“误导”亦可成“悟道”。],
  date: "2026-02-03",
  tags: (
    blog-tags.software-engineering,
    blog-tags.programming,
  ),
  lang: "zh",
  translationKey: "copilot_neovim",
)

// {content: start}

利用 AI 辅助程序设计应该已经不是一个非常新鲜的话题了。从去年年初的 GitHub Copilot，再到后面的 Cursor 以及 Claude Code 等更接近 Agent 架构的 AI 辅助甚至自动化编程工具，AI 与 vibe coding 在程序设计中已经变得越来越普遍。

= 需求

作为一个长期使用 Neovim 的编程爱好者，我
+ 并不完全信任将代码完全交给 AI，并通过 Agent 等架构来自动生成代码的方式
  - 好吧我其实试过，但是最终还是需要很多 Code Review，对代码的掌控感其实是减弱了的
+ 但是我也非常希望能够利用 AI 来辅助编程工作
  - 例如代码补全、代码片段生成、文档生成等
  - 甚至于一些简单的 Agent 功能，例如在会话中调用工具 (MCP, function calling 或者其他) 帮助我快速理解某些代码库的结构，以及一定范围地编写代码，我要做的就是手动批准他的工具调用，并且理解它相对较为简洁的回复 (不像直接让 AI vibe coding 出所有代码那般，我需要大量工作以理解代码)
+ 我不想在我熟悉的语言中离开已经配置得“赛博包浆”的 Neovim 环境
  - 例如我已经配置好了各种插件、LSP、调试器等
  - 我不想为了使用 AI 辅助编程而切换到 VSCode 或者其他 IDE，即使他们已经存在了官方的 AI 支持

当然，这些需求显然可以购买某些大模型服务商的 API 来解决，但这对于我来说有一些问题：
- 贵，如果我使用频繁 (chat、工具调用等)，成本会非常高
好吧我也承认没有别的问题了，但这个问题就足够让我不想使用这些服务商的 API 了。而对于 GitHub Copilot 来说，学生优惠可以在一定时间内获得基础模型 `GPT-4.5` 的无限次使用权限，并获得一定的高级模型请求额度。

= 计费模型

这里涉及到了“请求额度”这个关键词。GitHub Copilot 的计费模型与常见服务商 API 的计费模型不同。常见服务商 API (例如 OpenAI, Anthropic 等) 通常是按照 Token 数量计费的，而 GitHub Copilot 则是按照“请求次数”计费的 (参考#link("https://docs.github.com/zh/billing/concepts/product-billing/github-copilot-licenses")[计费标准])。这意味着对于一些复杂的任务 (例如代码补全、代码片段生成等)，GitHub Copilot (只算作一次请求，与发送闲聊的价格相同) 的成本会远低于常见服务商 API (可能需要消耗大量 Token)。当然，如果只是进行闲聊，GitHub Copilot 的成本可能会高于常见服务商 API (但我肯定不会拿着一个编码 Orientation 的 Copilot 账号去闲聊人生)。

总之，在这个“按次计费”的框架下，我希望能够在 Neovim 中使用 GitHub Copilot 来辅助我的编程工作：这是一个平衡了效用 (我可以使用高功能模型，例如 Claude-Opus-4.5 或者 GPT-5.2-codex 来解决复杂问题) 与成本 (按次计费) 的方案。

= 方案

虽然说 GitHub Copilot 官方并没有提供 Neovim 的 Copilot Chat 插件 (只提供了自动补全插件，社区实现了 `lua` 版本)，但是社区中有很多人已经实现了 Copilot Chat 的 Neovim 插件，例如 #link("https://github.com/CopilotC-Nvim/CopilotChat.nvim")[CopilotChat.nvim], #link("https://github.com/yetone/avante.nvim")[avante.nvim] 等等。这些插件基本的思想都是
- 利用公开的 GitHub OAuth 认证方式登录 Copilot 服务
- 逆向 VSCode 中 Copilot Chat 的 API，并在 Neovim 中实现一个客户端访问
不过由于这些插件的目标均为 Neovim + 某个大模型服务商作为后台，因此架构上都抽象为了：
- 前端：Neovim
- 适配层：一个通用的结构体，包含抽象化的消息发送、接收等方法
- 后端：特定的服务商
这意味着人们可以通过实现不同的后端来支持不同的服务商 (例如 OpenAI, Anthropic, GitHub Copilot 等等)。

这些设计的好处是可以不对某一个特定 API 服务商或 GitHub Copilot Chat 进行绑定，从而实现更好的灵活性和可扩展性，同时可以做到代码复用，因为在完成逆向 Copilot Chat API 之后，只要获得 OAuth token，适配层和前端的代码都可以复用。

然而，由于 Copilot Chat 在计费模型 (回忆一下，是按次收费) 上与常见服务商 API (Token 数量收费) 有所不同，我们可以预期将会出现一些问题。

= 问题

我个人比较喜欢使用 #link("https://github.com/CopilotC-Nvim/CopilotChat.nvim")[CopilotChat.nvim] 插件来作为 Neovim 中的 Copilot Chat 客户端，因为它的设计简洁 (极为简单的交互方式)，功能克制 (不试图成为一个 Agent，而是专注于编码辅助)，并且适配了最新的 tool calling API 以实现我所需要的 (相对) 复杂任务的执行能力。

== 动态模型选择

首先出现的一个问题是：GitHub 作为一个海量模型的中转站，为了鼓励用户使用更高级的模型，并减少服务器压力，在最新版本的 Copilot Chat API 中引入了#link("https://docs.github.com/en/copilot/concepts/auto-model-selection")[“动态模型选择”]的功能。这个功能目前的行为是：
- 用户在模型选择中选择 `Auto` 选项
- 服务器根据当前的模型用量、折扣信息等因素，返回客户端一个特定的模型 (例如 GPT-5.2, Claude-Sonnet-4.5 等等)
- 客户端使用该模型进行单个会话的请求

#remark[
  GitHub 官方表示，后续这个路由功能会越来越智能，包含对于当前任务复杂度的评估，从而选择最合适的模型来完成任务。事实上，时至今日，在最新版本的 #link("https://github.com/microsoft/vscode-copilot-chat")[vscode-copilot-chat] 源码中，我们已经可以看到标记为 `advance` 和 `experement` 的 `AutoModeRouterUrl` #link("https://github.com/microsoft/vscode-copilot-chat/blob/e90190b00cb61de525d599e6b787828f08035b76/src/platform/endpoint/node/routerDecisionFetcher.ts#L57")[配置项]，以及一些与之相关的逻辑和 #link("https://github.com/microsoft/vscode/issues/288935")[issue]。不过目前这些都处于实验阶段，尚未正式启用，并已经声明“可能会随时更改或移除”，因此我们暂且不予考虑。
]

这个行为是一般 API 服务商不会有的，因为他们通常不会对模型使用进行动态调度，但是对于 GitHub Copilot 来说，这个功能可以帮助用户节省大量的请求次数 (因为高级模型通常可以更好地完成任务，从而减少多次请求的需要)，并节省开销 (分流的高级模型会按照一定的折扣消耗用户的请求额度，比显式地指定高级模型要便宜)，是一个非常重要的“节流功能”。

=== 分析与解决

正因为一般 API 服务商不会有这个功能，社区实现的 Copilot Chat Neovim 插件通常不会考虑这个功能，从而导致用户无法利用“动态模型选择”来节省请求次数和开销。

解决这个问题的方式其实非常简单：为插件添加一个 patch 即可。对于前端，我个人的想法是，如 VSCode 中的行为一样，直接将 `auto` 设计为一个新的模型选项，并将其提供给用户选择。后端可能需要更多考察，这需要我们抓取 VSCode Copilot Chat 插件的网络请求，分析其在“动态模型选择”下的请求行为，从而进行逆向实现。

#theorem-block(title: "Warning")[
  逆向“动态模型选择”功能可能会违反 GitHub Copilot 的使用条款，请务必自行评估风险。本文仅供技术研究与学习使用，不构成任何形式的法律建议。如果您决定实施本文所述的方案，需自行承担相关风险。
]

VSCode 的抓包非常简单，只需要设置 `Http: Proxy` 为逆向工具 (例如 Charles, Fiddler, Proxyman 等等，配置请自行询问 AI) 的地址，并将 `Http: Proxy Support` 设置为 `on` 即可。这样，VSCode 中的所有 HTTP/HTTPS 请求都会被代理到我们的抓包工具中，从而实现抓包。

通过抓包，我们可以看到 VSCode Copilot Chat 插件在使用“动态模型选择”时的请求行为是 (去掉守护进程相关的请求)：
- 首先，向 `/models/session` 端口发送一个 `POST` 请求，请求体中包含了
  ```json
  {
    "auto_mode": {
      "model_hints": [
        "auto"
      ]
    }
  }
  ```
  这个请求的响应体的形式为
  ```json
  {
    "available_models": [
      "gpt-4.1",
      "gpt-4o",
      "claude-sonnet-4.5",
      "claude-haiku-4.5",
      "gpt-5.2-codex"
    ],
    "selected_model": "claude-haiku-4.5",
    "session_token": "xxx",
    "expires_at": 1770013986,
    "discounted_costs": {
      "claude-haiku-4.5": 0.1,
      "claude-sonnet-4.5": 0.1,
      "gpt-4.1": 0.1,
      "gpt-5.2-codex": 0.1
    }
  }
  ```
  包含了可用模型列表、被选中的模型、会话令牌、过期时间以及各个模型的折扣信息。
- 客户端拿到 `selected_model` 和 `session_token` 后，向 `/chat/completion` 端口发送一个 `POST` 请求，请求头包含 `session_token` 信息 (暂时不知道有什么用，最终逆向测试的结果显示不包含该头也能正常工作)，请求体中包含了
  ```json
  {
    "model": "claude-haiku-4.5",
    ...
  }
  ```
  以及其他消息相关的信息，从而完成一次消息的发送。
- 服务器返回消息的响应体，包含了 AI 的回复内容，工具调用等信息，本地再进行处理 (这个处理过程是我们下一部分要讨论的内容，暂时按下不表)。

通过分析这个请求过程，我们可以在 Neovim 插件的后端实现中添加对“动态模型选择”的支持。具体来说，我们需要在会话初始化时发送 `/models/session` 请求，并保存返回的 `selected_model`，然后在后续的消息发送请求中使用该模型。这在一定程度上模拟了 VSCode Copilot Chat 插件的行为，从而实现了“动态模型选择”的支持。

目前这个修改已经作为 #link("https://github.com/CopilotC-Nvim/CopilotChat.nvim/pull/1518")[Pull Request] 合并到了 CopilotChat.nvim 的主分支中。

作为一个开源项目，我们也可以分析 VSCode Copilot Chat 插件的源码来理解这一功能的实现。但既然我们已经抓包出来了，分析“巨硬”的源码就显得没有必要了 (类型体操看得有点累)。

== 工具调用

另一个问题有关于 Copilot Chat 的工具调用功能。工具调用 (Tool Calling) 是现在各大模型普遍提供的一种机制，允许 AI 在会话中调用外部工具 (例如代码搜索、代码执行等) 来辅助完成任务。这一功能在 VSCode Copilot Chat 插件中已经得到了支持，并且在最新版本的 Copilot Chat API 中也已经公开。同时，最新版本的 CopilotChat.nvim 插件也已经实现了对工具调用的支持。

在使用过程中，我发现一个重大问题：为什么我在 CopilotChat.nvim 插件中使用工具调用时，用量的消耗远远高于我在 VSCode Copilot Chat 插件中使用工具调用时的消耗？

理解这个问题就不得不回到巨硬实现的插件源码中，分析其在工具调用时的请求行为。通过一番查找 (这个时候 AI 帮人读代码就帮大忙了！)，我们发现处理该问题的逻辑位于#link("https://github.com/microsoft/vscode-copilot-chat/blob/5b41feb6ea2cc2800feea9687626c513e04f04a0/src/extension/intents/node/toolCallingLoop.ts#L4")[`toolCallingLoop.ts`]中。简单来说，这个插件使用一个布尔值来追踪工具调用的发起者
```ts
/** Indicates if the request was user-initiated */
userInitiatedRequest?: boolean;
```
接下来，只需要在`toolCallingLoop.ts`中检查这个布尔值，就可以决定是否将当前请求计入用户请求额度中。行为是：
- 用户发起一个请求，`userInitiatedRequest` 被设置为 `true`，该请求计入用户请求额度
- AI 结合用户发出的请求返回调用工具的确认信息，用户在本地确认、执行完毕后，将工具的结果发送回 AI，`userInitiatedRequest` 被设置为 `false`，该请求不计入用户请求额度
这样，VSCode 中用户只需要为自己发起的请求付费，而不需要为 AI 调用工具时的请求付费，从而大大节省了请求额度的消耗。

这个机制，同样很不幸地，是广泛地基于 API Token 用量计费的服务商所不具备的 (因为他们通常不会区分用户请求和 AI 请求，这些在他们的计费模型中是没有意义的，因为这些请求都将返回一系列上下文，并作为被抽象化的 Token 进行计费)，因此社区实现的 Copilot Chat Neovim 插件通常也不会考虑这个机制，从而导致用户在使用工具调用时，所有请求 (包括 AI 调用工具时的请求) 都会计入用户请求额度，从而大大增加了请求额度的消耗。

#remark[
  在调研这个问题时，我发现知乎上有相关的#link("https://zhuanlan.zhihu.com/p/1997806230605956481")[文章]，原本觉得这个有点像是 AI 写的东西 (因为语气)，但仔细看了看发现竟然严谨地写了参考文献以及 `OpenCode` 社区的实现，并交叉确认了实现细节。这说明 AI 辅助即使在第一眼看来会给人不靠谱感觉 (尤其是知乎上已经充斥着大量 AI 生成的低质量内容)，但只要经过仔细验证，关注求证的*结果*而不是展现证据的*语气* (后者误导了我对于内容可靠性的判断)，“误导”同样可以成为“悟道”。
]

而在最终将请求拼接为 `/chat/completion` 请求时，我们可以看到 `userInitiatedRequest` 的值被传递到了请求头的 `x-initiator` 字段中。当 `x-initiator` 为 `user` 时，表示该请求是用户发起的请求；当 `x-initiator` 为 `agent` 时，表示该请求是 AI 发起的请求 (通常是工具调用的结果返回)。前者计入用户请求额度，后者不计入用户请求额度。

将这个机制应用在 CopilotChat.nvim 插件中同样非常简单：在发送请求时，检查当前请求是否为用户发起的请求 (通常是通过一个参数传递进来，CopilotChat.nvim 的设计非常好，有明确的判断机制)，并根据该参数设置 `x-initiator` 字段的值，构建新的请求头即可。这一修改在 #link("https://github.com/CopilotC-Nvim/CopilotChat.nvim/pull/1520")[PR] 中已经被合并到了主分支。
