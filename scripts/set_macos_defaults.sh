#!/bin/bash

set -e

# Source utility functions
source scripts/utils.sh

print_step "Setting macOS defaults..."

print_warn "This changes macOS system settings. Close System Settings first."
read -r -p "Continue? [y/N] " reply || true
[[ "$reply" =~ ^[Yy]$ ]] || { print_log "Cancelled."; exit 0; }

# Close System Settings so it doesn't override changes on exit
osascript -e 'tell application "System Settings" to quit' || true

###############################################################################
# General UI/UX
###############################################################################

# Mute the startup chime
sudo nvram SystemAudioVolume=" " || print_warn "Skipped startup chime mute (needs sudo)"

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Disable the "downloaded from the Internet, are you sure?" dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

###############################################################################
# Keyboard and input
###############################################################################

# Enable full keyboard access for all controls (Tab in dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Disable smart quotes, smart dashes and auto-correct (annoying for code)
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

###############################################################################
# Language and region
###############################################################################

# Interface in English (US), Italian as fallback
defaults write NSGlobalDomain AppleLanguages -array "en-US" "it-IT"

# US locale, formats follow the Italy region
defaults write NSGlobalDomain AppleLocale -string "en_US@rg=itzzzz"

# Use the metric system
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool true

###############################################################################
# Finder
###############################################################################

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# New Finder windows open in Home
defaults write com.apple.finder NewWindowTarget -string "PfHm"

# Use column view in all Finder windows (icnv, Nlsv, clmv, Flwv)
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

# When searching, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Desktop: hide internal disks, show external/servers/removable
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

###############################################################################
# Dock
###############################################################################

# Auto-hide the Dock
defaults write com.apple.dock autohide -bool true

# Set the icon size of Dock items to 55 pixels
defaults write com.apple.dock tilesize -int 55

# Prevent applications from bouncing in the Dock
defaults write com.apple.dock no-bouncing -bool true

# Make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true

# Don't automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

###############################################################################
# Apply changes
###############################################################################

# Restart affected apps
for app in cfprefsd Dock Finder SystemUIServer; do
  killall "$app" &>/dev/null || true
done

print_success "macOS defaults set. Some changes need a logout or restart to take effect."
