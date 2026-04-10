#!/bin/bash

set -e

# Source utility functions
source scripts/utils.sh

# Download and install the latest official utiluti
print_log "Installing utiluti..."
UTILUTI_PKG="/tmp/utiluti.pkg"
curl -sL -o "$UTILUTI_PKG" "https://github.com/scriptingosx/utiluti/releases/latest/download/utiluti-1.5.pkg"
sudo installer -pkg "$UTILUTI_PKG" -target / &>/dev/null
rm -f "$UTILUTI_PKG"

# UTI associations to set corresponding app bundle identifier
# Format: "UTI bundle_identifier"
uti_associations=(
  "public.plain-text com.microsoft.VSCode"
  "public.comma-separated-values-text com.microsoft.VSCode"
  "public.json com.microsoft.VSCode"
  "public.xml com.microsoft.VSCode"
  "net.daringfireball.markdown com.microsoft.VSCode"
  "public.yaml com.microsoft.VSCode"
  "com.apple.log com.microsoft.VSCode"
  "public.shell-script com.microsoft.VSCode"
  "public.python-script com.microsoft.VSCode"
  "public.ruby-script com.microsoft.VSCode"
  "public.php-script com.microsoft.VSCode"
  "com.netscape.javascript-source com.microsoft.VSCode"
  "public.css com.microsoft.VSCode"
)

# Set the global default app for each UTI
print_log "Running configuration with utiluti..."
for entry in "${uti_associations[@]}"; do
  # Extract UTI (first word) and app bundle (second word)
  uti="${entry%% *}"
  app_bundle="${entry##* }"

  utiluti type set "$uti" "$app_bundle" || true
done
print_log "Utiluti configuration completed successfully."

# Uninstall utiluti
print_log "Uninstalling utiluti..."
sudo rm -f "/usr/local/bin/utiluti"
sudo pkgutil --forget "com.scriptingosx.utiluti" &>/dev/null || true

print_log "UTI associations completed successfully."
