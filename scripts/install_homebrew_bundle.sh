#!/bin/bash

set -e

# Source utility functions
source scripts/utils.sh

# Add Homebrew to PATH for this session
eval "$(/opt/homebrew/bin/brew shellenv)"

# Define Brewfile location
BREWFILE="$HOME/.config/homebrew/Brewfile"

# Check if command exists
print_step "Checking for Homebrew..."
if ! command -v brew >/dev/null 2>&1; then
  print_warn "Homebrew not installed, skipping Homebrew bundle install and cleanup."
  exit 0
fi

# Check if Brewfile exists
if [ ! -f "$BREWFILE" ]; then
  print_warn "Brewfile not found at $BREWFILE, skipping Homebrew bundle install and cleanup."
  exit 0
fi

# Install Homebrew bundle
print_step "Installing Homebrew bundle (taps, formulae, casks, Mac App Store apps)..."
brew bundle install --file="$BREWFILE"
print_success "Homebrew bundle installed."

# Cleanup Homebrew packages, brew prompts for confirmation itself
print_step "Checking for Homebrew packages not declared in the Brewfile..."
brew bundle cleanup --file="$BREWFILE" --taps --brews --casks --mas || true
