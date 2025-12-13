#!/bin/bash

set -e

# Source utility functions
source scripts/utils.sh

# Install Oh My Zsh plugins
print_log "Installing Oh My Zsh plugins..."
if [ ! -d "$HOME/.oh-my-custom-zsh/plugins/vscode" ]; then
  git clone https://github.com/valentinocossar/vscode "$HOME/.oh-my-custom-zsh/plugins/vscode"
  print_log "Plugin vscode installed."
else
  print_log "Plugin vscode already installed."
fi
if [ ! -d "$HOME/.oh-my-custom-zsh/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.oh-my-custom-zsh/plugins/zsh-autosuggestions"
  print_log "Plugin zsh-autosuggestions installed."
else
  print_log "Plugin zsh-autosuggestions already installed."
fi
if [ ! -d "$HOME/.oh-my-custom-zsh/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "$HOME/.oh-my-custom-zsh/plugins/zsh-syntax-highlighting"
  print_log "Plugin zsh-syntax-highlighting installed."
else
  print_log "Plugin zsh-syntax-highlighting already installed."
fi
print_log "Oh My Zsh plugins installed."
