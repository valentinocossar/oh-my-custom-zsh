#!/bin/bash

set -e

# Source utility functions
source scripts/utils.sh

print_step "Checking for Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  print_log "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
  print_success "Oh My Zsh installed."
else
  print_log "Oh My Zsh already installed."
fi
