#!/bin/bash

set -e

# Source utility functions
source scripts/utils.sh

print_log "Installing Mac App Store apps..."
apps_ids=(
  1365531024 # 1Blocker
  1569813296 # 1Password for Safari
  1462114288 # Grammarly for Safari
  1474276998 # HP
  409183694 # Keynote
  409203825 # Numbers
  409201541 # Pages
  1289583905 # Pixelmator Pro
  1549370672 # Save to Raindrop.io
  442168834 # SiteSucker
  1006087419 # SnippetsLab
  747648890 # Telegram
  425424353 # The Unarchiver
  310633997 # WhatsApp
  1451685025 # WireGuard
)
apps_names=(
  "1Blocker"
  "1Password for Safari"
  "Grammarly for Safari"
  "HP"
  "Keynote"
  "Numbers"
  "Pages"
  "Pixelmator Pro"
  "Save to Raindrop.io"
  "SiteSucker"
  "SnippetsLab"
  "Telegram"
  "The Unarchiver"
  "WhatsApp"
  "WireGuard"
)

for i in "${!apps_ids[@]}"; do
  id="${apps_ids[$i]}"
  name="${apps_names[$i]}"
  if mas list | grep -q "^${id}"; then
    print_log "$name app already installed."
  else
    print_log "Installing app $name..."
    mas install "$id"
  fi
done
print_log "Mac App Store apps installation completed."


