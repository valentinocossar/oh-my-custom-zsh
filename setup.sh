#!/bin/bash

set -e

# Run from the repo root regardless of where this script is invoked from
cd "$(dirname "$0")"

# Source utility functions
source ./scripts/utils.sh

print_step "Starting Oh My Custom Zsh setup..."

# Run installation scripts in order
./scripts/install_command_line_tools.sh
./scripts/install_homebrew.sh
./scripts/install_oh_my_zsh.sh
./scripts/create_hushlogin.sh
./scripts/setup_symlinks.sh
./scripts/install_oh_my_zsh_plugins.sh
./scripts/install_oh_my_zsh_themes.sh
./scripts/install_homebrew_bundle.sh
./scripts/configure_dnsmasq.sh
./scripts/run_utiluti.sh
./scripts/setup_symlink_mise.sh
./scripts/run_mise_install.sh
./scripts/install_composer_packages.sh
./scripts/install_claude_plugins.sh

# Cosmetic system tweaks, kept last so a declined prompt or missing sudo can't
# abort the steps above
./scripts/set_macos_defaults.sh || true

print_success "Setup completed successfully! Please start a new terminal session to apply changes."
