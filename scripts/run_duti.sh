#!/bin/bash

set -e

# Source utility functions
source scripts/utils.sh

print_log "Running Duti..."
duti -s com.microsoft.VSCode txt all
duti -s com.microsoft.VSCode csv all
duti -s com.microsoft.VSCode sql all
duti -s com.microsoft.VSCode xml all
duti -s com.microsoft.VSCode php all
duti -s com.microsoft.VSCode css all
duti -s com.microsoft.VSCode scss all
duti -s com.microsoft.VSCode less all
duti -s com.microsoft.VSCode js all
duti -s com.microsoft.VSCode jsx all
duti -s com.microsoft.VSCode ts all
duti -s com.microsoft.VSCode vue all
duti -s com.microsoft.VSCode json all
duti -s com.microsoft.VSCode lock all
duti -s com.microsoft.VSCode md all
duti -s com.microsoft.VSCode go all
duti -s com.microsoft.VSCode sh all
duti -s com.microsoft.VSCode cfg all
duti -s com.microsoft.VSCode conf all
duti -s com.microsoft.VSCode ini all
duti -s com.microsoft.VSCode template all
duti -s com.microsoft.VSCode bak all
duti -s com.microsoft.VSCode log all
duti -s com.microsoft.VSCode yml all
duti -s com.microsoft.VSCode yaml all
duti -s com.microsoft.VSCode rb all
duti -s com.microsoft.VSCode py all
print_log "Duti run completed"
