#!/bin/bash

set -e

# Source utility functions
source scripts/utils.sh

print_log "Installing Homebrew CLI formulae..."
cli_packages=(
  ack
  ansible
  bat
  btop
  composer
  ctop
  dnsmasq
  duti
  fnm
  fzf
  go
  httpie
  jq
  libpq
  librsvg
  mas
  mysql-client
  nmap
  oha
  opentofu
  php@8.5
  poetry
  pwgen
  pyenv
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
