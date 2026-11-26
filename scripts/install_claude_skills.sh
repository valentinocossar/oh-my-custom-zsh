#!/bin/bash

set -e

# Source utility functions
source scripts/utils.sh

print_step "Installing Claude Code skills..."

# Skills shipped as a tarball whose top-level folder is the skill name (format: <name>|<url>)
claude_skills=(
  "colorfigures|https://april-zhu.com/colorfigures/colorfigures.tar.gz"
)

skills_dir="$HOME/.claude/skills"
mkdir -p "$skills_dir"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

for entry in "${claude_skills[@]}"; do
  name="${entry%%|*}"
  url="${entry#*|}"
  archive="$tmp_dir/$name.tar.gz"

  # Download fully before touching the installed copy, so a failed fetch leaves it intact
  if ! curl -fsSL "$url" -o "$archive"; then
    print_warn "Download of skill $name failed, skipping."
    continue
  fi
  if tar -tzf "$archive" | grep -qvE "^$name(/|$)"; then
    print_warn "Archive of skill $name has entries outside $name/, skipping."
    continue
  fi

  rm -rf "${skills_dir:?}/$name"
  tar -xzf "$archive" -C "$skills_dir"
  print_log "Skill $name installed."
done

print_success "Claude Code skills installed."
