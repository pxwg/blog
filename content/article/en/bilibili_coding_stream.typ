#import "../../../typ/templates/blog.typ": *
#let title = "Live Coding on Bilibili Using iPad as a Secondary Display"
#show: main.with(
  title: title,
  desc: [Documenting the entire process of setting up a Bilibili coding live stream: from privacy protection to audio synchronization, encountering many pitfalls, and finally building a stable solution using SideCar + SonoBus + BlackHole.],
  date: "2026-03-02",
  tags: (
    blog-tags.software-engineering,
    blog-tags.programming,
  ),
  lang: "en",
  translationKey: "bilibili_coding_stream",
  llm-translated: true,
)

I usually use a Typst-based Zettelkasten system for note-taking and knowledge management. One day, a thought struck me: could I livestream my study sessions? On one hand, it would serve as self-discipline; on the other, it could share my daily coding workflow. I chose Bilibili as the platform, and the tech stack would be the same wiki system I use daily.

It sounds simple, but when I actually started, I found far more problems than anticipated—privacy, streaming method, audio synchronization, each of which took quite a while to sort out.

= Privacy: Stub, Not Delete

The first issue was privacy. My wiki contains many private notes that shouldn't be visible during a stream. The most intuitive approach would be to delete sensitive notes or filter out references, but that doesn't work in a Zettelkasten system—notes have numerous `@timestamp` cross-references; deleting one note would cause compilation errors elsewhere, and cleaning up references would modify many files, leading to merge conflicts when merging back into the main branch.

Eventually, I chose a smarter solution: *stub (empty-shell replacement)*. Sensitive notes are not deleted but replaced with empty shells that retain only the filename and Typst label:

```typ
/* hidden */
#import "../include.typ": *
#show: zettel

= [Hidden] <2602xxxxxx>
```

This way, references from other notes can still be resolved normally, compilation doesn't break, and other note files remain completely unchanged, resulting in zero merge conflicts.

For implementation, I wrote a `zk_delete_by_tag.py` script supporting three modes: `--stub` replaces matching notes with empty shells (for the streaming branch), `--delete` permanently deletes (for the main branch), and `--restore-stubs` restores stubs to real content during merging. Coupled with a `post-checkout` Git Hook, switching to the `stream` branch automatically stubs and commits, while switching back to `main` automatically merges and filters out stub files. The whole workflow is: `main` is always the source of truth, `stream` is a purely derived branch, and the two branches synchronize bidirectionally without conflicts.

= Streaming: iPad Secondary Display Approach

With privacy solved, the next step was how to stream. Initially, I researched various macOS screen recording/livestreaming tools (OBS, Bilibili client, etc.), only to find that they either introduced too much latency or interfered too much with my coding environment. My core requirement for a streaming tool was: it must not affect the coding experience; performance on macOS must be prioritized.

After several rounds of testing, I switched to a completely different approach—don't stream from the Mac at all, but use the iPad. This involves mirroring the Mac's screen content and system audio to the iPad, letting the iPad handle the streaming. The advantage of this scheme is: the Mac only needs to focus on coding; the performance burden of streaming is entirely shifted to the iPad, minimizing interference from streaming tools on the Mac.

== HDMI + Orion/Genki Studio: Poor Performance and Display Quality

The earliest hardware capture approach I investigated was: Mac connected via HDMI to a Genki Studio capture card, the capture card plugged into the iPad's Type-C port, iPad recognizing the capture card as a camera via iPadOS 17's native UVC protocol, then using #link("https://orion.tube/")[Orion] to bring up the Mac's screen on the iPad, and finally the Bilibili client screen‑records the iPad screen for streaming. In theory, Mac performance overhead is zero.

Hardware connected, Orion opened, picture appears. But the terminal colors are all wrong. The reason lies in the YUV color‑range mapping deviation of USB video capture: the capture card defaults to MPEG limited range rather than Full range, causing the carefully tuned terminal color scheme to be compressed and darkened, whites turn gray, overall contrast collapses. This issue isn't at the software level; it's an inherent flaw of the hardware capture chain, adjusting Orion's display parameters only treats symptoms. For a livestream where I stare at the terminal writing code all day, if what the audience sees is completely different from what I actually use, that's simply unacceptable. This scheme was thus abandoned.

== SideCar + Bilibili Client: Final Solution

The final effective solution is straightforward: use SideCar to turn the iPad into a secondary display for the Mac, then stream directly with the Bilibili client on the iPad. This way, the Mac only needs to handle coding; the streaming load is entirely shifted to the iPad. The video part is solved.

Incidentally, during streaming I need to show currently playing music, but can't add overlays on the coding screen that would interfere with writing code (the client also can't add overlays while streaming). I simply used Simple‑Bar's Now Playing feature to display song information in the status bar at the top of the secondary display—visible to the audience, no interference with my coding.

Another small detail: all notification pop‑ups must be disabled during streaming. macOS's built‑in "Focus Mode" can do this; just set up a custom mode that automatically activates when streaming.

= Audio Synchronization

Video sorted, audio turned out to be the biggest hurdle. My core requirement: write code while listening to music, and the audience hears the same music during the stream, with the currently playing track displayed on my Simple‑Bar. This seems simple, but copyright restrictions and technical implementation posed significant challenges.

Essentially, there are two approaches:
- iPad to Mac: Play music on the iPad, somehow synchronize the currently playing song information and audio to the Mac, and have the Bilibili client directly capture the iPad's audio output. Difficulty lies in implementing audio‑information synchronization.
- Mac to iPad: Play music on the Mac, somehow push the audio to the iPad, and have the Bilibili client capture the iPad's audio output. Difficulty lies in the performance and stability of audio transmission.

== Last.fm: Copyright Wall

The first attempt was to play music on the iPad, poll the Last.fm Scrobble API, and display the currently playing song on Simple‑Bar on the Mac side. This idea is intuitive and not hard to implement. However, when streaming on the iPad, the Bilibili client restricts audio sources—copyright limitations prevent the music from being audible at all. Although this scheme is theoretically the most elegant, it ultimately couldn't be realized (I don't think I have the skills to hack Apple's screen‑recording restrictions). Regretfully dropped.

== NetEase Cloud Music: API Latency

I usually use NetEase Cloud Music; there's a #link("https://www.npmjs.com/package/NeteaseCloudMusicApi?activeTab=code")[NeteaseCloudMusicApi] that reverse‑engineers NetEase's interfaces, theoretically allowing retrieval of the account's currently playing audio, thus obtaining song information and audio data via API polling. In a sense, this is the NetEase version of the Last.fm scheme.

However, the NetEase version doesn't have a "currently playing music" API, only a "recently played music" API, which leads to a problem: there is noticeable latency between the song information returned by the API and the actual currently playing track, and they can even fall out of sync. For livestreaming, such latency is unacceptable because the audience would perceive music‑video desynchronization, affecting viewing experience. Consequently, this scheme was also abandoned.

== AirFoil: Performance Woes

Since music couldn't be played on the iPad, reverse it: play on the Mac, use #link("https://rogueamoeba.com/airfoil/mac/")[AirFoil] to push audio to the iPad. Combined with macOS's MIDI settings to set AirFoil as the system default output, copyright issues are indeed circumvented. But AirFoil's performance is too poor: noticeable audio latency and considerable system resource usage, affecting the coding experience. Unacceptable#footnote[I even spent a few bucks on Taobao to buy an AirFoil license, but ultimately gave up].

== FFmpeg + RTP: Performance and Stability Woes

AirFoil's failure proved that GUI tools don't work in this scenario. As a terminal enthusiast, the next natural thought—bring in FFmpeg. The idea: use BlackHole to capture the Mac's system audio, then have FFmpeg read BlackHole's output and directly push via RTP protocol to the iPad's IP address, with the iPad side using #link("https://www.videolan.org/vlc/")[VLC] to receive and play. Pure command‑line, zero GUI overhead, leveraging the M3 chip's hardware audio encoder, theoretically elegant.

Spent an afternoon tuning FFmpeg parameters, solved the `avfoundation` input sample‑rate negotiation issue, manually adjusted RTP packet size and VLC's jitter buffer. But reality is harsh: RTP over UDP is inherently unstable over Wi‑Fi and wired LAN setups; network jitter directly leads to buffer underruns, crackling, dropouts—worse than AirFoil. Switching to a local MediaMTX relay for RTMP before forwarding to the iPad added another layer of complexity, increasing latency and dropouts. No matter how cool the CLI is, if it can't stay stable, it's a no‑go. Reluctantly abandoned this scheme that I most wanted to succeed.

== SonoBus + BlackHole: Final Solution

Finally found SonoBus—an open‑source low‑latency audio transmission tool. Architecture as follows:

- Use BlackHole (virtual audio device) to route the Mac's system audio to SonoBus
- SonoBus synchronizes audio between Mac and iPad
- The iPad side receives the audio, and the Bilibili client directly streams it out

Performance is decent, latency acceptable. To further reduce latency, I experimented with a USB direct‑connection scheme: use a USB network adapter plus macOS Internet Sharing to let the iPad obtain network via USB. Compared to sharing the campus Wi‑Fi for Opus audio streaming, the effect is better. However, macOS's Internet Sharing GUI refuses 802.1X networks as sharing sources; unfortunately, our `Tsinghua‑Secure` is exactly that, so I had to manually configure `pfctl` and `dnsmasq`. After this tweaking, latency dropped below 10 ms, packet loss under 0.1%. Audio stability during streaming is good. Finally, I asked Claude Code to script it, enabling one‑click launch and monitoring.

Meanwhile, I still need to listen to music while coding, so AirPods serve as the monitoring device. macOS's multi‑output device feature can output simultaneously to SonoBus and AirPods; I slightly lowered the audio quality for the streaming side (audience won't notice anyway—it'll be compressed by Bilibili), while keeping original quality for AirPods.

Initially, when setting up SonoBus streaming, there was a faint background hiss and static noise. The root cause turned out to be Wi‑Fi transmission jitter causing SonoBus buffer underruns, not an audio‑quality issue itself. Switching to the USB direct‑connection scheme eliminated the noise entirely. Another key point: sample rates on both Mac and iPad must match, both set to 48 kHz. The iPad side sometimes inexplicably drops to 24 kHz; needs manual verification and adjustment (restarting the app fixes it). After proper adjustment, audio quality is completely fine#footnote[Of course, compression loss from Opus encoding is unavoidable, but entirely acceptable in this scenario].

= Division of Labor

The final architecture is as follows: Mac focuses on coding, iPad focuses on streaming. Video goes via SideCar secondary display, audio via SonoBus + BlackHole synchronization, AirPods handle monitoring, Simple‑Bar shows currently playing music, `post‑checkout` Hook automatically manages privacy. The whole setup requires no heavyweight streaming software installed on the Mac, and the coding environment's performance remains completely unaffected. This is essentially an application of Unix philosophy in the livestreaming domain: *excellent software each does its own job, combining into a powerful system*.