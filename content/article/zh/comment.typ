#import "../../../typ/templates/blog.typ": *
#let title = "手搓评论系统"
#show: main.with(
  title: title,
  desc: [我为我的博客添加了手搓的评论系统，基于 Serverless 架构和 GitHub Discussions。],
  date: "2025-10-22",
  tags: (
    blog-tags.programming,
    blog-tags.network,
    blog-tags.tooling,
    blog-tags.dev-ops,
  ),
  lang: "zh",
  translationKey: "comment",
  llm-translated: false,
)

= 缘起

最近试着将自己的几篇博客分享到了我的朋友圈中，结果发现大家的反响比较热烈，在朋友圈评论区下面有不少讨论。
但我始终觉得朋友圈并不是一个很适合展示评论的地方，一方面是它的展示有时间限制，一方面是不方便归档处理，另一方面是评论只能对共同好友展示，并不是特别广泛，即使可能当前的话题是大家都很好奇的。

博客的意义在于博览天下客人的智识，因此评论的意义是很重要的。故此，设计评论系统被提上日程。

= 需求分析

我对于评论区的需求主要如下：
+ 我不想要迁移当前基于 GitHub Pages 的静态博客方案。
+ 我不想要费心思维护博客评论区的数据 (虽然我自己有服务器，但是我觉得要是有比较成熟的方案，直接使用对应的数据库肯定比手搓要更为可持续)。
+ 我想要高度的外观可定制性，保证博客系统与我自己的网页风格匹配，并且抵御我审美变化导致的博客样式重构。
+ 我想要尽可能减少客户端的 JS 调用，保证博客的加载速度与用户体验，符合 Astro 孤岛架构的设计理念。

最开始，我想要使用 #link("https://github.com/giscus/giscus")[Giscus] 来作为博客的评论后端。
好处是部署极其简单，基本上可以说即插即用。
但我后来发现他的可定制性不强，美观度一般，修改对应的主题颜色粒度也不够精细，不符合需求三。

因此，我转向自己构建评论系统。
由于需求一，我们评论系统的架构应该为前后端分离的架构，前端保持 GitHub Pages，后端设置一个博客的 api 子域名来处理登录、鉴权与 Cookie 分发的过程。
这样的构造也符合 Astro 孤岛架构的设计理念，即需求四。
由于需求二，受到 Giscus 的启发，我决定采用 GitHub Discussions 来作为“隐形”的评论区后端存储评论信息。唯一的问题是 Github discussion 不能回复评论的评论，不过暂时这个需求不是特别大。
需求三是纯粹的前端问题，与我当前博客的 CSS 样式保持匹配就没有问题了。

由于只需要处理简单的登录流程，后端可以采用 Serverless 架构。我选用了 #link("https://vercel.com/")[Vercel] 来部署与承载简单的登录 API。

= 实现

== 构建登录 API

现代 GitHub 采用 `GraphQL` 记录查询与变更数据，因此我们需要使用 GitHub GraphQL API 来处理评论的读取与写入。

首先，我需要提供一个具有 Discussions:read 权限的个人 token，用来让后端读取评论数据。这样，即使是没有登录的人，也可以读取评论数据 (这个数据保存在了 Vercel 部署环境的环境变量中)。

接下来，我需要实现 OAuth 登录流程，获取用户的 GitHub 个人 token，用来让用户进行评论的写入。
这个过程主要需要两个主要的 API 端点：
- 对于用户登录的入口，我们需要一个 `login` 端点，使得用户可以被重定向到 GitHub 的 OAuth 授权页面。
- 在授权完成之后，我们需要让 Github 重定向回我们的 `callback` 端点，并携带授权码 (code)，我们需要在这个端点处理 code 的交换，获取用户的个人 token，并作为 Cookie 返回给用户。
其中，`callback` 端点将会被写入 GitHub OAuth App 的授权回调 URL 中。
- 为了安全起见，我们还需要在 login 前后比较 `state` 参数，防止 #link("https://en.wikipedia.org/wiki/Cross-site_request_forgery")[CSRF] 攻击。

```typescript
// /api/callback.ts
// Get code and state from query parameters
const { code, state } = req.query;

// Get state from cookies (local storage on client side)
const cookieState = req.cookies.github_oauth_state;

// Validate state parameter to prevent CSRF attacks
if (!state || !cookieState || state !== cookieState) {
  return res.status(400).json({ error: 'Invalid OAuth state' });
}
```
最后，将用户的个人 token 作为 HttpOnly Cookie 返回给用户，就可以实现登录功能了。

== 开始评论！

评论过程需要：
- 观看已有的评论内容
- 编辑评论内容

=== 观看评论内容

观看已有的评论内容的基本实现比较简单，直接使用后端的个人 token 调用 GitHub GraphQL API 获取对应 Discussion 的评论列表即可。

不过，由于我们需要加载评论以及对应的回复 (reply)，我们不能仅仅满足于获取扁平的评论列表，还应该能够构建一个树形的评论结构。
由于 GitHub 的 Discussion 并没有回复回复 (reply of reply) 的功能，这个评论的树形结构事实上只有两层 (评论以及对应的回复)。使用 `replyTo { id }` 字段遍历评论列表即可构建这个树形结构。

在前端，这个结构可以抽象为 `Comment` 对象，其中包含

```typescript
export interface Comment {
  // Something else fields...
  replyTo?: {
    id: string;
  };
  replies?: Comment[];
}
```
利用这个结构，我们可以将对应的评论添加到 DOM 中，并最终用 HTML 模板渲染出来。

=== 与前端绑定的评论

当用户成功登录之后，前端会暴露一个简单的评论界面，允许用户查看与发布评论。
对于后端，则需要将这些评论请求转发到 GitHub GraphQL API 上。

我们可以简单地将网页的编辑评论功能抽象为发布评论、编辑评论以及删除评论三个 API 调用。
这在 GitHub GraphQL API 中分别对应 `POST`、`PATCH` 以及 `DELETE` 三个操作。

Moreover，不同权限的用户应当有不同的 API 调用权限。如果对于所有用户全部都暴露三个不同的 API 调用按钮在前端，点击之后再在浏览器中返回报错信息，这显然不优雅。

因此，在获得已有评论内容的时候，最好还需要返回当前用户的权限信息 (是否登录，是否为评论作者等)，以便前端决定是否渲染对应的编辑按钮。
我们可以在后端通过 `viewerCanUpdate` 与 `viewerCanDelete` 两个字段来判断当前用户的权限，并因此决定在前端是否渲染对应的编辑按钮。

== 子域名调用 API，部署

由于登录需要使用 GitHub OAuth 服务，要从外部域名传递 Cookie。
由于现代浏览器的安全设置，一般不允许任意的跨域 Cookie 传递 (这可能会造成 CSRF 攻击)。例如，参考 #link("https://developers.google.com/search/blog/2020/01/get-ready-for-new-samesitenone-secure")[Google 的说明]：

#custom-block(
  [_相反，当 Cookie 的网域与用户地址栏中的网站网域匹配时，则视为在同一网站（或“第一方”）环境中访问 Cookie。同一网站 Cookie 通常用于使用户在各个网站保持登录状态、记住其偏好设置并支持网站分析。_],
  title: "Note",
)

因此我们需要将博客的 API 部署在一个子域名下 (例如 api.example.com)，并且在设置 Cookie 的时候，指定 `Domain` 字段为 `.example.com` (注意前面的点号)，以便让主域名与子域名都可以访问这个 Cookie。

在实现过程中，由于我使用的域名本身是托管在阿里云上，而后端 Serverless 架构使用的是 Vercel，因此我需要在阿里云的 DNS 设置中添加一条 `CNAME` 记录，将 `api.homeward-sky.top` 指向 Vercel 提供的域名。

= 总结

构建一个手搓的评论系统其实并不复杂，最重要的还是做好减法，知道自己真正的需求是什么，再结合适当的架构来实现它。
在本例中，Serverless 架构与 GitHub Discussions 的结合，极大地简化了评论系统的实现难度，让我可以专注于前端的样式设计与用户体验提升。

不过，既然选择了部署在第三方 Serverless 平台上，就必然要承担平台稳定性的风险。事实上，就在博客系统上线的第二天，Vercel 就出现了大规模的宕机，导致评论系统无法使用 (参考 #link("https://github.com/pxwg/blog/issues/20")[issue])。
当然，因为我们的后端 API 只是一些简单的登录与评论转发功能，即使 Vercel 宕机，博客的阅读功能依然不受影响，这也是 Serverless 与 Astro 孤岛架构的好处所在。

同时，正因为这一系列 API 部署的简单性，即使 Vercel 宕机，我也可以快速地将 API 迁移到其他平台上，例如 Cloudflare Workers 或者 AWS Lambda，从而保证评论系统的持续可用性。
