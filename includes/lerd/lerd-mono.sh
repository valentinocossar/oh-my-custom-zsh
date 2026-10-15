#!/bin/bash

# Restores --mono in Lerd's tray LaunchAgent

set -u

TRAY_PLIST="$HOME/Library/LaunchAgents/lerd-tray.plist"
TRAY_LABEL="com.lerd.lerd-tray"
PLIST_BUDDY=/usr/libexec/PlistBuddy

# PlistBuddy creates a missing file on write, so never touch an absent plist
[ -f "$TRAY_PLIST" ] || exit 0

# Let Lerd finish writing the file before reading it
sleep 2
[ -f "$TRAY_PLIST" ] || exit 0

if "$PLIST_BUDDY" -c "Print :ProgramArguments" "$TRAY_PLIST" 2>/dev/null | grep -q -- "--mono"; then
  exit 0
fi

"$PLIST_BUDDY" -c "Add :ProgramArguments: string --mono" "$TRAY_PLIST" || exit 1

# Reload only a running tray, a stopped Lerd must stay stopped
domain="gui/$(id -u)"
if launchctl print "$domain/$TRAY_LABEL" >/dev/null 2>&1; then
  launchctl bootout "$domain/$TRAY_LABEL" 2>/dev/null
  # Bootstrap fails with an I/O error while the old job is still tearing down
  for _ in 1 2 3 4 5; do
    launchctl bootstrap "$domain" "$TRAY_PLIST" 2>/dev/null && break
    sleep 1
  done
fi

echo "$(date '+%F %T'): --mono restored in $TRAY_PLIST"
