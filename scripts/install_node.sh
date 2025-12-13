#!/bin/bash

set -e

# Source utility functions
source scripts/utils.sh

print_log "Installing latest LTS Node.js via fnm..."
eval "$(fnm env)"
fnm install --lts
fnm default lts-latest
fnm use lts-latest
print_log "Node.js LTS installed and set as default."
