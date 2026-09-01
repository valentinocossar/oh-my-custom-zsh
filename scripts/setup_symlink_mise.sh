#!/bin/bash

set -e

# Source utility functions
source scripts/utils.sh

# Add Homebrew to PATH for this session
eval "$(/opt/homebrew/bin/brew shellenv)"

# Check if commands exist
print_step "Checking for Mise..."
if ! command -v mise >/dev/null 2>&1; then
  print_warn "Mise not installed, skipping PHP links."
  exit 0
fi
print_step "Checking for Homebrew..."
if ! command -v brew >/dev/null 2>&1; then
  print_warn "Homebrew not installed, skipping PHP links."
  exit 0
fi

# Unlink default PHP from Homebrew
print_step "Unlinking default PHP from Homebrew..."
if brew list --formula php >/dev/null 2>&1; then
  brew unlink php
fi

# Create mise symlinks for installed PHP versions
print_log "Setup mise PHP symlinks..."
if brew list --formula php >/dev/null 2>&1; then
  latest=$(brew list --versions php | awk '{print $2}' | cut -d. -f1,2)
  mise link --force "php@$latest" "$(brew --prefix php)"
fi
for keg in $(brew list --formula | grep -E '^php@[0-9]+\.[0-9]+$' || true); do
  mise link --force "$keg" "$(brew --prefix "$keg")"
done

print_success "Mise PHP symlinks setup completed successfully."
