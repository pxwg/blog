#import "../../../typ/templates/blog.typ": *
#import "../../../typ/templates/translation-disclaimer.typ": (
  translation-disclaimer,
)

#let title = "Pinning Floating Windows on Top in MacOS"
#show: main.with(
  title: title,
  desc: [Implementing pinned floating windows on MacOS via Objective-C code injection, using the kitty terminal as an example, without disabling SIP.],
  date: "2025-09-01",
  tags: (
    blog-tags.macos,
    blog-tags.programming,
  ),
)

#translation-disclaimer(
  original-path: "../../float_and_pin.typ",
  lang: "en",
)

= Origin

In the MacOS system, some native applications support the window pinning feature (officially called "Float on Top"), such as `Stickies`. Some non-native applications can also achieve the floating feature, such as `Typora`.

#figure(code-image(image("../../assets/float_and_pin_2.png")))

The ability to pin certain windows on top is very useful in specific scenarios. For example, when reading literature, you can pin a note-taking window on top, making it convenient to take notes at any time. Even when switching to other applications, the note window won't be obscured, thus not interfering with the note-taking process.

This idea originated during the preparation for the final report of the Quantum Mechanics Mathematical Methods course in my sophomore year. I used a similar workflow (but without the pinning feature back then) to read Kontsevich's #link("https://link.springer.com/article/10.1023/B:MATH.0000027508.00421.bf")[Deformation Quantization of Poisson Manifolds] paper and take notes.

However, for my commonly used note-taking tools `kitty`+`neovim`, there is no native pinning feature. Third-party tools like `Afloat` do not work on Apple Silicon Macs and haven't been updated for a long time. Therefore, for a long time, I could only achieve a similar effect by manually adjusting window positions, which was inefficient.

= Initial Solution
// $
//   #text(size: 20pt, weight: 800, font: pdf-fonts)[Warning! The following operations require disabling parts of System Integrity Protection (SIP). You must understand the associated risks and proceed at your own responsibility!]
// $
Recently, due to the frequent need to switch between reading literature and taking notes, I decided to try to find a feasible solution. The first option ruled out was `hammerspoon` because it simply doesn't have this functionality. After some attempts, I also gave up on `yabai` (I've been a long-term user) mainly because, with `nvram` protection disabled, my desktop would crash completely#footnote([This was very frightening; I thought my computer was broken at one point. It only returned to normal after fully restarting SIP protection.]).

After reading the #link("https://github.com/kovidgoyal/kitty")[kitty repository], I found that kitty windows are created using the Cocoa API. Therefore, in theory, the window properties could be modified by injecting Objective-C code to achieve the pinning feature. There are also relevant discussions on #link("https://apple.stackexchange.com/questions/219116/any-nice-stable-ways-to-keep-a-window-always-on-top-on-the-mac")[Stack Exchange], primarily based on using `lldb` to adjust the window's `level` property for pinning.
```bash
lldb -p pid -o 'expr for (NSWindow *w in (NSArray *)[(NSApplication *)NSApp windows]) { [w setLevel:10]; }' -o 'detach' -o 'quit'
```
Here, pid is the target process's process ID. The larger the value of the level property, the more frontmost the window. Typically, the value of NSNormalWindowLevel is 0. Setting it to 10 can safely achieve the pinning effect#footnote([Using lldb on system applications (located in the /System/ directory) requires disabling the debug SIP protection. I will not detail the implementation for this scenario. If you lack this basic information retrieval capability, please do not attempt this solution. For the use case of modifying the kitty window level, this solution does NOT require disabling SIP.]).

= Packaging

Running lldb each time takes a relatively long time. Inspired by Afloat, I realized that code could be injected directly into the target process (here, kitty) to #link("https://gist.github.com/pxwg/d7a8c44ca280a81bf19b1e9ea6e63c1e")[implement] the pinning feature. This way, the code only needs to be injected once when starting kitty. Subsequently, a WebSocket can be used to communicate with the injected code to control the pinning feature. This also allows for easy hot-swapping and integration into common tools like Hammerspoon as part of the workflow.

Since only one parameter needs to be passed, the WebSocket implementation is very simple. However, because a single kitty instance corresponds to multiple processes (the kitty itself, the kitten toolset, and some desktop rendering processes), a lock is needed to ensure only one process listens on the WebSocket socket. Otherwise, port conflicts will occur, preventing normal communication#footnote([I added some Debug prints in the #link("https://gist.github.com/pxwg/d7a8c44ca280a81bf19b1e9ea6e63c1e")[Gist] precisely because of this issue.]).

This code shows the basic logic, omitting details like error handling and signal handling.

```objc
static void *socket_server(void *arg) {
  // Acquire lock to ensure only one process listens
  lock_fd = open(LOCK_PATH, O_CREAT | O_RDWR, 0600);
  if (lock_fd < 0)
    return NULL;
  struct flock fl = {.l_type = F_WRLCK,
                     .l_whence = SEEK_SET,
                     .l_start = 0,
                     .l_len = 0,
                     .l_pid = getpid()};
  if (fcntl(lock_fd, F_SETLK, &fl) < 0)
    return NULL;

  // Create socket
  sock_fd = socket(AF_UNIX, SOCK_STREAM, 0);
  if (sock_fd < 0)
    return NULL;

  // Bind address
  struct sockaddr_un addr = {0};
  addr.sun_family = AF_UNIX;
  strncpy(addr.sun_path, SOCKET_PATH, sizeof(addr.sun_path) - 1);
  unlink(SOCKET_PATH); // ignore ENOENT

  if (bind(sock_fd, (struct sockaddr *)&addr, sizeof(addr)) < 0)
    return NULL;
  chmod(SOCKET_PATH, 0600);

  // Start listening
  if (listen(sock_fd, 5) < 0)
    return NULL;

  // Signal handling omitted

  while (1) {
    int client = accept(sock_fd, NULL, NULL);
    if (client < 0)
      continue;
    char buf[32] = {0};
    ssize_t n = read(client, buf, sizeof(buf) - 1);
    if (n > 0) {
      int lvl = atoi(buf);
      setAllWindowsLevel(lvl);
    }
    close(client);
  }

  // Cleanup omitted
  return NULL;
}
The injected window pinning operation simply sets the window's level property to the specified value, exactly like the operation in lldb.

objc
static void setAllWindowsLevel(NSInteger level) {
  dispatch_async(dispatch_get_main_queue(), ^{
    NSArray *windows = [(NSApplication *)NSApp windows];
    for (NSWindow *w in windows) {
      [w setLevel:level];
    }
  });
}
```
After compiling the dylib file according to the #link("https://gist.github.com/pxwg/d7a8c44ca280a81bf19b1e9ea6e63c1e")[code], starting a kitty window that exposes the WebSocket interface can be done with:

```bash
DYLD_INSERT_LIBRARIES=~/window_level/libwindow_level.dylib /Applications/kitty.app/Contents/MacOS/kitty nvim -c "SideNoteMode"
```
Subsequently, using, for example:

```bash
echo level | ncat -U /tmp/kitty_level.sock
```
can change the current window's pinning level, where level is an integer. The larger the value, the more frontmost the window. Wrapping this command into a Hammerspoon hotkey enables quick window pinning.

#figure(code-image(image("../../assets/float_and_pin_1.png")))

= Summary

This solution does not require disabling SIP (for non-system apps). The advantage is a strong native feel, as it uses native APIs without experience issues. The drawback is that it is relatively difficult to operate and may require some basic programming knowledge.

There are also #link("https://github.com/lihaoyun6/Topit")[tools] on GitHub that implement the pinning feature based on accessibility functions. The advantage is that no programming is required. The disadvantages are poor stability, a less native feel, and the inability to use Apple Watch to unlock the Mac while such a tool is active. Friends who don't want to write code can try this.
