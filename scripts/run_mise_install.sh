#!/bin/bash

set -e

# Source utility functions
source scripts/utils.sh

# Check if command exists
print_step "Checking for Mise..."
if ! command -v mise >/dev/null 2>&1; then
  print_warn "Mise not installed, skipping tool install."
  exit 0
fi

# Run mise install
print_step "Running mise install..."
mise -C "$HOME" install

print_success "Mise install completed successfully."
