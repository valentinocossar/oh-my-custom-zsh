# CLAUDE.md

## Repo layout

This file (repo-root `CLAUDE.md`) is project instructions for *this* repo only. The global Claude Code config lives in `includes/claude/` (`CLAUDE.md`, `settings.json`) and is symlinked into `~/.claude/` by `scripts/setup_symlinks.sh`. Do not confuse the two.

## Package management

Two managers, split by how versions are handled:

- **Homebrew**, declared in `includes/homebrew/Brewfile`. Use for tools where tracking the latest rolling release is fine: CLI utilities, GUI apps (casks), Mac App Store apps, and build/library dependencies. Do not pin versions here.
- **Mise-en-place**, declared in `includes/mise/mise.toml`. Use for language runtimes and tooling that may need a specific version per project (node, python, go, php, opentofu, ansible, ...), even when the current pin is loose. Set an exact version when a project requires it; `latest` is fine otherwise (e.g. `uv`).

When a tool is present in both (e.g. `php`), Homebrew covers the keg-only build/library side and Mise-en-place provides the runtime version that is active on `PATH` for development (`mise activate` in `.zshrc` runs after `brew shellenv` in `.zprofile`).

## Shell scripts

Variable naming: lowercase with underscores for locals (`config_file`, `reply`). UPPER_SNAKE_CASE only for exported environment variables and file-level constants set once (`C_RESET`, `HOMEBREW_NO_AUTO_UPDATE`). Prefer `local` inside functions.

Put a new setting in `.zprofile` if a script would need it too, since that file runs once at login and everything it exports is inherited: environment variables, `PATH`, `brew shellenv`. Put it in `.zshrc` if it only makes sense while typing at the prompt, since that file runs for every interactive shell: theme, completions, aliases, keybindings, and hooks like `mise activate` and `zoxide init`. Oh My Zsh parameters (`ZSH_THEME`, `HIST_STAMPS`) are the exception and stay in `.zshrc`, because `oh-my-zsh.sh` reads them when it is sourced there.

A script that depends on a tool the Brewfile step would have installed must guard on it and degrade to a `print_warn` plus `exit 0`, since that step is disabled here.
