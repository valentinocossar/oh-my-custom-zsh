#!/bin/bash

set -e

# Source utility functions
source scripts/utils.sh

print_log "Checking for Command Line Tools..."
if ! xcode-select -p >/dev/null 2>&1; then
  print_log "Installing Command Line Tools..."
  xcode-select --install
  print_log "Command Line Tools installation initiated. Please complete the installation and press Enter to continue."
  read -r
else
  print_log "Command Line Tools already installed."
fi
