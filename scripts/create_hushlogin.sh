#!/bin/bash

set -e

# Source utility functions
source scripts/utils.sh

print_step "Creating .hushlogin..."
touch "$HOME/.hushlogin"
print_success "File .hushlogin created."
