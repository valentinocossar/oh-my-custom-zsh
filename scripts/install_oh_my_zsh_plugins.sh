#!/bin/bash

set -e

# Source utility functions
source scripts/utils.sh

# Define Oh My Zsh plugins (format: "<name> <repository url>")
plugins=(
  "vscode https://github.com/valentinocossar/vscode"
  "zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions"
  "zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting"
)

# Install Oh My Zsh plugins
print_step "Installing Oh My Zsh plugins..."
for entry in "${plugins[@]}"; do
  name="${entry%% *}"
  url="${entry##* }"

  if [ -d "$HOME/.oh-my-custom-zsh/plugins/$name" ]; then
    print_log "Plugin $name already installed."
  else
    git clone "$url" "$HOME/.oh-my-custom-zsh/plugins/$name"
    print_log "Plugin $name installed."
  fi
done
print_success "Oh My Zsh plugins installed."
