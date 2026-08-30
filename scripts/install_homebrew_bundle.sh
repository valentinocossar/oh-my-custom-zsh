#!/bin/bash

set -e

# Source utility functions
source scripts/utils.sh

BREWFILE="$HOME/.config/homebrew/Brewfile"

print_step "Installing Homebrew bundle (taps, formulae, casks, Mac App Store apps)..."
brew bundle install --file="$BREWFILE"
print_success "Homebrew bundle installed."

print_step "Checking for packages not declared in the Brewfile..."
if brew bundle cleanup --file="$BREWFILE" --taps --brews --casks --mas; then
  print_log "Nothing to clean up."
else
  read -r -p "Remove the packages listed above? [y/N] " reply
  if [[ "$reply" =~ ^[Yy]$ ]]; then
    brew bundle cleanup --file="$BREWFILE" --taps --brews --casks --mas --force
    print_success "Homebrew bundle cleanup completed."
  else
    print_warn "Homebrew bundle cleanup skipped."
  fi
fi
