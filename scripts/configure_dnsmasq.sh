#!/bin/bash

set -e

# Source utility functions
source scripts/utils.sh

# Add Homebrew to PATH for this session
eval "$(/opt/homebrew/bin/brew shellenv)"

print_log "Configuring dnsmasq..."
if [[ -z "${HOMEBREW_PREFIX}" ]]; then
  print_log "HOMEBREW_PREFIX not set, using default: $HOMEBREW_PREFIX"
else
  mkdir -p $HOMEBREW_PREFIX/etc/dnsmasq.d
  config_content="address=/test/127.0.0.1\nlisten-address=127.0.0.1\ninterface=lo0"
  config_file="$HOMEBREW_PREFIX/etc/dnsmasq.d/test.conf"
  if [[ -f "$config_file" ]] && [[ "$(cat "$config_file")" == "$config_content" ]]; then
    print_log "Dnsmasq config file already exists with correct content, skipping."
  else
    echo -e "$config_content" > "$config_file"
    print_log "Dnsmasq config file created/updated."
  fi

  sudo mkdir -pv /etc/resolver
  resolver_file="/etc/resolver/test"
  if [[ -f "$resolver_file" ]] && [[ "$(cat "$resolver_file")" == "nameserver 127.0.0.1" ]]; then
    print_log "Resolver file already exists with correct content, skipping."
  else
    sudo bash -c 'echo "nameserver 127.0.0.1" > /etc/resolver/test'
    print_log "Resolver file created/updated."
  fi

  sudo brew services restart dnsmasq
  print_log "Dnsmasq service restarted."
fi
print_log "Dnsmasq configuration completed."
