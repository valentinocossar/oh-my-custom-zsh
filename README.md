# Oh My Custom Zsh

Personal dotfiles, a custom Oh My Zsh folder, and other utilities.

**DISCLAIMER:** this repo is specific for my personal workflow and configuration. Don't use it as is, fork and customize if you like it.

## Getting Started

### Prerequisites

- Ensure your GitHub account has the same SSH key configured and accessible at `~/.ssh/id_ed25519`.

### Clone repo and run script

To set up the environment automatically, clone this repository and run the setup script:

```bash
git clone git@github.com:valentinocossar/oh-my-custom-zsh.git ~/.oh-my-custom-zsh
cd ~/.oh-my-custom-zsh
./setup.sh
```

Follow the on-screen prompts! `setup.sh` is idempotent and safe to re-run.

## Project Structure

- `setup.sh`: main setup script
- `oh-my-custom-zsh.zsh`: `*.zsh` loader, sources the partials from `includes/zsh/`
- `scripts/`: individual installation and configuration scripts
- `includes/`: configuration files and folders to be symlinked
- `plugins/`: plugins for Oh My Zsh
- `themes/`: themes for Oh My Zsh

## Package management

Two managers, split by how versions are handled: **Homebrew** (`includes/homebrew/Brewfile`) for tools that can track the latest rolling release, **Mise-en-place** (`includes/mise/mise.toml`) for language runtimes and tooling that may need a specific version per project.

### Homebrew

Taps, formulae, casks and Mac App Store apps are declared in `includes/homebrew/Brewfile`. To manage them:

- **Install/sync what's declared**: `brew bundle install --global` (also run automatically by `setup.sh`).
- **Add or remove a package**: install/uninstall it normally with `brew`/`mas`, then regenerate the Brewfile from the current system state: `brew bundle dump --global --force --taps --brews --casks --mas`. Do not hand-edit the ordering of the file, always regenerate it with `--force` so the diff only shows the actual package change.
- **Remove packages no longer declared in the Brewfile**: `brew bundle cleanup --global --taps --brews --casks --mas` performs a dry run only, it lists what would be removed and requires a separate `--force` run to actually remove anything. `setup.sh` runs this dry run automatically at the end and, if it finds anything to remove, asks for interactive `[y/N]` confirmation before re-running it with `--force`.

### Mise-en-place

Runtimes and their versions are declared in `includes/mise/mise.toml` (symlinked and installed by `setup.sh`). Edit the file to add or bump a tool, then run `mise install`.

To bump everything at once, run `mise run bump`, a wrapper for `mise upgrade --bump` that skips `php` (a `mise link` to the Homebrew keg, which must not be rebuilt from source) and `node` (pinned to a major, moved by hand to the next LTS).

## Authors

- [Valentino](https://github.com/valentinocossar)
