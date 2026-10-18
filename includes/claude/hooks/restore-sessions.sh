#!/bin/bash
# Reopens the Claude Code sessions left open by a terminal close or reboot
#
# Usage: claude-restore [--dry-run]

PATH="$PATH:/opt/homebrew/bin"
command -v jq >/dev/null 2>&1 || { echo "jq not found."; exit 0; }

# Claude Code registers each live process as <pid>.json with its session id
is_running() {
  local f
  for f in $(grep -l "\"$1\"" "$HOME"/.claude/sessions/*.json 2>/dev/null); do
    kill -0 "$(basename "$f" .json)" 2>/dev/null && return 0
  done
  return 1
}

# A terminal attached to a background session only logs a short id of it, e.g. "running in the background (d0ef73ab)"
background_target() {
  local short
  short=$(jq -r 'select(.subtype == "local_command") | .content' "$1" 2>/dev/null \
    | sed -n 's/.*running in the background (\([0-9a-f]\{8\}\)).*/\1/p' | tail -n 1)
  [[ -n "$short" ]] || return 1
  ls "$HOME"/.claude/projects/*/"$short"-*.jsonl 2>/dev/null | head -n 1
}

has_messages() {
  grep -q '"type":"\(user\|assistant\)"' "$1"
}

commands=()
for f in "$HOME"/.claude/active-sessions/*.json; do
  [[ -e "$f" ]] || continue
  IFS=$'\t' read -r id cwd transcript < <(jq -r '[.session_id, .cwd, .transcript_path] | @tsv' "$f")
  if is_running "$id"; then
    echo "Skip $id: already running."
    continue
  fi
  # The background session outlives the terminal, so reattach to it instead of reopening the empty view
  if [[ -f "$transcript" ]] && target=$(background_target "$transcript"); then
    echo "$id was attached to background session $(basename "$target" .jsonl)."
    transcript=$target
    id=$(basename "$target" .jsonl)
    cwd=$(jq -r 'select(.cwd) | .cwd' "$target" | head -n 1)
  fi
  if [[ ! -d "$cwd" ]]; then
    echo "Skip $id: $cwd no longer exists."
  elif [[ ! -f "$transcript" ]] || ! has_messages "$transcript"; then
    echo "Skip $id: never had a message, nothing to resume."
  else
    commands+=("cd $(printf '%q' "$cwd") && claude --resume $id")
  fi
done

# Several closed terminals may have been attached to the same background session
if (( ${#commands[@]} > 0 )); then
  IFS=$'\n' read -r -d '' -a commands < <(printf '%s\n' "${commands[@]}" | awk '!seen[$0]++'; printf '\0')
fi

if (( ${#commands[@]} == 0 )); then
  echo "Nothing to restore."
  exit 0
fi

if [[ "${1:-}" == "--dry-run" ]]; then
  printf '%s\n' "${commands[@]}"
  exit 0
fi

# Commands go in as argv, so paths need no AppleScript escaping
osascript - "${commands[@]}" <<'APPLESCRIPT'
on run argv
  tell application "iTerm"
    activate
    if (count of windows) is 0 then create window with default profile
    set target_window to current window
    repeat with i from 1 to count of argv
      tell target_window to create tab with default profile
      tell current session of current tab of target_window to write text (item i of argv)
    end repeat
  end tell
end run
APPLESCRIPT
