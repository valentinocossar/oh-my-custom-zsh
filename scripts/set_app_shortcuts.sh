#!/bin/bash

set -e

# Source utility functions
source scripts/utils.sh

print_step "Setting app keyboard shortcuts..."

# Otherwise it writes its cached shortcuts back over these
osascript -e 'tell application "System Settings" to quit' || true

# Menu-item overrides, "domain|Exact Menu Item Title|key equivalent". A title
# that does not match the menu exactly is silently ignored, hence each one in
# both languages (IT/EN).
#
# | Write | Modifier  |
# | ----- | --------- |
# | @     | ⌘ command |
# | ~     | ⌥ option  |
# | ^     | ⌃ control |
# | $     | ⇧ shift   |
#
# The key goes last, a lowercase letter or the literal character of a non-printing
# key (→ ← ↑ ↓ ⇥ ⌫ ⎋). So @r is ⌘R, @$v is ⇧⌘V, @~^q is ⌃⌥⌘Q, @~→ is ⌥⌘→.
app_shortcuts=(
  "com.apple.FileMerge|Recompare Files|@r"

  "com.apple.mail|Cerca casella|@\$f"
  "com.apple.mail|Mailbox Search|@\$f"
  "com.apple.mail|Incolla e associa lo stile|@\$v"
  "com.apple.mail|Paste and Match Style|@\$v"

  "com.apple.Notes|Ricerca in elenco note…|@\$f"
  "com.apple.Notes|Note List Search…|@\$f"
  "com.apple.Notes|Incolla e associa lo stile|@\$v"
  "com.apple.Notes|Paste and Match Style|@\$v"

  "com.apple.Safari|Esci da Safari|@~^q"
  "com.apple.Safari|Quit Safari|@~^q"
  "com.apple.Safari|Mostra Reader|@~^r"
  "com.apple.Safari|Show Reader|@~^r"
  "com.apple.Safari|Ricarica pagina da origine|@\$r"
  "com.apple.Safari|Reload Page From Origin|@\$r"

  "com.anthropic.claudefordesktop|Enter Full Screen|@^f"

  "com.panic.Transmit|Select Next Tab|@~→"
  "com.panic.Transmit|Select Previous Tab|@~←"

  "com.pixelmatorteam.pixelmator.x|Mostra pannello precedente|@~←"
  "com.pixelmatorteam.pixelmator.x|Show Previous Tab|@~←"
  "com.pixelmatorteam.pixelmator.x|Mostra pannello successivo|@~→"
  "com.pixelmatorteam.pixelmator.x|Show Next Tab|@~→"

  "com.tinyapp.TablePlus|Select Next Tab|@~→"
  "com.tinyapp.TablePlus|Select Previous Tab|@~←"
)

# Distinct domains
domains=""
for entry in "${app_shortcuts[@]}"; do
  domain="${entry%%|*}"

  case " $domains " in
  *" $domain "*) continue ;;
  esac
  domains="$domains $domain"
done

# `defaults` writes into the app sandbox container, hidden by TCC without Full Disk Access
blocked=""
for domain in $domains; do
  container_prefs="$HOME/Library/Containers/$domain/Data/Library/Preferences"

  if [ -d "$container_prefs" ] && ! ls "$container_prefs" >/dev/null 2>&1; then
    blocked="$blocked $domain"
  fi
done

if [ -n "$blocked" ]; then
  print_warn "No Full Disk Access, these will be skipped:$blocked"
  print_warn "Grant it to the terminal in System Settings > Privacy & Security > Full Disk Access."
  read -r -p "Apply the remaining apps anyway? [y/N] " reply || true
  [[ "$reply" =~ ^[Yy]$ ]] || {
    print_log "Cancelled."
    exit 0
  }
fi

# Wipe first, so an override dropped from the array disappears
for domain in $domains; do
  case " $blocked " in
  *" $domain "*) continue ;;
  esac

  defaults delete "$domain" NSUserKeyEquivalents 2>/dev/null || true
done

# Menus order modifiers ⌃⌥⇧⌘, so build the label instead of substituting in place
pretty_key() {
  local out=""

  case "$1" in *"^"*) out="${out}⌃" ;; esac
  case "$1" in *"~"*) out="${out}⌥" ;; esac
  case "$1" in *'$'*) out="${out}⇧" ;; esac
  case "$1" in *"@"*) out="${out}⌘" ;; esac

  printf '%s%s' "$out" "$(printf '%s' "${1//[@~^$]/}" | tr 'a-z' 'A-Z')"
}

for entry in "${app_shortcuts[@]}"; do
  IFS='|' read -r domain title key <<<"$entry"

  case " $blocked " in
  *" $domain "*) continue ;;
  esac

  print_log "$domain: $title -> $(pretty_key "$key")"
  defaults write "$domain" NSUserKeyEquivalents -dict-add "$title" "$key" ||
    print_warn "Failed to set $title on $domain"
done

# Newly launched apps read stale values otherwise
killall cfprefsd &>/dev/null || true

print_success "App shortcuts set. Relaunch the affected apps to pick them up."
