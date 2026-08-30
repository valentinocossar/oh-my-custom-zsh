#!/bin/bash

set -e

# Source utility functions
source scripts/utils.sh

print_step "Installing Claude Code plugins..."

# Third-party marketplaces to register (format: <github-user>/<repo> or URL)
claude_marketplaces=(
  "alirezarezvani/claude-skills"
)

# Plugins to install (format: <plugin>@<marketplace>)
claude_plugins=(
  "grill-me@claude-code-skills"
)

for marketplace in "${claude_marketplaces[@]}"; do
  claude plugin marketplace add "$marketplace"
done

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
