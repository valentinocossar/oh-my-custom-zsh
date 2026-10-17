#!/bin/bash
# SessionStart hook: warns when settings.json is no longer the dotfiles symlink

[[ -L "$HOME/.claude/settings.json" ]] && exit 0

osascript -e 'display notification "settings.json is no longer a symlink to the dotfiles repo, re-create it" with title "Claude Code" sound name "Glass"' >/dev/null 2>&1 &
printf '{"systemMessage": "\\u001b[1;31m⚠️  SETTINGS SYMLINK MISSING ⚠️\\u001b[0m ~/.claude/settings.json is no longer a symlink to the dotfiles repo. Move its changes into the repo, then re-create the symlink with scripts/setup_symlinks.sh."}\n'
