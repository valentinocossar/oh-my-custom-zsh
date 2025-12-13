#!/bin/bash

set -e

# Source utility functions
source scripts/utils.sh

# Install Oh My Zsh themes
print_log "Installing Oh My Zsh themes..."
if [ ! -d "$HOME/.oh-my-custom-zsh/themes/spaceship-prompt" ]; then
  git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$HOME/.oh-my-custom-zsh/themes/spaceship-prompt" --depth=1
  ln -s "$HOME/.oh-my-custom-zsh/themes/spaceship-prompt/spaceship.zsh-theme" "$HOME/.oh-my-custom-zsh/themes/spaceship.zsh-theme"
  print_log "Theme spaceship-prompt plugin installed."
else
  print_log "Theme spaceship-prompt plugin already installed."
fi
print_log "Oh My Zsh themes installed."
