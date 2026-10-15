#!/bin/bash

set -e

# Source utility functions
source scripts/utils.sh

# Add Homebrew to PATH for this session
eval "$(/opt/homebrew/bin/brew shellenv)"

print_step "Checking for Lerd..."
if ! command -v brew >/dev/null 2>&1 || ! brew list --formula lerd >/dev/null 2>&1; then
  print_warn "Lerd not installed, skipping tray mono icon watcher."
  exit 0
fi

print_step "Installing Lerd tray mono icon watcher..."
label="local.lerd-mono-watch"
agent_file="$HOME/Library/LaunchAgents/$label.plist"
domain="gui/$(id -u)"

# launchd expands neither ~ nor $HOME, so the agent is generated with absolute paths
mkdir -p "$HOME/Library/LaunchAgents" "$HOME/Library/Logs"
sed "s|__HOME__|$HOME|g" "includes/lerd/$label.plist" > "$agent_file"
plutil -lint "$agent_file" >/dev/null

launchctl bootout "$domain/$label" 2>/dev/null || true
# Bootstrap fails with an I/O error while the old job is still tearing down
for attempt in 1 2 3 4 5; do
  launchctl bootstrap "$domain" "$agent_file" 2>/dev/null && break
  if [[ "$attempt" == 5 ]]; then
    print_error "Could not load agent $label."
    exit 1
  fi
  sleep 1
done
print_log "Agent $label loaded."

if [[ ! -f "$HOME/Library/LaunchAgents/lerd-tray.plist" ]]; then
  print_warn "Lerd autostart is off, run 'lerd autostart enable' for the watcher to take effect."
fi

print_success "Lerd tray mono icon watcher installed."
