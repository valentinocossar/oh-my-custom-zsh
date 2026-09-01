#!/bin/bash

set -e

# Source utility functions
source scripts/utils.sh

# Check if command exists
print_step "Checking for Claude..."
if ! command -v claude >/dev/null 2>&1; then
  print_warn "Claude not installed, skipping plugins."
  exit 0
fi

print_step "Installing Claude Code plugins..."

# Third-party marketplaces to register (format: <github-user>/<repo> or URL)
claude_marketplaces=(
  "alirezarezvani/claude-skills"
)

# Plugins to install (format: <plugin>@<marketplace>)
claude_plugins=(
  "grill-me@claude-code-skills"
)

# Add marketplaces
for marketplace in "${claude_marketplaces[@]}"; do
  claude plugin marketplace add "$marketplace" >/dev/null 2>&1 || print_log "Marketplace $marketplace already registered."
done

# Install plugins
for plugin in "${claude_plugins[@]}"; do
  name="${plugin%@*}"
  if claude plugin list 2>/dev/null | grep -q "$name"; then
    print_log "Plugin $name already installed, skipping."
  else
    claude plugin install -y "$plugin"
    print_log "Plugin $name installed."
  fi
done

print_success "Claude Code plugins installed."
