#!/bin/bash

set -e

# Source utility functions
source scripts/utils.sh

print_log "Setup symlinks..."

# Create .zshrc symbolic link
print_log "Creating symbolic links for .zshrc..."
rm -f "$HOME/.zshrc"
ln -sf "$HOME/.oh-my-custom-zsh/includes/zfiles/.zshrc" "$HOME/.zshrc"

# Create .zprofile symbolic link
print_log "Creating symbolic links for .zprofile..."
rm -f "$HOME/.zprofile"
ln -sf "$HOME/.oh-my-custom-zsh/includes/zfiles/.zprofile" "$HOME/.zprofile"

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
ln -sf $HOME/.oh-my-custom-zsh/node/.default-npm-packages $HOME/.default-npm-packages
