## Toward a more useful keyboard

Credits go to [jasonrudolph](https://github.com/jasonrudolph/keyboard).

## Features

- [Access **control** and **escape** on the home row](#a-more-useful-caps-lock-key)
- [Navigate (up/down/left/right) via the home row](#super-duper-mode)
- [Navigate to previous/next word via the home row](#super-duper-mode)
- [Arrange windows via the home row](#window-layout-mode)
- [Enable other commonly-used actions on or near the home row](#miscellaneous-goodness)
- [Format text as Markdown](#markdown-mode)
- [Launch commonly-used apps via global keyboard shortcuts](#hyper-key-for-quickly-launching-apps)
- [And more...](#miscellaneous-goodness)

### A more useful caps lock key

By repurposing the anachronistic **caps lock** key, we can make **control** and **escape** accessible via the home row.

- Tap **caps lock** for **escape**
- Hold **caps lock** for **control**

📣 Shout-out to [@arbelt](https://github.com/arbelt) and [@jasoncodes](https://github.com/jasoncodes) for [the implementation](https://github.com/jasonrudolph/keyboard/commit/01a7a5bd8a1e521756d1ec34769119ead5eee0b3). ⚡️🍻🌟

### (S)uper (D)uper Mode

To activate, push the **s** and **d** keys simultaneously and hold them down. Now you're in (S)uper (D)uper Mode. It's like a secret keyboard _inside_ your keyboard. (Whoa.) It's optimized for keeping you on the home row, or very close to it. Now you can:

- Use **h**/**j**/**k**/**l** for **left**/**down**/**up**/**right** respectively
- Use **a** for **option** (AKA **alt**)
- Use **f** for **command**
- Use **space** for **shift**
- Use **a** + **j**/**k** for **page down**/**page up**
- Use **i**/**o** to move to the previous/next tab
- Use **u**/**p** to go to the first/last tab (in most apps)
- Use **a** + **h**/**l** to move to previous/next word (in most apps)

[<img width="400" alt="(S)uper (D)uper Mode Keybindings" src="https://cloud.githubusercontent.com/assets/2988/22397420/f2b3e346-e53e-11e6-97bb-9db71f86994b.png">](https://cloud.githubusercontent.com/assets/2988/22397420/f2b3e346-e53e-11e6-97bb-9db71f86994b.png)

📣 Shout-out to [Karabiner's Simultaneous vi Mode](https://github.com/tekezo/Karabiner/blob/05ca98733f3e3501e0679814c3795d1cb57e177f/src/core/server/Resources/include/checkbox/simultaneouskeypresses_vi_mode.xml#L4-L10) for providing the inspiration for (S)uper (D)uper Mode. ⌨:neckbeard:✨

### Window Layout Mode

Quickly arrange and resize windows in common configurations, using keyboard shortcuts that are on or near the home row.

Use **control** + **s** to turn on Window Layout Mode. Then, use any shortcut below to make windows do your bidding. For example, to send the window left, hit **control** + **s**, and then hit **h**.

- Use **h** to send window left (left half of screen)
- Use **j** to send window down (bottom half of screen)
- Use **k** to send window up (top half of screen)
- Use **l** to send window right (right half of screen)
- Use **i** to send window to upper left quarter of screen
- Use **o** to send window to upper right quarter of screen
- Use **,** to send window to lower left quarter of screen
- Use **.** to send window to lower right quarter of screen
- Use **space** to send window to center of screen
- Use **enter** to resize window to fill the screen
- Use **n** to send window to next monitor
- Use **control** + **s** to exit Window Layout Mode without moving any windows

[<img src="https://cloud.githubusercontent.com/assets/2988/22397114/715cc12e-e538-11e6-9dcd-b3447af0d9dd.png" alt="Window Layout Mode Keybindings (1)" width="400"/>](https://cloud.githubusercontent.com/assets/2988/22397114/715cc12e-e538-11e6-9dcd-b3447af0d9dd.png) [<img src="https://cloud.githubusercontent.com/assets/2988/22397111/45672fe6-e538-11e6-905d-5b0234e290bb.png" alt="Window Layout Mode Keybindings (2)" width="400"/>](https://cloud.githubusercontent.com/assets/2988/22397111/45672fe6-e538-11e6-905d-5b0234e290bb.png)

### Markdown Mode

Perform common [Markdown](https://daringfireball.net/projects/markdown/syntax)-formatting tasks anywhere that you're editing text (e.g., in a GitHub comment, in your editor, in your email client).

Use **control** + **m** to turn on Markdown Mode. Then, use any shortcut below to perform an action. For example, to format the selected text as bold in Markdown, hit **control** + **m**, and then **b**.

- Use **b** to wrap the currently-selected text in double asterisks ("B" for "Bold")

    Example: `**selection**`

- Use **c** to wrap the currently-selected text in backticks ("C" for "Code")

    Example: `` `selection` ``

- Use **i** to wrap the currently-selected text in single asterisks ("I" for "Italic")

    Example: `*selection*`

- Use **s** to wrap the currently-selected text in double tildes ("S" for "Strikethrough")

    Example: `~~selection~~`

- Use **l** to convert the currently-selected text to an inline link, using a URL from the clipboard ("L" for "Link")

    Example: `[selection](clipboard)`

- Use **control** + **m** to exit Markdown Mode without performing any actions

### Hyper key for quickly launching apps

macOS doesn't have a native **hyper** key. But thanks to Karabiner-Elements, we can [create our own](karabiner/karabiner.json).

In this setup, we'll use the **right option** key as our **hyper** key. With a new modifier key defined, we open a whole world of possibilities. I find it especially useful for providing global shortcuts for launching apps:

- **hyper** + **a** to open iTunes ("A" for "Apple Music")
- **hyper** + **b** to open Google Chrome ("B" for "Browser")
- **hyper** + **c** to open [Hackable Slack Client](https://github.com/bhuga/hackable-slack-client) ("C for "Chat")
- **hyper** + **d** to open [Remember The Milk](https://www.rememberthemilk.com/) ("D" for "Do!" ... or "Done!")
- **hyper** + **e** to open [Atom Beta](https://atom.io/beta) ("E" for "Editor")
- **hyper** + **f** to open Finder ("F" for "Finder")
- **hyper** + **g** to open [Mailplane](http://mailplaneapp.com/) ("G" for "Gmail")
- **hyper** + **s** to open [Slack](https://slack.com/downloads/osx) ("S" for "Slack")
- **hyper** + **t** to open [iTerm2](https://www.iterm2.com/) ("T" for "Terminal")

Edit [`hammerspoon/hyper.lua`](hammerspoon/hyper.lua) to configure shortcuts to launch your most commonly-used apps.

### Miscellaneous goodness

- Use **control** + **u** to delete to the start of the line
- Use **control** + **;** to delete to the end of the line
- Use **option** + **h**/**l** to delete the previous/next word
- Hold **option** for push-to-talk/push-to-mute
- Double-tap **option** to mute/unmute microphone

## Dependencies

This setup is honed and tested with the following dependencies.

- macOS Sierra, 10.12
- [Karabiner-Elements 0.90.88][karabiner]
- [Hammerspoon 0.9.52][hammerspoon]

## Installation

1. Grab the bits

    ```sh
    git clone https://github.com/jasonrudolph/keyboard.git ~/.keyboard

    cd ~/.keyboard

    script/setup
    ```

2. Enable accessibility to allow Hammerspoon to do its thing 

[karabiner]: https://github.com/tekezo/Karabiner-Elements
[hammerspoon]: http://www.hammerspoon.org
[hammerspoon-releases]: https://github.com/Hammerspoon/hammerspoon/releases
