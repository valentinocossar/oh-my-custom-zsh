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

commands=()
for f in "$HOME"/.claude/active-sessions/*.json; do
  [[ -e "$f" ]] || continue
  IFS=$'\t' read -r id cwd transcript < <(jq -r '[.session_id, .cwd, .transcript_path] | @tsv' "$f")
  if is_running "$id"; then
    echo "Skip $id: already running."
  elif [[ ! -d "$cwd" ]]; then
    echo "Skip $id: $cwd no longer exists."
  elif [[ ! -f "$transcript" ]]; then
    echo "Skip $id: never had a message, nothing to resume."
  else
    commands+=("cd $(printf '%q' "$cwd") && claude --resume $id")
  fi
done

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
