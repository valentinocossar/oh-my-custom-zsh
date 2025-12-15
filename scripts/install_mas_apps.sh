#!/bin/bash

set -e

# Source utility functions
source scripts/utils.sh

print_log "Installing Mac App Store apps..."
apps_ids=(
  1365531024
  1569813296
  1462114288
  1474276998
  409183694
  409203825
  409201541
  1289583905
  1549370672
  442168834
  1006087419
  747648890
  425424353
  1465707487
  310633997
  1451685025
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
  "Toast"
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


