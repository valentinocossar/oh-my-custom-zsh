#!/bin/bash

set -e

# Source utility functions
source scripts/utils.sh

print_log "Installing Homebrew Cask formulae..."
cask_packages=(
  1password
  1password-cli
  alt-tab
  bruno
  claude
  claude-code@latest
  docker
  firefox
  iterm2
  lm-studio
  music-decoy
  pdf-squeezer
  pearcleaner
  protonvpn
  raycast
  rectangle
  shottr
  signal
  spotify
  tableplus
  thaw
  transmit
  visual-studio-code
  viz
)
for package in "${cask_packages[@]}"; do
  if brew list --cask | grep -q "^${package}$"; then
    print_log "$package already installed, skipping."
  else
    print_log "Installing $package..."
    brew install --cask "$package"
  fi
done
print_log "Homebrew Cask formulae installed."
