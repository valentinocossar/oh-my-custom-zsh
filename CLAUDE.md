# CLAUDE.md

## Repo layout

This file (repo-root `CLAUDE.md`) is project instructions for *this* repo only. The global Claude Code config lives in `includes/claude/` (`CLAUDE.md`, `settings.json`) and is symlinked into `~/.claude/` by `scripts/setup_symlinks.sh`. Do not confuse the two.

## Package management

Two managers, split by how versions are handled:

- **Homebrew**, declared in `includes/homebrew/Brewfile`. Use for tools where tracking the latest rolling release is fine: CLI utilities, GUI apps (casks), Mac App Store apps, and build/library dependencies. Do not pin versions here.
- **Mise-en-place**, declared in `includes/mise/mise.toml`. Use for language runtimes and tooling that may need a specific version per project (node, python, go, php, opentofu, ansible, ...), even when the current pin is loose. Set an exact version when a project requires it; `latest` is fine otherwise (e.g. `uv`).

When a tool is present in both (e.g. `php`), Homebrew covers the keg-only build/library side and Mise-en-place provides the runtime version that is active on `PATH` for development (`mise activate` runs after `brew shellenv` in `.zshrc`).

## Shell scripts

Variable naming: lowercase with underscores for locals (`config_file`, `reply`). UPPER_SNAKE_CASE only for exported environment variables and file-level constants set once (`C_RESET`, `HOMEBREW_NO_AUTO_UPDATE`). Prefer `local` inside functions.

Environment variables and `PATH` entries belong in `.zprofile`, not `.zshrc`. Deliberate exceptions exist (a variable scoped to a single tool and kept beside its setup, an Oh My Zsh template default). Leave them where they are and flag it for discussion rather than relocating them on sight.

A script that depends on a tool the Brewfile step would have installed must guard on it and degrade to a `print_warn` plus `exit 0`, since that step is disabled here.
