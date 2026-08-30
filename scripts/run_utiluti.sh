#!/bin/bash

set -e

# Source utility functions
source scripts/utils.sh

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
print_step "Running associations with utiluti..."
for entry in "${uti_associations[@]}"; do
  # Extract UTI (first word) and app bundle (second word)
  uti="${entry%% *}"
  app_bundle="${entry##* }"

  utiluti type set "$uti" "$app_bundle" || true
done
print_success "Utiluti associations completed successfully."
