#!/bin/bash

set -e

# Source utility functions
source scripts/utils.sh

# Check if command exists
print_step "Checking for Homebrew..."
if command -v brew >/dev/null 2>&1; then
  print_log "Homebrew already installed."
  exit 0
fi

# Installing Homebrew
print_log "Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
print_success "Homebrew installed."
