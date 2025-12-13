#!/bin/bash

set -e

# Source utility functions
source scripts/utils.sh

# Install NPM global packages
print_log "Installing NPM global packages..."
eval "$(fnm env)"
packages=("prettier")
for pkg in "${packages[@]}"; do
  if npm list -g "$pkg" > /dev/null 2>&1; then
    print_log "$pkg already installed globally, skipping."
  else
    npm install -g "$pkg"
  fi
done
print_log "NPM global packages installed."
