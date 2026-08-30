#!/bin/bash

set -e

# Source utility functions
source scripts/utils.sh

print_step "Setup symlinks..."

# Create .zshrc symbolic link
print_log "Creating symbolic links for .zshrc..."
rm -f "$HOME/.zshrc"
ln -sf "$HOME/.oh-my-custom-zsh/includes/zsh/.zshrc" "$HOME/.zshrc"

# Create .zprofile symbolic link
print_log "Creating symbolic links for .zprofile..."
rm -f "$HOME/.zprofile"
ln -sf "$HOME/.oh-my-custom-zsh/includes/zsh/.zprofile" "$HOME/.zprofile"

# Create homebrew/Brewfile symbolic link
print_log "Creating symbolic link for Brewfile..."
mkdir -p "$HOME/.config/homebrew"
rm -f "$HOME/.config/homebrew/Brewfile"
ln -sf "$HOME/.oh-my-custom-zsh/includes/homebrew/Brewfile" "$HOME/.config/homebrew/Brewfile"

# Create .gitconfig symbolic link
print_log "Creating symbolic link for .gitconfig..."
rm -f "$HOME/.gitconfig"
ln -sf "$HOME/.oh-my-custom-zsh/includes/git/.gitconfig" "$HOME/.gitconfig"

# Create .gitignore_global symbolic link
print_log "Creating symbolic link for .gitignore_global..."
rm -f "$HOME/.gitignore_global"
ln -sf "$HOME/.oh-my-custom-zsh/includes/git/.gitignore_global" "$HOME/.gitignore_global"

# Create .vimrc symbolic link
print_log "Creating symbolic link for .vimrc..."
rm -f "$HOME/.vimrc"
ln -sf "$HOME/.oh-my-custom-zsh/includes/vim/.vimrc" "$HOME/.vimrc"

# Create .spaceshiprc.zsh symbolic link
print_log "Creating symbolic link for .spaceshiprc.zsh..."
rm -f "$HOME/.spaceshiprc.zsh"
ln -sf "$HOME/.oh-my-custom-zsh/includes/spaceship/.spaceshiprc.zsh" "$HOME/.spaceshiprc.zsh"

# Create mise/config.toml symbolic link
print_log "Creating symbolic link for mise/config.toml..."
mkdir -p "$HOME/.config/mise"
rm -f "$HOME/.config/mise/config.toml"
ln -sf "$HOME/.oh-my-custom-zsh/includes/mise/mise.toml" "$HOME/.config/mise/config.toml"

#  Create .default-npm-packages symbolic link
print_log "Creating symbolic link for .default-npm-packages..."
rm -f "$HOME/.default-npm-packages"
ln -sf $HOME/.oh-my-custom-zsh/includes/node/.default-npm-packages $HOME/.default-npm-packages

# Create direnv/direnv.toml symbolic link
print_log "Creating symbolic link for direnv/direnv.toml..."
mkdir -p "$HOME/.config/direnv"
rm -f "$HOME/.config/direnv/direnv.toml"
ln -sf "$HOME/.oh-my-custom-zsh/includes/direnv/direnv.toml" "$HOME/.config/direnv/direnv.toml"

# Create ccstatusline/settings.json symbolic link
print_log "Creating symbolic link for ccstatusline/settings.json..."
mkdir -p "$HOME/.config/ccstatusline"
rm -f "$HOME/.config/ccstatusline/settings.json"
ln -sf "$HOME/.oh-my-custom-zsh/includes/ccstatusline/settings.json" "$HOME/.config/ccstatusline/settings.json"

# Create Claude config symbolic links
# RTK.md is intentionally excluded — it is managed by the rtk tool itself and
# only referenced from CLAUDE.md via `@RTK.md`.
print_log "Creating symbolic links for Claude config..."
mkdir -p "$HOME/.claude"
for f in CLAUDE.md settings.json; do
  rm -f "$HOME/.claude/$f"
  ln -sf "$HOME/.oh-my-custom-zsh/includes/claude/$f" "$HOME/.claude/$f"
done

print_success "Symlinks created."
