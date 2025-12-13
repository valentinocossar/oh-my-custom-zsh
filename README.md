# Oh My Custom Zsh

Custom Oh My Zsh folder and other utilities.

**DISCLAIMER:** this repo is specific for my personal workflow and configuration. Don't use it as is, fork and customize if you like it.

## Getting Started

### Prerequisites

- Ensure your GitHub account has the same SSH key configured and accessible at `~/.ssh/id_ed25519`.

### Clone repo and run script

To set up the environment automatically, clone this repository and run the bootstrap script:

```bash
git clone git@github.com:valentinocossar/oh-my-custom-zsh.git ~/.oh-my-custom-zsh
cd ~/.oh-my-custom-zsh
./bootstrap.sh
```

Follow the on-screen prompts!

## Project Structure

- `bootstrap.sh`: Main bootstrap script
- `scripts/`: Individual installation and configuration scripts
- `includes/`: Configuration files and folders to be symlinked
- `plugins/`: Oh My Zsh plugins
- `themes/`: Oh My Zsh themes

## Authors

- [Valentino](https://github.com/valentinocossar)
