#!/bin/bash

set -e

# Source utility functions
source scripts/utils.sh

# Add Homebrew to PATH for this session
eval "$(/opt/homebrew/bin/brew shellenv)"

# Check if command exists
print_step "Checking for Homebrew..."
if ! command -v brew >/dev/null 2>&1; then
  print_warn "Homebrew not installed, skipping dnsmasq configuration."
  exit 0
fi

# Check if formula is installed
if ! brew list --formula dnsmasq >/dev/null 2>&1; then
  print_warn "Dnsmasq not installed, skipping configuration."
  exit 0
fi

print_step "Configuring dnsmasq..."
changed=false
if [[ -z "${HOMEBREW_PREFIX}" ]]; then
  print_log "HOMEBREW_PREFIX not set, using default: $HOMEBREW_PREFIX"
else
  mkdir -p $HOMEBREW_PREFIX/etc/dnsmasq.d
  config_content=$'address=/test/127.0.0.1\nlisten-address=127.0.0.1\ninterface=lo0'
  config_file="$HOMEBREW_PREFIX/etc/dnsmasq.d/test.conf"
  if [[ -f "$config_file" ]] && [[ "$(cat "$config_file")" == "$config_content" ]]; then
    print_log "Dnsmasq config file already exists with correct content, skipping."
  else
    echo "$config_content" > "$config_file"
    print_log "Dnsmasq config file created/updated."
    changed=true
  fi

  resolver_file="/etc/resolver/test"
  if [[ -f "$resolver_file" ]] && [[ "$(cat "$resolver_file")" == "nameserver 127.0.0.1" ]]; then
    print_log "Resolver file already exists with correct content, skipping."
  else
    sudo mkdir -pv /etc/resolver
    sudo bash -c 'echo "nameserver 127.0.0.1" > /etc/resolver/test'
    print_log "Resolver file created/updated."
    changed=true
  fi

  # Restarting needs sudo, so only pay for it when something actually changed
  if [[ "$changed" == true ]]; then
    sudo brew services restart dnsmasq
    print_log "Dnsmasq service restarted."
  fi
fi
print_success "Dnsmasq configuration completed."
