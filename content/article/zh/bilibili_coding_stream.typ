#import "../../../typ/templates/blog.typ": *
#let title = "搭建云上自修室"
#show: main-zh.with(
  title: title,
  desc: [使用 iPad + SideCar + SonoBus 搭建云上自修室，直播写代码的日常工作流。],
  date: "2026-03-02",
  tags: (
    blog-tags.software-engineering,
    blog-tags.programming,
  ),
  lang: "zh",
  translationKey: "bilibili_coding_stream",
)

我平时用一套基于 Typst 的 Zettelkasten 系统记笔记、管理知识库。某天突发奇想：能不能直播自习过程？一方面当作对自己的监督，一方面分享一下日常的编码工作流。平台选了 B 站，技术栈就是我日常在用的这套 wiki 系统。

听起来很简单，但真正开始做的时候才发现问题远比预期多——隐私、推流方式、音频同步，每一个都折腾了好一阵。

= 隐私：Stub 而非删除

第一个问题是隐私。我的 wiki 里有不少私人笔记，直播时不能让观众看到。最直觉的做法是把敏感笔记删掉或者过滤掉引用，但这在 Zettelkasten 系统里行不通——笔记之间有大量 `@timestamp` 交叉引用，删除一个笔记就会导致其他笔记编译报错，而清理引用又会改动大量文件，merge 回主分支时冲突成灾。

最终我选了一个更聪明的方案：*stub（空壳替换）*。敏感笔记不删除，而是替换成只保留文件名和 Typst label 的空壳：

```typ
/* hidden */
#import "../include.typ": *
#show: zettel

= [Hidden] <2602xxxxxx>
```

这样其他笔记中的引用仍然能正常解析，编译不报错，同时其他笔记文件完全没有改动，merge 零冲突。

具体实现上，我写了一个 `zk_delete_by_tag.py` 脚本，支持三种模式：`--stub` 将匹配笔记替换为空壳（直播分支专用）、`--delete` 永久删除（主分支用）、`--restore-stubs` 在合并时将 stub 还原为真实内容。配合一个 `post-checkout` Git Hook，切到 `stream` 分支时自动 stub 并提交，切回 `main` 时自动合并且过滤掉 stub 文件。整个流程是：`main` 永远是 source of truth，`stream` 是纯派生分支，两个分支无冲突地双向同步。

= 推流：iPad 副屏方案

解决了隐私问题，下一步是怎么推流。一开始我调研了各种 macOS 上的录屏/直播工具 (#link("https://obsproject.com/")[OBS]，#link("https://www.bilibili.com/")[哔哩哔哩]客户端等)，结果发现要么延迟太高，要么对我的编码环境干扰太大。我对直播工具的核心诉求是：不能影响编码体验，MacOS 这边的性能必须优先保障。

试了几轮之后换了个完全不同的思路——不在 Mac 上推流，而是用 iPad。这就涉及到将 Mac 的屏幕内容和系统音频同步到 iPad 上，让 iPad 负责推流。这个方案的好处是：Mac 只需要专注于编码，推流的性能压力完全转嫁给 iPad，直播工具对 Mac 的干扰降到最低。

== HDMI + Orion/Genki Studio：性能与显示效果不佳

最早调研的是物理采集方案：Mac 通过 HDMI 线接一块 Genki Studio 采集卡，采集卡插进 iPad 的 Type-C 口，iPad 通过 iPadOS 17 原生支持的 UVC 协议把采集卡识别成摄像头，再用 #link("https://orion.tube/")[Orion] 在 iPad 上把 Mac 的屏幕调出来，哔哩哔哩客户端对 iPad 屏幕录屏推流。理论上 Mac 性能损耗为零。

硬件接好，打开 Orion，画面出来了。但终端的颜色全错了。原因在于 USB 视频采集的 YUV 色彩范围映射出现偏差：采集卡默认使用 MPEG 有限范围而非 Full 范围，导致精心调校的终端配色全部被压缩变暗，白色变灰，对比度整体塌陷。这个问题不在软件层面，是硬件采集链路的固有缺陷，调整 Orion 的显示参数也只是治标。对于一个全天候盯着终端写代码的直播来说，如果观众看到的画面和我实际在用的完全不是同一个东西，这一定是不可接受的。这个方案就这样被淘汰了。

== SideCar + 哔哩哔哩客户端：最终方案

最终生效的思路方案很简单：通过 #link("https://support.apple.com/en-us/102597")[SideCar] 把 iPad 变成 Mac 的副屏，然后在 iPad 上用哔哩哔哩客户端直接推流。这样 Mac 只需要负责编码，推流的压力全部转嫁给 iPad。视频部分就这么解决了。

顺便，直播时需要展示当前播放的音乐，但不能在编码屏幕上加 overlay 干扰写代码 (客户端也不能做到在推流时加 overlay)。我直接用 #link("https://github.com/Jean-Tinland/simple-bar")[Simple-Bar] 的 Now Playing 功能，在副屏顶部的状态栏里显示歌曲信息，观众看得到，我写代码不受影响。

还有一个小细节：直播过程中必须禁掉一切通知弹窗。macOS 自带的"专注模式"可以做到这一点，设置一个自定义模式，直播时自动开启就行。

= 音频同步

视频搞定了，音频反而成了最大的坑。我的核心诉求是：一边写代码，一边听音乐，直播时观众也能听到同样的音乐，并且在我的 Simple-Bar 上显示音乐。这个需求看似简单，但版权限制和技术实现都带来了不小的挑战。

实现这个的途径基本上是两个方案：
- iPad to Mac：在 iPad 上播放音乐，通过某种方式把正在播放的歌曲信息和音频同步到 Mac 上，哔哩哔哩客户端直接内录 iPad 的音频输出。难点在于同步音频信息的实现
- Mac to iPad：在 Mac 上播放音乐，通过某种方式把音频推送到 iPad 上，哔哩哔哩客户端内录 iPad 的音频输出。难点在于音频传播的性能和稳定性。

== Last.fm：版权墙

第一个尝试是在 iPad 上播放音乐，通过 #link("https://www.last.fm/")[Last.fm] Scrobble 接口轮询 API，在 Mac 端的 Simple-Bar 上显示正在播放的歌曲。这个想法很直观，做起来也不难。但 iPad 上直播时，B 站客户端会限制音频来源——版权限制导致音乐根本播不出声。虽然这个方案理论上是最为优雅的，但最终还是落不了地 (我不觉得我有本事 Hack 苹果录屏的限制)。遗憾离场。

== 网易云音乐：API 延迟

我平时用的是网易，有一个 #link("https://www.npmjs.com/package/NeteaseCloudMusicApi?activeTab=code")[NeteaseCloudMusicApi] 专门逆向了网易云的接口，理论上可以通过它获得账户正在播放的音频，这样便可以通过轮询 API 的方式来获得当前网易云音乐播放的歌曲信息和音频数据。这在某种意义下就是 Last.fm 方案的网易云版本。

然而，网易云版本并不存在“当前播放音乐”API，只有“最近播放音乐”API，这就导致了一个问题：API 返回的歌曲信息和实际正在播放的歌曲之间会有明显的延迟，甚至可能出现不同步的情况。对于直播来说，这种延迟是不可接受的，因为观众会感觉到音乐和视频不同步，影响观看体验。因此，这个方案也被迫放弃了。

== AirFoil：性能拉胯

既然 iPad 上播不了音乐，那就反过来：在 Mac 上播放，用 #link("https://rogueamoeba.com/airfoil/mac/")[AirFoil] 把音频推送到 iPad。配合 MacOS 的 Midi 设置把 AirFoil 设为系统默认输出，版权问题确实绕过了。但 AirFoil 的性能太差，音频延迟明显，而且占用不少系统资源，影响编码体验。不可接受#footnote[我还在淘宝上花了几块钱购买 AirFoil 的授权，最终还是放弃了]。

== FFmpeg + RTP：性能与稳定性拉胯

AirFoil 的失败证明 GUI 工具在这个场景下走不通。作为一名终端玩家，下一步想法很自然——上 FFmpeg。思路是：用 #link("https://existential.audio/blackhole/")[BlackHole] 把 Mac 的系统音频截获，再用 #link("https://ffmpeg.org/")[FFmpeg] 读取 BlackHole 的输出，以 RTP 协议直接推送到 iPad 的 IP 地址，iPad 端用 #link("https://www.videolan.org/vlc/")[VLC] 接收播放。纯命令行，零 GUI 开销，M3 芯片的硬件音频编码器直接上，理论上优雅至极。

调了一个下午 FFmpeg 参数，解决了 `avfoundation` 输入的采样率协商问题，RTP 包大小和 VLC 的抖动缓冲区也都手动调过。但现实很骨感：RTP over UDP 在 Wi-Fi 和基于数据线的局域网组网下本质不稳定，网络抖动直接导致缓冲区欠载，爆音、断续，比 AirFoil 还难听。换成走本地 #link("https://github.com/bluenviron/mediamtx")[MediaMTX] 做 RTMP 中继再转 iPad，增加了一层复杂度，延迟和断续反而增加了。CLI 再帅，稳不住就是稳不住。最终忍痛放弃了这个我最想让它成功的方案。

== SonoBus + BlackHole：最终方案

最终找到了 #link("https://www.sonobus.net/")[SonoBus]——一个开源的低延迟音频传输工具。架构如下：

- 用 BlackHole（虚拟音频设备）把 Mac 的系统音频路由到 SonoBus
- SonoBus 在 Mac 和 iPad 之间同步音频
- iPad 端接收到音频后，哔哩哔哩客户端直接推流出去

性能不错，延迟可以接受。为了进一步压低延迟，我还折腾了 USB 直连方案：用一个 USB 网卡加上 macOS 互联网共享，让 iPad 通过 USB 连接获取网络。相对于使用校园网共享 Opus 音频流，效果更好。不过 macOS 的互联网共享 GUI 会拒绝 802.1X 网络作为共享源，很遗憾我们的 `Tsinghua-Secure` 就赫然在此，只能手动配置 `pfctl` 和 `dnsmasq`。折腾完之后延迟降到 10ms 以内，丢包率低于 0.1%。直播中音频稳定性不错。最后拜托 Claude Code 将其脚本化，实现一键启动和监控。

同时，我自己写代码还得听音乐，所以需要 AirPods 作为监听设备。macOS 的多输出设备功能可以同时输出到 SonoBus 和 AirPods，我给推流端的音质稍微降了一点（反正观众听不出来，会经过 B 站压缩），AirPods 端保持原始音质。

最早建立时 SonoBus 推流时有沙沙的背景杂音和电流声。排查下来根因是 Wi-Fi 传输抖动导致 SonoBus 缓冲区欠载，不是音质本身的问题。切到 USB 直连方案后噪音根本消除。另外还有一个关键点：Mac 和 iPad 两端的采样率必须一致，都设为 48 kHz。iPad 端有时候采样率会莫名降到 24 kHz，需要手动确认并调整 (重启 App 能解决)。调整好之后音质就完全没问题了#footnote[当然 Opus 编码的压缩损失是不可避免的，但在这个场景下完全可以接受]。

= 各司其职

最终的架构是这样的：Mac 专注编码，iPad 专注推流。视频走 SideCar 副屏，音频走 SonoBus + BlackHole 同步，AirPods 负责监听，Simple-Bar 显示正在播放的音乐，`post-checkout` Hook 自动管理隐私。整套方案不需要在 Mac 上安装任何重量级的直播软件，编码环境的性能完全不受影响。这其实很像是 Unix 哲学在直播领域的一个应用：*优秀的软件们各司其职，组合成强大系统*。
