#!/bin/bash

set -e

# Source utility functions
source scripts/utils.sh

# Function to check if command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

print_log "Checking for Homebrew..."
if ! command_exists brew; then
  print_log "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Add Homebrew to PATH for this session
  eval "$(/opt/homebrew/bin/brew shellenv)"
  print_log "Homebrew installed."
else
  print_log "Homebrew already installed."
fi
