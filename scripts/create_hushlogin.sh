#!/bin/bash

set -e

# Source utility functions
source scripts/utils.sh

print_log "Creating .hushlogin..."
touch "$HOME/.hushlogin"
print_log ".hushlogin created."
