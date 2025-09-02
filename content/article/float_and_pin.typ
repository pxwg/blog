#import "../../typ/templates/blog.typ": *
#let title = "在 MacOS 中置顶浮动窗口"
#show: main.with(
  title: title,
  desc: [利用 Objective-C 代码注入在 MacOS 中实现置顶浮动窗口，以 kitty 终端为例。],
  date: "2025-09-01",
  tags: (
    blog-tags.macos,
    blog-tags.programming,
  ),
)

= 缘起

MacOS 系统中，部分系统原生应用可以支持置顶窗口功能 (官方名称为“浮动在最前面”)，例如`Stickies`。部分非原生应用也可以实现浮动功能，例如`Typora`。

#figure(code-image(image("../assets/float_and_pin_2.png")))

将部分窗口置顶的功能在部分场景下非常有用，例如阅读文献时可以将笔记窗口置顶，方便随时记录笔记，即使切换到其他应用也不会遮挡笔记窗口，干扰笔记记录流程。

这个想法起源于大二学年量子力学数学方法结课报告的准备过程中，我就是使用类似的工作流 (但是当时没有置顶功能) 来阅读 Kontsevich 的 #link("https://link.springer.com/article/10.1023/B:MATH.0000027508.00421.bf")[Deformation Quantization of Poisson Manifolds] 论文并记录笔记的。

然而，对于我常用的笔记工具 `kitty`+`neovim`，并没有原生的置顶功能，而例如`Afloat`等第三方工具也无法在 Apple Silicon 芯片的 MacOS 上使用，并且长期未更新。因此，在很长一段时间内，我只能通过手动调整窗口位置来实现类似的功能，效率较低。

= 初步解决
$
  #text(size: 20pt, weight: 800, font: pdf-fonts)[警告！接下来的操作需要禁止部分系统完整保护 (SIP)，请你务必了解相关风险并自行承担后果！]
$
最近因为需要频繁地在阅读文献和记录笔记之间切换，因此我决定尝试寻找一种可行的解决方案。首先出局的是`hammerspoon`，因为他压根就没有这个功能。`yabai` (我是它的长期用户) 在尝试一阵子之后也放弃了，主要是因为在禁用 `nvram` 保护的情况下，我的电脑桌面会直接崩溃#footnote([这个事情非常吓人，我当时一度以为我的电脑坏了，后来全部重启 SIP 保护后才恢复正常。])。

在阅读了#link("https://github.com/kovidgoyal/kitty")[kitty 仓库]之后，我发现 kitty 的窗口是通过 Cocoa API 创建的，因此理论上可以通过 Objective-C 代码注入的方式来修改窗口属性，从而实现置顶功能。#link("https://apple.stackexchange.com/questions/219116/any-nice-stable-ways-to-keep-a-window-always-on-top-on-the-mac")[Stack Exchange] 上也有相关的讨论，主要是基于`lldb` 调整窗口的`level`属性来实现置顶功能。
```bash
lldb -p pid -o 'expr for (NSWindow *w in (NSArray *)[(NSApplication *)NSApp windows]) { [w setLevel:10]; }' -o 'detach' -o 'quit'
```
其中`pid`是目标进程的进程 ID，`level`属性的值越大，窗口越靠前。通常`NSNormalWindowLevel`的值为`0`，设置为`10`可以比较安全地实现置顶功能#footnote([启用 `lldb` 需要利用禁用 `debug` SIP 保护。我不会介绍具体的实现方案，如果你没有这样基本的信息检索能力，*请不要尝试本方案*])。

= 封装

每一次运行`lldb` 都会花费较长的时间。受到`Afloat`的启发，我认识到可以直接在目标进程 (在这里是 kitty) 中注入#link("https://gist.github.com/pxwg/d7a8c44ca280a81bf19b1e9ea6e63c1e")[代码]实现置顶功能，这样只需要在启动 kitty 时注入一次代码，此后通过 WebSocket 注入的代码通信即可实现对置顶功能的调控，这样还能很方便地实现热更新，并集成到常见的`Hammerspoon`等工具中。

根据#link("https://gist.github.com/pxwg/d7a8c44ca280a81bf19b1e9ea6e63c1e")[代码]编译完 `dylib` 文件后，只要通过
```bash
DYLD_INSERT_LIBRARIES=~/window_level/libwindow_level.dylib /Applications/kitty.app/Contents/MacOS/kitty nvim -c "SideNoteMode"
```
即可启动一个暴露了 WebSocket 接口的 kitty 窗口，之后通过例如
```bash
echo level | ncat -U /tmp/kitty_level.sock
```
即可改变当前窗口的置顶级别，`level`为整数，值越大窗口越靠前。将这个命令封装为 Hammerspoon 的快捷键即可实现快速置顶窗口。

#figure(code-image(image("../assets/float_and_pin_1.png")))

= 总结

这个方案需要禁用部分 SIP 保护 (`debug` 保护)，存在一定的安全风险，请务必了解相关风险并自行承担后果！在 github 上也存在基于辅助功能实现置顶功能的#link("https://github.com/lihaoyun6/Topit")[工具]，好处是无需禁用 SIP 保护，坏处是稳定性不佳、原生感不强、并且 Apple Watch 无法在其使用时解锁，如果不想禁用 SIP 的朋友可以尝试。
