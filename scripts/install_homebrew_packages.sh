#!/bin/bash

set -e

# Source utility functions
source scripts/utils.sh

print_log "Installing Homebrew CLI formulae..."
cli_packages=(
  shivammathur/php/php@8.4
  shivammathur/php/php@8.5
  aovestdipaperino/tap/tokensave
  ack
  bat
  btop
  composer
  ctop
  dnsmasq
  fzf
  httpie
  jq
  libpq
  librsvg
  llmfit
  mas
  mise
  mysql-client
  nmap
  oha
  pwgen
  rtk
  testssl
  tlrc
  trash
  tree
  utiluti
  watch
  wget
)
print_log "Trusting required Homebrew taps..."
taps=()
for package in "${cli_packages[@]}"; do
  if [[ "$package" == */* ]]; then
    taps+=("$(echo "$package" | cut -d'/' -f1,2)")
  fi
done
while IFS= read -r tap; do
  if brew trust --json v1 2>/dev/null | grep -q "\"$tap\""; then
    print_log "Tap $tap already trusted, skipping."
  else
    print_log "Trusting tap $tap..."
    brew trust --tap "$tap"
  fi
done < <(printf '%s\n' "${taps[@]}" | sort -u)
print_log "Homebrew taps trusted."

for package in "${cli_packages[@]}"; do
  if brew list --formula | grep -q "^${package}$"; then
    print_log "$package already installed, skipping."
  else
    print_log "Installing $package..."
    brew install "$package"
  fi
done
print_log "Homebrew CLI formulae installed."
