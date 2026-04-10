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
./scripts/install_mas_apps.sh
./scripts/configure_dnsmasq.sh
./scripts/run_utiluti.sh
./scripts/setup_symlink_mise.sh
./scripts/run_mise_install.sh
./scripts/install_composer_packages.sh

print_log "Bootstrap completed successfully! Please start a new terminal session to apply changes."
