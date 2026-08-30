# Override cat to use bat if available
cat() {
  if command -v bat &>/dev/null; then
    bat --paging=never "$@"
  else
    command cat "$@"
  fi
}

# Go to workspace projects
works() {
  local workspace_path="$HOME/Workspace"
  local proj=$1

  if [ ! -d "$workspace_path/$proj" ] && [ "$workspace_path/$proj" != "" ]; then
    echo "'$proj' is not a directory project or not exists!"
  else
    if [ "$proj" = "" ]; then
      cd "$workspace_path"
    else
      cd "$workspace_path/$proj"
    fi
  fi
  return
}

# Generate commit message with Claude
function commit() {
  local commit_message="$*"

  git add .

  if [ "$commit_message" = "" ]; then
    # Start spinner in background
    {
      spinner="⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏"
      while true; do
        for (( i=0; i<${#spinner}; i++ )); do
          printf "\r${spinner:$i:1} Generating commit message..."
          sleep 0.1
        done
      done
    } &!
    local spinner_pid=$!

    # Cleanup function for interrupt
    cleanup() {
      { kill $spinner_pid; wait $spinner_pid; } 2>/dev/null
      printf "\r\033[K"
      trap - INT
      return 1
    }
    trap cleanup INT

    # Get diff and generate message
    local diff_input
    diff_input=$(echo "=== Summary ===" && git diff --cached --stat && echo -e "\n=== Diff (truncated if large) ===" && git diff --cached | head -c 50000)
    commit_message=$(echo "$diff_input" | claude -p "Write a single-line commit message for this diff. Output ONLY the message, no quotes, no explanation, no markdown.")

    # Stop spinner and clear line
    trap - INT
    { kill $spinner_pid; wait $spinner_pid; } 2>/dev/null
    printf "\r\033[K"

    git commit -m "$commit_message"
    return
  fi

  git commit -a -m "$commit_message"
}

# PW - Custom password generator function
# Usage:
# - pw 20 (genrate random password, without special characters)
# - pw 20 char (genrate random password, with special characters)
# Required pwgen, install with: brew install pwgen
# For further help: pwgen -h
pw() {
  if [[ $2 == "char" ]]; then
    pwgen -Bcnsvy -r \<\>\=\+\'\"\?\^\(\)\`\:\~\;\:\[\]\{\}\.\,\\\/\| $1 1 | tr -d "\n" | pbcopy;
  else
    pwgen -Bcnsv $1 1 | tr -d "\n" | pbcopy;
  fi
  echo -e "$(pbpaste)\nCopied to clipboard!"
}

# PW bcrypt - Custom bcrypt password generator function
# Usage:
# - pwbcrypt newPassword (generate bcrypt hash)
# - pwbcrypt 20 (genrate random bcrypt hash and password, without special characters)
# - pwbcrypt 20 char (genrate random bcrypt hash and password, with special characters)
# Required pwgen, install with: brew install pwgen
# For further help: pwgen -h
pwbcrypt() {
  local password rounds bcrypt_hash
  if [[ $1 =~ '^[0-9]+$' ]]; then
    if [[ $3 == "char" ]]; then
      password=$(pwgen -Bcnsvy -r \<\>\=\+\'\"\?\^\(\)\`\:\~\;\:\[\]\{\}\.\,\\\/\| $1 1 | tr -d "\n");
    else
      password=$(pwgen -Bcnsv $1 1 | tr -d "\n");
    fi
  else
    password=$1
  fi
  if [[ $2 =~ '^[0-9]+$' ]]; then
    rounds=$2
  else
    rounds=10
  fi
  bcrypt_hash=$(htpasswd -nbBC $rounds user $password | awk -F 'user:' '{print $2}')
  echo -e "Password: $password"
  echo $bcrypt_hash | tr -d "\n" | pbcopy
  echo -e "Bcrypt hash with $rounds rounds (copied to clipboard): $bcrypt_hash"
}

# Benchmark shell load time
zshbench() {
  local shell_bin=${1:-$SHELL}
  local i
  for i in $(seq 1 10); do /usr/bin/time "$shell_bin" -i -c exit; done
}

# Print plist file to stdout (XML format)
catplist() {
  plutil -convert xml1 -o - "$1"
}
