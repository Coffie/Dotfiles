# Keybindings Reference

This file documents the keybindings for various tools in the dotfiles configuration.
It is structured as Markdown tables to allow for easy parsing by scripts.

## Aerospace (Window Manager)

**Hyper Key Layer:** Hold `Left Control` to activate the Hyper Key layer.
Under the hood, this maps to `Cmd`+`Alt`+`Ctrl`.

| Key Combination | Action | Command |
| :--- | :--- | :--- |
| `LeftCtrl`+`h` | Focus window to the left | `focus left` |
| `LeftCtrl`+`j` | Focus window down | `focus down` |
| `LeftCtrl`+`k` | Focus window up | `focus up` |
| `LeftCtrl`+`l` | Focus window to the right | `focus right` |
| `LeftCtrl`+`Shift`+`h` | Move window to the left | `move left` |
| `LeftCtrl`+`Shift`+`j` | Move window down | `move down` |
| `LeftCtrl`+`Shift`+`k` | Move window up | `move up` |
| `LeftCtrl`+`Shift`+`l` | Move window to the right | `move right` |
| `LeftCtrl`+`1`..`9` | Switch to workspace 1..9 | `workspace N` |
| `LeftCtrl`+`Shift`+`1`..`9` | Move window to workspace 1..9 | `move-node-to-workspace N` |
| `LeftCtrl`+`Enter` | Open Terminal (WezTerm) | `exec-and-forget ...` |
| `LeftCtrl`+`Shift`+`Enter` | Open Browser | `exec-and-forget ...` |
| `LeftCtrl`+`Tab` | Toggle previous/current workspace | `workspace-back-and-forth` |
| `LeftCtrl`+`Shift`+`Tab` | Move Workspace to Monitor | `move-workspace-to-monitor ...` |
| `LeftCtrl`+`Shift`+`f` | Toggle Fullscreen | `fullscreen` |
| `LeftCtrl`+`Shift`+`;` | Enter Service Mode | `mode service` |
| `LeftCtrl`+`/` | Layout: Tiles | `layout tiles ...` |
| `LeftCtrl`+`,` | Layout: Accordion | `layout accordion ...` |

## Tmux (Terminal Multiplexer)

Prefix Key: `Ctrl`+`a` (Works via `Caps`+`a` or `RightCtrl`+`a`)

| Key Combination | Action | Description |
| :--- | :--- | :--- |
| `Prefix`+`|` | Split horizontal | Split current pane horizontally |
| `Prefix`+`-` | Split vertical | Split current pane vertically |
| `Prefix`+`\` | Full split horizontal | Split full window width horizontally |
| `Prefix`+`_` | Full split vertical | Split full window height vertically |
| `Prefix`+`h`/`j`/`k`/`l` | Navigate Panes | Move focus to pane (vim-tmux-navigator) |
| `Prefix`+`C-k` | Prev Window | Select previous window |
| `Prefix`+`C-j` | Next Window | Select next window |
| `Prefix`+`Tab` | Last Window | Toggle to previously selected window |
| `Prefix`+`>` | Swap Next | Swap current pane with next |
| `Prefix`+`<` | Swap Prev | Swap current pane with previous |
| `Prefix`+`H`/`J`/`K`/`L` | Resize Pane | Resize pane by 5 cells |
| `Prefix`+`Enter` | Copy Mode | Enter copy mode |
| `Prefix`+`C-l` | Clear Screen | Send `Ctrl`+`l` to shell |
| `Prefix`+`C-k` | Kill Line | Send `Ctrl`+`k` to shell |
| `Prefix`+`r` | Reload Config | Reload `tmux.conf` |
| `Prefix`+`m` | Toggle Mouse | Toggle mouse support on/off |
| `Prefix`+`c` | New Window | Create a new window (Default) |
| `Prefix`+`w` | Choose Window | Interactive window chooser (Default) |
| `Prefix`+`x` | Kill Pane | Close current pane (Default) |
| `Prefix`+`d` | Detach | Detach from session (Default) |
| `Prefix`+`z` | Zoom Pane | Toggle zoom on current pane (Default) |

## Zsh (Shell - Emacs Mode)

| Key Combination | Action | Description |
| :--- | :--- | :--- |
| `Ctrl`+`a` | Move to start | Go to the beginning of the line |
| `Ctrl`+`e` | Move to end | Go to the end of the line |
| `Ctrl`+`f` | Move forward | Move cursor forward one character |
| `Ctrl`+`b` | Move backward | Move cursor backward one character |
| `Alt`+`f` | Move word forward | Move cursor forward one word |
| `Alt`+`b` | Move word backward | Move cursor backward one word |
| `Ctrl`+`u` | Kill line | Cut the entire line (or to start) |
| `Ctrl`+`k` | Kill to end | Cut from cursor to end of line |
| `Ctrl`+`w` | Kill word backward | Cut word before cursor |
| `Alt`+`d` | Kill word forward | Cut word after cursor |
| `Ctrl`+`y` | Yank | Paste the last cut text |
| `Ctrl`+`r` | History search | Search backward through history |
| `Ctrl`+`l` | Clear screen | Clear terminal screen |
| `Ctrl`+`_` | Undo | Undo the last editing command |
| `Alt`+`k` | Kill to end | Alternative to `Ctrl`+`k` |
| `Alt`+`l` | Clear screen | Alternative to `Ctrl`+`l` |

## Neovim (LazyVim Base)

| Key Combination | Action | Context |
| :--- | :--- | :--- |
| `<Space>` | Leader Key | General |
| `<Space> e` | File Explorer | Toggle NeoTree |
| `<Space> ff` | Find Files | Telescope find files |
| `<Space> sg` | Search Grep | Telescope live grep |
| `<Space> /` | Search in buffer | Fuzzy search current buffer |
| `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` | Window Nav | Move between splits |
