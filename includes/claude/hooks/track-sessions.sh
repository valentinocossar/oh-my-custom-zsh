#!/bin/bash
# SessionStart/SessionEnd hook: keeps one file per open session

PATH="$PATH:/opt/homebrew/bin"
command -v jq >/dev/null 2>&1 || exit 0

dir="$HOME/.claude/active-sessions"
input=$(cat)
id=$(jq -r '.session_id // empty' <<<"$input" 2>/dev/null)
[[ -n "$id" ]] || exit 0
# Print-mode runs look like any other session in the hook input; only the parent's flags tell them apart
[[ " $(ps -o command= -p "$PPID") " =~ \ (-p|--print)\  ]] && exit 0

case "$(jq -r '.hook_event_name' <<<"$input")" in
  SessionStart)
    mkdir -p "$dir"
    jq '{session_id, cwd, transcript_path}' <<<"$input" >"$dir/$id.json"
    find "$dir" -name '*.json' -mtime +30 -delete
    ;;
  SessionEnd)
    # Only a deliberate exit forgets the session; a closed window or a reboot keeps it
    case "$(jq -r '.reason' <<<"$input")" in
      prompt_input_exit|clear|logout|resume) rm -f "$dir/$id.json" ;;
    esac
    ;;
esac

exit 0
