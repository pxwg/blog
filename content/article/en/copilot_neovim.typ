#import "../../../typ/templates/blog.typ": *
#let title = "Using GitHub Copilot Affordably in Neovim"
#show: main-zh.with(
  title: title,
  desc: ["Misleading" can also lead to "Enlightenment".],
  date: "2026-02-02",
  tags: (
    blog-tags.software-engineering,
    blog-tags.programming,
  ),
  lang: "en",
  translationKey: "copilot_neovim",
  llm-translated: true,
)

Using AI to assist in programming is no longer a novel topic. From GitHub Copilot at the beginning of last year to more recent tools like Cursor and Claude Code, which lean towards Agent-based architectures, AI and "vibe coding" have become increasingly prevalent in software development.

= Requirements

As a long-time Neovim enthusiast, I have a few specific needs:
+ I don't fully trust delegating code entirely to an AI via Agent architectures for automated generation.
  - I've tried it, but it ultimately requires heavy code reviews, and the sense of control over the codebase is significantly diminished.
+ However, I strongly desire to leverage AI for assistive tasks:
  - For instance, code completion, snippet generation, and documentation.
  - Even some simple Agent functionalities, such as tool-calling (MCP, function calling, etc.) within a chat session to help me quickly understand repository structures or write scoped code. My role would be to manually approve tool calls and interpret its relatively concise responses (unlike vibe coding, which requires massive effort to grok the generated output).
+ I refuse to leave my "cyber-worn," heavily seasoned Neovim environment for my primary languages.
  - I have invested years into configuring various plugins, LSPs, and debuggers.
  - I don't want to switch to VSCode or other IDEs just for AI assistance, even if they offer official support.

Naturally, these needs could be met by purchasing APIs from major model providers, but that presents a significant hurdle:
- Cost. If used frequently for chat and tool calling, the expenses can skyrocket.
Admittedly, cost is the only real issue, but it's sufficient to deter me from using those raw APIs. For GitHub Copilot, however, student discounts provide unlimited access to base models like `GPT-4.5` and a generous quota for premium models.

= Billing Model

The keyword here is "request quota." GitHub Copilot's billing model differs from typical provider APIs. While providers like OpenAI or Anthropic usually charge based on token count, GitHub Copilot (for individuals/students) effectively operates on a "per-request" basis (refer to #link("https://docs.github.com/en/billing/concepts/product-billing/github-copilot-licenses")[Billing Standards]). This means for complex tasks—like code completion or snippet generation—Copilot's cost is much lower than token-based APIs, which might consume thousands of tokens per turn. (Of course, I wouldn't use a coding-oriented Copilot account for casual life chats).

In this "per-request" framework, my goal is to use GitHub Copilot in Neovim to balance utility (accessing high-end models like Claude-Opus-4.5 or GPT-5.2-codex for complex problems) with cost-efficiency.

= The Solution

While GitHub does not provide an official Copilot Chat plugin for Neovim (only the autocomplete plugin exists, with community `lua` implementations), the community has stepped up with excellent alternatives like #link("https://github.com/CopilotC-Nvim/CopilotChat.nvim")[CopilotChat.nvim] and #link("https://github.com/yetone/avante.nvim")[avante.nvim]. These plugins generally follow a consistent approach:
- Use public GitHub OAuth authentication to log into Copilot services.
- Reverse-engineer the Copilot Chat API used in VSCode to implement a Neovim client.
Since these plugins aim to support multiple backends, they are abstracted into:
- Frontend: Neovim UI.
- Adapter Layer: An abstracted structure for sending and receiving messages.
- Backend: Specific providers (OpenAI, Anthropic, GitHub Copilot, etc.).

This architecture allows for flexibility and code reuse; once the Copilot Chat API is reversed, as long as an OAuth token is obtained, the adapter and frontend logic remain the same.

However, because Copilot Chat's billing model (per-request) differs from standard APIs (per-token), specific issues arise.

= Issues

I personally prefer using #link("https://github.com/CopilotC-Nvim/CopilotChat.nvim")[CopilotChat.nvim] as my client due to its clean design, restrained functionality (focusing on coding assistance rather than being a full agent), and support for the latest tool-calling APIs.

== Dynamic Model Selection

The first issue involves "Dynamic Model Selection." As a hub for various models, GitHub introduced this feature in the latest Copilot Chat API to encourage the use of advanced models while managing server load (see #link("https://docs.github.com/en/copilot/concepts/auto-model-selection")[Auto Model Selection]). Its current behavior is:
- The user selects the `Auto` option in model selection.
- The server evaluates current usage and task complexity to return a specific model (e.g., GPT-5.2, Claude-Sonnet-4.5).
- The client uses this model for that specific session request.

#remark[
  GitHub has stated that this routing will become increasingly intelligent, evaluating task complexity to select the most appropriate model. In the source code of the latest #link("https://github.com/microsoft/vscode-copilot-chat")[vscode-copilot-chat], we can already see `AutoModeRouterUrl` configurations marked as `advance` or `experimental` (#link("https://github.com/microsoft/vscode-copilot-chat/blob/e90190b00cb61de525d599e6b787828f08035b76/src/platform/endpoint/node/routerDecisionFetcher.ts#L57")[source]), along with related logic and #link("https://github.com/microsoft/vscode/issues/288935")[issues]. Since these are experimental and subject to change, we will set them aside for now.
]

This behavior is unique to GitHub Copilot. Standard API providers don't dynamically schedule models like this. For Copilot users, this feature is a vital "cost-saving" mechanism because premium models often complete tasks in fewer turns, and diverted premium models are billed at a discount compared to explicitly selecting them.

=== Analysis and Solution

Because standard APIs lack this feature, community Neovim plugins often overlook it, preventing users from benefiting from dynamic model selection.

The fix is simple: patch the plugin. For the frontend, I suggest mirroring VSCode's behavior by adding `auto` as a model option. For the backend, we need to analyze VSCode's network traffic to understand the request flow.

#theorem-block(title: "Warning")[
  Reverse-engineering "Dynamic Model Selection" may violate GitHub Copilot's Terms of Service. Please assess the risks yourself. This article is for technical research and educational purposes only and does not constitute legal advice.
]

Capturing VSCode packets is straightforward: set `Http: Proxy` to a tool like Charles, Fiddler, or Proxyman, and set `Http: Proxy Support` to `on`.

Through packet analysis, we see the workflow (excluding daemon requests):
- First, a `POST` request to `/models/session` with the body:
  ```json
  {
    "auto_mode": {
      "model_hints": ["auto"]
    }
  }
  ```
  The response looks like:
  ```json
  {
    "available_models": ["gpt-4.1", "gpt-4o", "claude-sonnet-4.5", ...],
    "selected_model": "claude-haiku-4.5",
    "session_token": "xxx",
    "expires_at": 1770013986,
    "discounted_costs": { "claude-haiku-4.5": 0.1, ... }
  }
  ```
- After receiving the `selected_model` and `session_token`, the client sends a `POST` to `/chat/completion`. The headers include the `session_token` (though tests show it works without it), and the body specifies the model:
  ```json
  {
    "model": "claude-haiku-4.5",
    ...
  }
  ```
- The server returns the AI's response, including any tool calls.

By replicating this sequence—requesting `/models/session` during initialization and caching the `selected_model`—we can support dynamic selection in Neovim. I have submitted this modification as a #link("https://github.com/CopilotC-Nvim/CopilotChat.nvim/pull/1518")[Pull Request] to CopilotChat.nvim.

== Tool Calling

The second issue concerns Tool Calling. This mechanism allows AI to execute external tools (like searching code or running scripts). While supported in VSCode and the latest Copilot API, I noticed a discrepancy: why does using tools in CopilotChat.nvim consume significantly more quota than in VSCode?

Back to the VSCode source code. The logic resides in #link("https://github.com/microsoft/vscode-copilot-chat/blob/5b41feb6ea2cc2800feea9687626c513e04f04a0/src/extension/intents/node/toolCallingLoop.ts#L4")[`toolCallingLoop.ts`]. The plugin uses a boolean to track the request initiator:
```ts
/** Indicates if the request was user-initiated */
userInitiatedRequest?: boolean;
```
It checks this value to decide whether to bill the request:
- User initiates a request: `userInitiatedRequest` is `true`, and it counts against the quota.
- AI returns a tool call, the user confirms/executes it, and the results are sent back: `userInitiatedRequest` is `false`, and the request is *not* billed.
This allows VSCode users to only pay for their own prompts, not the internal overhead of tool calling.

This mechanism is absent in token-based APIs because they don't distinguish between user and agent requests—everything is just tokens. Consequently, community plugins often miss this, causing all tool-related turns to burn user quota.

#remark[
  During my research, I found a Zhihu #link("https://zhuanlan.zhihu.com/p/1997806230605956481")[article] on this. At first, the tone sounded like AI-generated fluff, but upon closer inspection, it cited specific `OpenCode` implementations and verified technical details. It goes to show that while AI-generated content can feel unreliable, if you focus on the *results* rather than the *tone*, even "misleading" information can lead to "enlightenment."
]

In the final `/chat/completion` request, `userInitiatedRequest` is passed in the `x-initiator` header. When `x-initiator` is `user`, it counts; when it is `agent` (for tool result returns), it does not.

Implementing this in CopilotChat.nvim was simple: detect if a request is a tool response and set the `x-initiator` header accordingly. This fix was merged in #link("https://github.com/CopilotC-Nvim/CopilotChat.nvim/pull/1520")[PR #1520].
