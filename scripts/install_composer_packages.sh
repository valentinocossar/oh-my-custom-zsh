#!/bin/bash

set -e

# Source utility functions
source scripts/utils.sh

# Check if commands exist
print_step "Checking for Mise..."
if ! command -v mise >/dev/null 2>&1; then
  print_warn "Mise not installed, skipping global packages."
  exit 0
fi
print_step "Checking for Composer..."
if ! command -v composer >/dev/null 2>&1; then
  print_warn "Composer not installed, skipping global packages."
  exit 0
fi

# Add Mise to PATH for this session
eval "$(mise activate bash)"

# Install Composer global packages
print_step "Installing Composer global packages..."
packages=("laravel/installer")
for pkg in "${packages[@]}"; do
  if composer global show "$pkg" > /dev/null 2>&1; then
    print_log "$pkg already installed globally, skipping."
  else
    composer global require "$pkg"
  fi
done
print_success "Composer global packages installed."
