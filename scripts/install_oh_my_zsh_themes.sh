#!/bin/bash

set -e

# Source utility functions
source scripts/utils.sh

# Define Oh My Zsh themes (format: "<name> <repository url> <theme file>")
themes=(
  "spaceship-prompt https://github.com/spaceship-prompt/spaceship-prompt spaceship.zsh-theme"
)

# Install Oh My Zsh themes
print_step "Installing Oh My Zsh themes..."
for entry in "${themes[@]}"; do
  read -r name url theme_file <<<"$entry"

  # Install Oh My Zsh theme
  print_step "Installing $name theme..."
  if [ -d "$HOME/.oh-my-custom-zsh/themes/$name" ]; then
    print_log "Theme $name already installed."
  else
    git clone "$url" "$HOME/.oh-my-custom-zsh/themes/$name" --depth=1
    print_log "Theme $name installed."
  fi

  # Symlink Oh My Zsh theme
  print_step "Symlinking $name theme..."
  if [ -L "$HOME/.oh-my-custom-zsh/themes/$theme_file" ]; then
    print_log "Theme $name already symlinked."
  else
    ln -sfn "$HOME/.oh-my-custom-zsh/themes/$name/$theme_file" "$HOME/.oh-my-custom-zsh/themes/$theme_file"
    print_log "Theme $name symlinked."
  fi
done
print_success "Oh My Zsh themes installed."
