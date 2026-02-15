#import "../../../typ/templates/blog.typ": *
#let title = "Zettel 森林的自我生长"
#show: main-zh.with(
  title: title,
  desc: [Zettelkasten 方法与 AI 协同，实现 Typst 笔记系统的自我生长。],
  date: "2026-02-15",
  tags: (
    blog-tags.software-engineering,
    blog-tags.programming,
  ),
  lang: "zh",
  translationKey: "zettel_typst",
)

// {content: start}

市面上有很多基于 Markdown 的 Zettelkasten 笔记系统，最著名的莫过于 Obsidian。
然而：
- 我不想使用 Markdown。
  - 正如我在#link("../typst_md_tex")[这篇文章中]讨论的那样，Typst 是一个加强版 Markdown 和 LaTeX 的混合体，具有更强的表达能力和更好的可读性。
    我希望我的 Zettelkasten 笔记系统能够直接使用 Typst 来编写笔记。
  - 由于我的博客、专题笔记是用 Typst 编写的，如果能够保持相同的技术栈，整理笔记和撰写博客就可以无缝衔接，效率更高。
- 我想要一个基于我个人编辑环境的 Zettelkasten 笔记系统。
  对于我而言，就是 Neovim。

Neovim 的好处是高度的可扩展性，可能的坏处就是需要我们自己动手实现想要的功能。
好在现在有 AI Agent，在这种脚本型、自己用的开发环境上，效率还是非常高的。
关键问题在于 #link("https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents")[Context Engineering] 的实践。
这篇博客想要传达的中心观点就是，*构建 Zettelkasten 笔记系统所需要的上下文，可以通过 Zettelkasten 笔记系统构建*。

= 什么是 Zettelkasten

你可以参考#link("https://zettelkasten.de/overview/")[这个]来获得一个很好的概述。我们在这里只做一个非常简短的介绍：
- Zettelkasten 是一个德文单词，意思是“卡片盒”
- “卡片盒”中的对象是一系列“卡片”，这些卡片承载着单一主题的信息，例如一个概念、一个想法、一个问题等，被称为“原子式”的笔记
- 我们已经提到了对象，那自然还会想到有态射。
  Zettelkasten 中的态射就是链接，通过链接来构建笔记之间的关系。
  例如，在撰写有关 Flat Connection 和 Local System 之间关系的笔记时，我可以写
  ```typ
  = Flat/Integrable Connection and Local Systems <2602151850>
  #tag.geometry

  Let $X$ be a complex-analytic variety.
  The following are equivalent:

  - Local system $->$ Holomorphic vector bundle + Flat connection
    - The complex @2602150951 $V$;
    - The @2602151916 $cal(V) = cal(O) times.o V$ endowed with its canonical connection.
  ```
  其中`@2602151916` 和 `@2602150951` 就是链接，分别指向了`Holomorphic vector bundle`和`Local system`这两个概念的笔记对象。
  这样，我们
  - 在撰写时，不必在每个笔记中重复定义这些概念，节省时间、保证一致性
  - 在阅读时，如果不清楚这些概念，可以通过链接快速跳转到相关的笔记，如果清楚，则可以一笔带过。

#image_viewer(
  path: "../assets/zettel_typst_1.png",
  desc: "Zettelkasten 笔记示例，我配置了 Neovim Extmark 将链接的笔记标题覆盖在链接上，在保证链接唯一性的同时提高了可读性。",
)


这或许让人感到非常熟悉：没错，无论是 Wikipedia, nLab 还是 Stack Project，他们都是通过这种 Zettelkasten 的方法来构建的：
- 每一个条目原子化地承载单一概念
- 通过链接来构建不同概念的关联
从某种意义上说，构建一个个人的 Zettelkasten 笔记系统，就是在构建一个个人的 Wikipedia/nLab/Stack Project。

= Zettelkasten 森林的生长

正如所有 AI 编码项目一样，最大的挑战就是如何设计好 Prompt。
在我们这个项目中，Prompt 的设计主要体现在两个方面：
- 长线作战：我们是一个长期维护的项目，这意味着每一次单开一次 AI session，都将面对一个全新的 AI Agent，作为一个 stateless 的对象，我们需要手动维护一个巨大的上下文，包含但不限于：
  - 整体的项目架构，包含整个项目的愿景与结构等
  - 当前的开发进度，包含已经完成的功能和待完成的功能等
- 短暂任务：迭代笔记系统并不是我们的主要生活，AI 参与的敏捷开发时保持笔记常青的唯一途径

我们会注意到，构建笔记系统的需求本质上都是“原子式”的，可以通过单主题的语言来描述。
例如“加一个快捷键”、“Telescope 插件增加一个功能”等。
然而，当我们需要将这些“原子式”的需求投喂给 AI 时，就必须要包含其依赖。
这事实上与 Zettelkasten 的核心理念是非常契合的：每一个笔记都是一个独立的原子式对象，通过链接来构建它们之间的关系。
这就是我们使用 Zettelkasten 方法来实现上下文工程的初衷。

接下来我们就来开始简单地展示我是如何让 Zettelkasten 方法结合 AI 实现笔记系统的自我生长的。

首先，我们需要一个 idea，在 Zettelkasten 笔记法中，就对应这一个笔记。
当然，我们现在还处于“鸿蒙初开”的时期，啥也没有，这得要我们自己先构建一个项目基本架构。
我的想法是，在 `~/wiki/` 目录下构建我的知识库，并包含一些入口文件和模板文件，正文放在 `~/wiki/note/` 目录下，文件名为时间戳，例如 `2602151850.typ`。把这个“想法”写成文字，这就是我们这个 Zettelkasten 笔记系统中的第一个笔记了 (由于基本是终端
阅读导向，因此 ASCII 风格的树状结构就足够了)：

#remark[我们这里所有的 Tag 为了方便全部写成类似 `<1>` 的样子，而不是按照规范写成时间戳，主要是为了方便读者阅读。]

````typ
= Typst ZK Note Taking <1>

我们想要构建一个基于 `Typst` 的 ZK 笔记系统，来管理我们的笔记和知识库。

== 结构

`~/wiki/` 目录下的结构如下：
```
wiki/
├── index.typ
├── link.typ
├── note/
│   ├── 2602072319.typ
│   ├── 2602082037.typ
│   ├── 2602082106.typ
```
其中 `index.typ` 是整个 wiki 的入口文件，包含了所有的函数调用，样式配置与定义。`link.typ`包含了所有`note/`下笔记的`#include`y 语句，`note/`目录下的每个`.typ`文件都是一个笔记，文件名是笔记的时间戳，格式为`yyMMddHHmm`。
- `#include` 语句的格式为 `#include "note/xxxx.typ"`，其中 `xxxx` 是笔记文件的时间戳，格式为`yyMMddHHmm`
- 整体结构为：
```typ
// index.typ
// ... 其他内容 ...
#include "note/<YYMMDDHHMM>.typ"

// note/YYMMDDHHMM.typ
#import "../include.typ": *
#show: zettel

= Note Title <YYMMDDHHMM> // Note title 用户更新，label 则由系统自动生成
@YYMMDDHHMM 链接其他笔记
```
````

那么现在，我们肯定要在这个主题下继续思考。
首先我会想到，我需要一些脚本来帮助我
- 自动编译 `link.typ`，来包含 `note/` 目录下的所有笔记的 `#include` 语句
- 在 Neovim 中实现一些快捷键，帮助我 CURD 笔记内容，以及搜索笔记
- 实现正向与反向跳转功能，来帮助我在依赖关系中快速跳转
把它们全部记录在上面的笔记中，就可以开始初步的构建了。

前两个任务看起来都很简单，为了让 AI 明白我们要干什么，比如，我们希望写一个`lua` 脚本来实现第二个功能，作为插件在 Neovim 中使用，那么我们就可以写一个新的笔记来描述这个功能 (在我的实践中，其实我是分了几个笔记分别追踪管理这些功能，在这里我们就先放在一起)：
````typ
= ZK and Neovim Tools <2>

我们需要构建编辑器工作流。目前的规范参考 @1

自动化这个流程需要：
-  自动根据当前日期时间生成 id，并创建对应的 `.typ` 文件，进入这个文件进行编辑
-  在创建文件的同时，自动在 `link.typ` 中添加 `#include` 语句来引用这个 note

这将被实现为 Neovim 脚本
- [ ] `ze` 结合链接关系，从当前笔记出发，将所有直接或间接依赖的笔记都导出，并复制到剪贴板，为 AI 提供上下文
- [ ] `zn` 触发创建 note 的流程
  - 直接`cd` 到 `~/wiki/` 目录下，执行创建 note 的命令，命令包含：
    - [ ] 生成 id，按照模板创建文件，打开文件进行编辑，光标落在标题处
    - [ ] 在 `link.typ` 中添加 `#include` 语句
- [ ] `zs` 绑定 Telescope 插件，按照标题等搜索笔记，选中后跳转
- [ ] `zr` 绑定删除当前插件，需要：
  - [ ] 删除当前笔记文件
  - [ ] 在 `link.typ` 中删除对应的 `#include` 语句
````
这样就可以开始做了！由于目前 `ze` 还没有写出来，还是得手动将两个笔记的内容复制到剪贴板来提供给 AI，不过完事开头难，把这个初始的目标做好，后面会越来越快。

编辑了几个笔记之后，我发现写 `- [ ]` 的时候非常辛苦，因为要手动输入 `[ ]`。不放过这个想法，也把它记录下来：

````typ
= ZK TDL Keymap <3>
#tag.done

@2 中的 Neovim 插件还需要添加：
- [x] 快速加 `- [ ]` 来标记待办事项 (`ctrl+t`)，以及用快捷键来切换 `- [ ]` 和 `- [x]` 来标记完成状态 (如果已经有，用 `ctrl+t` 来切换状态)
````

直接调用 `ze` 来导出当前笔记和上下文，扔给 AI 写完、验收。

写着写着我发现`@yyMMddHHmm`的格式虽然方便索引，但是不方便在笔记中阅读。
我注意到 Neovim 可以用 Extmark 在 buffer 上绘制一些额外的内容，想法呼之欲出：用 Extmark 将全文标题覆盖在 `@yyMMddHHmm` 上，这样既可以保证文件名的唯一性和索引的便利性，又可以让笔记内容更易读。
不放过这个想法，创建一个笔记记录下来

````typ
= Extmark and ZK Link <4>

- [ ] 使用 Neovim 的 Extmark 功能，在笔记中将 `@yyMMddHHmm` 的格式展示为对应笔记的标题，例如 `@2602151850` 展示为 `@Flat/Integrable Connection and Local Systems`，来提升笔记的可读性。
````
直接调用 `ze` 来导出当前笔记和上下文，扔给 AI 写完、验收。

写着写着发现，可能需要一个 Tag 标记笔记的状态、类别，比如`todo` `wip` `neovim`，这个直接在 Typst 的模板函数中实现就好了。当然，也需要在 Telescope 中实现按照 Tag 搜索的功能，追加一个笔记：
````typ
= ZK Tag Search <5>

我们需要在 @2 中的 Neovim 插件中添加：
- [x] 通过 Tag 搜索笔记的功能，利用 Telescope 来实现
  - `zs` 唤出 Telescope 搜索页面后，按照 `ctrl+t` 来切换搜索模式，切换到 Tag 搜索模式后，输入 Tag 名称来搜索对应的笔记
````
导出上下文后继续实现。

渐渐地，我们发现，在不断使用这个系统的过程中：

- 由于创建笔记的压力在第一步便消去，使得我们可以迅速地将想法记录下来，形成一个个原子式的笔记
- 在使用笔记时涌现出来的改进意见不断地被记录下来，形成一个个原子式的功能需求
- 通过将其在撰写过程中与整理过程中不断与之前的笔记对象进行链接，形成一个个链接关系对象，构成完整的需求文档
- 将这个包含上下文与原子式需求的文档投喂给 AI 来实现
最终，我们通过
- 设计好笔记的结构与格式
- 纪律性的记录规范与链接习惯
几乎没有任何压力，非常自然地构建了一个基于 Typst 的 Zettelkasten 笔记系统，并且通过 AI Agent 来实现了这个系统的自我生长。

由于功能添加在 Zettelkasten 笔记系统中被记录为一个个原子式的笔记对象，因此每当我们想要添加一个功能时，我们只需要创建一个新的笔记来描述这个功能需求。
相对于为每一个功能都新建一个 Prompt 与 Context，这样的途径显然阻力很小，效率更高。

当然，这个构建的过程只是一个开始，还有很多的 idea 值得被实现，比如多端同步、基于 LSP 的连接正向反向跳转、基于标签的智能搜索等等，这些都可以通过同样的方式来实现：将它们记录为一个个原子式的笔记对象，并且通过链接来构建它们之间的关系，最终投喂给 AI 来实现、验收。
这些功能我均已实现，不过由于涉及到的技术细节比较多，或许更适合在后续的文章中进行展示。
