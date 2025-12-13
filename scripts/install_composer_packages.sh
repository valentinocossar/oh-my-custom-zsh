#!/bin/bash

set -e

# Source utility functions
source scripts/utils.sh

# Install Composer global packages
print_log "Installing Composer global packages..."
packages=("laravel/installer")
for pkg in "${packages[@]}"; do
  if composer global show "$pkg" > /dev/null 2>&1; then
    print_log "$pkg already installed globally, skipping."
  else
    composer global require "$pkg"
  fi
done
print_log "Composer global packages installed."
