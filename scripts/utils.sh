# Utility functions for scripts

# ANSI colors, defined once here and shared through `source scripts/utils.sh`,
# so no sub-script needs to redeclare them. No-ops when stdout is not a TTY
# or NO_COLOR is set.
if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
  C_RESET=$'\033[0m'
  C_DIM=$'\033[2m'
  C_BLUE=$'\033[1;34m'
  C_GREEN=$'\033[1;32m'
  C_YELLOW=$'\033[1;33m'
  C_RED=$'\033[1;31m'
else
  C_RESET='' C_DIM='' C_BLUE='' C_GREEN='' C_YELLOW='' C_RED=''
fi

_log_prefix() {
  printf '%s[%s]%s ' "$C_DIM" "$(date +'%Y-%m-%d %H:%M:%S')" "$C_RESET"
}

# Neutral progress message
print_log() {
  printf '%s%s\n' "$(_log_prefix)" "$*"
}

# Highlighted step / section header
print_step() {
  printf '%s%s==>%s %s\n' "$(_log_prefix)" "$C_BLUE" "$C_RESET" "$*"
}

print_success() {
  printf '%s%s%s%s\n' "$(_log_prefix)" "$C_GREEN" "$*" "$C_RESET"
}

print_warn() {
  printf '%s%s%s%s\n' "$(_log_prefix)" "$C_YELLOW" "$*" "$C_RESET"
}

# Error message, sent to stderr
print_error() {
  printf '%s%s%s%s\n' "$(_log_prefix)" "$C_RED" "$*" "$C_RESET" >&2
}
