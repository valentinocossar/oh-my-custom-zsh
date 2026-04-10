#!/bin/bash

set -e

# Source utility functions
source scripts/utils.sh

# Unlink default PHP from Homebrew
print_log "Unlinking default PHP from Homebrew..."
brew unlink php

# Create mise symlinks for PHP versions
print_log "Setup mise PHP symlinks..."
mise link --force php@8.4 $(brew --prefix php@8.4)
mise link --force php@8.5 $(brew --prefix php@8.5)

# Activate mise for the current shell session
eval "$(mise activate bash)"

print_log "mise symlink setup completed successfully."
