# Coffie Dotfiles

Opinionated macOS dotfiles managed with [Dotbot](https://github.com/anishathalye/dotbot). Running the bundled installer safely symlinks each configuration file into `$HOME`, keeping this repository as the single source of truth for apps, shells, and window management tooling.

## Prerequisites
- macOS with [Homebrew](https://brew.sh); run `brew bundle --file mac/brews.txt` to install the baseline toolchain (kitty, wezterm, yabai, skhd, sketchybar, etc.).
- Fonts with Nerd glyphs (e.g. `font-inconsolata-nerd-font`) for terminal, Neovim, and bar icons.
- Optional: Google Cloud SDK if you want the paths sourced in `shell/exports.sh`.

## Quick Start
```bash
git clone https://github.com/coffie/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
git submodule update --init --recursive
./install            # apply symlinks via Dotbot
```

Rerun `./install` anytime you change a tracked config. Use `./install -v` to preview the operations without writing.

## Repository Layout
- `install` & `install.conf.yaml` – orchestrate Dotbot and declare every link created under `$HOME`.
- `config/` – application configs: Neovim (`config/nvim` with Lazy-managed plugins), kitty, wezterm, yabai, skhd, aerospace, sketchybar, spotifyd, git, htop, and more.
- `zsh/`, `bash/`, `shell/` – shared shell options, aliases, exports, and the unified loader in `shell/init.sh` (with powerlevel10k prompt support in `p10k.zsh`).
- `tmux/` – tmux configuration plus the TPM plugin manager as a submodule.
- `vim/` & `vimrc` – legacy Vim setup kept alongside the Neovim layout.
- `mac/` – bootstrap helpers (`mac.sh`, `brews.sh`, `brews.txt`) for new machines.
- `bin/` – user scripts and utilities that are linked into `~/bin`.

## Everyday Tasks
- `nvim --headless "+Lazy sync" +qa` keeps Neovim plugins aligned with `config/nvim/lazy-lock.json` after editing Lua modules.
- `tmux/plugins/tpm/bin/update_plugins` refreshes tmux plugins declared in `tmux.conf`.
- `brew services restart yabai && brew services restart skhd` applies window manager keybind changes; do the same for `sketchybar` when adjusting the menubar.
- `./install -v` in a scratch directory confirms new Dotbot rules before applying them to your real home folder.

## Customising & Contributing
- Follow the conventions in `AGENTS.md` for naming, formatting, and pull-request etiquette.
- Add new applications under `config/<tool>` and extend `install.conf.yaml` instead of creating manual symlink scripts.
- Document any manual post-install steps (fonts, licenses, API tokens) inside the relevant config file header or in a short note within your commit message.

## Troubleshooting
- If `./install` fails, rerun with `-v` to inspect the offending path.
- Homebrew services sometimes need a full restart (`brew services stop yabai && brew services start yabai`) after config changes.
- Shell startup errors referencing Google Cloud SDK disappear once the optional SDK is installed or the sourcing lines are commented out.
