#!/bin/bash

set -e

# Source utility functions
source scripts/utils.sh

print_log "Installing Homebrew CLI formulae..."
cli_packages=(
  shivammathur/php/php@8.4
  shivammathur/php/php@8.5
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
  testssl
  tlrc
  trash
  tree
  watch
  wget
)
for package in "${cli_packages[@]}"; do
  if brew list --formula | grep -q "^${package}$"; then
    print_log "$package already installed, skipping."
  else
    print_log "Installing $package..."
    brew install "$package"
  fi
done
print_log "Homebrew CLI formulae installed."
