#!/bin/bash

set -e

# Source utility functions
source ./scripts/utils.sh

print_log "Starting Oh My Custom Zsh bootstrap..."

# Run installation scripts in order
./scripts/install_command_line_tools.sh
./scripts/install_homebrew.sh
./scripts/install_oh_my_zsh.sh
./scripts/create_hushlogin.sh
./scripts/setup_symlinks.sh
./scripts/install_oh_my_zsh_plugins.sh
./scripts/install_oh_my_zsh_themes.sh
./scripts/install_homebrew_packages.sh
./scripts/install_homebrew_casks.sh
./scripts/configure_dnsmasq.sh
./scripts/run_duti.sh
./scripts/install_node.sh
./scripts/install_composer_packages.sh
./scripts/install_npm_packages.sh

print_log "Bootstrap completed successfully! Please start a new terminal session to apply changes."
