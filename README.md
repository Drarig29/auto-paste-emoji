# auto-paste-emoji

A script which automatically pastes an emoji if you just selected it from KDE Plasma's emoji picker.

You can tweak it to meet your needs.

Dependencies:

- [xdotool](https://www.semicomplete.com/projects/xdotool/)
- [clipnotify](https://github.com/cdown/clipnotify)
- [is-emoji](https://github.com/Drarig29/is-emoji)

## Usage

Download this script or clone the repository.

Then, symlink it somewhere like `/usr/bin/auto-paste-emoji`:

```bash
ln -s ~/path/to/auto-paste-emoji.sh /usr/bin/auto-paste-emoji
```

To run this script at startup, you need to put it somewhere [which is loaded after X server starts](https://unix.stackexchange.com/questions/360537/cant-run-application-that-depends-on-x-as-a-systemd-service), so forget systemd.
Otherwise you'll get a `Unable to connect to X server` error.

You can use files like `.xinitrc`, `.xsession` or `.xprofile`. Keep in mind that by default, `.xinitrc` is only loaded when we use the `startx` command.
So this file won't be loaded if you use a desktop environment.

**Warning:** this file contains an infinite loop, so you need to run the command in the background with `&`, otherwise your desktop environment is likely to freeze when you log in.

I personally used `~/.xprofile`, here is its content:

```bash
#!/bin/bash
exec /usr/bin/auto-paste-emoji &
```

## How it works?

- It uses [clipnotify](https://github.com/cdown/clipnotify), so no polling is involved
- Any existing instance of the script is killed
- All errors are ignored so that the program doesn't stop unexpectedly
- When the selection changes, it checks if the emoji picker is open and a single emoji is in the clipboard
- If it's the case, we assume the emoji was just selected: so the picker is closed and the emoji is pasted
- A small delay is added between closing the picker and pasting the emoji to let the emoji picker's window disappear and let the focus change
- To close the window we don't use `xdotool windowclose` but we simulate pressing <kbd>Esc</kbd><kbd>Esc</kbd> instead
  - For some reason, closing the window kills the whole process and the shortcut to open the picker won't respond afterwards
  - We simulate pressing <kbd>Esc</kbd> twice because if you used the search feature in the picker, pressing <kbd>Esc</kbd> will clear the search string, so we need a second key stroke

You can view the logs using `journalctl`: 

```bash
journalctl -b | grep -E "\[$(pidof -x /usr/bin/auto-paste-emoji)\]"
```
