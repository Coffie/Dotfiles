# Repository Guidelines

## Project Structure & Module Organization
- `install` orchestrates Dotbot with `install.conf.yaml`; add new links there instead of ad-hoc scripts.
- `dotbot/` is a submodule; leave `dotbot/bin/*` untouched and update through Git only.
- `config/` houses app profiles (`nvim/`, `kitty/`, `wezterm/`, `skhd/`, `yabai/`, etc.); mirror upstream folder names for new tools.
- Shell configs live in `zsh/`, `bash/`, and shared `shell/`; editor and multiplexer settings stay under `vim/`, `tmux/`, and `config/nvim/`.
- `bin/` stores helper scripts such as `DefaultBrowserAcceptScript.scpt`; document platform quirks inline.

## Build, Test, and Development Commands
- `./install` — run Dotbot and refresh all symlinks after any tracked change.
- `./install -v` — verbose pass to inspect planned link operations.
- `git submodule update --init --recursive` — sync the Dotbot pin when the submodule changes.
- `nvim --headless "+Lazy sync" +qa` — align plugins with `lazy-lock.json` after Lua edits.

## Coding Style & Naming Conventions
- Bash/Zsh scripts start with `#!/usr/bin/env bash`, enable `set -e`, use 2-space blocks, and adopt lowercase hyphenated filenames.
- YAML manifests follow the existing 2-space offsets in `install.conf.yaml` and group keys by tool.
- Lua modules in `config/nvim/lua/coffie/` use 4-space indentation, stay within the `coffie` namespace, and prefer descriptive local tables.
- Config filenames mirror the target program (`yabairc`, `skhdrc`, `wezterm.lua`) with brief header comments when diverging from upstream defaults.

## Testing Guidelines
- Run `./install -v` in a temporary directory to confirm Dotbot resolves paths without stray links.
- For Neovim updates, run `nvim --headless "+checkhealth" +qa` and launch once interactively to catch runtime errors.
- Reload Brew-managed services (`brew services restart yabai`, etc.) on a test machine before committing workflow changes.

## Commit & Pull Request Guidelines
- Use short, imperative commit subjects that reference the touched tool (e.g., `update lazy lock and remove dressing`).
- Summaries should mention affected apps; detail notable files or commands in the body only when needed.
- Pull requests explain motivation, list impacted programs, include before/after visuals for UI tweaks, and note manual follow-up steps such as `brew services restart skhd`.

## Security & Configuration Tips
- Avoid committing secrets or machine identifiers; rely on ignored local overrides for sensitive data.
- Call out external dependencies (Google Cloud SDK, fonts, Brew taps) in PRs so reviewers can prepare safely.
