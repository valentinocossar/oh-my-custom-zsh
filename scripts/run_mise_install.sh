#!/bin/bash

set -e

# Source utility functions
source scripts/utils.sh

# Change to home directory
cd "$HOME"

# Run mise install
print_log "Running mise install..."
mise install

# Activate mise for the current shell session
eval "$(mise activate bash)"

print_log "mise install completed successfully."
