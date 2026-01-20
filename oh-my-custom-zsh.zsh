# macOS
alias ll="ls -alhF"
alias rm="${aliases[rm]:-rm} -vi"
alias mv="${aliases[mv]:-mv} -vi"
alias cp="${aliases[cp]:-cp} -v"
alias grep="${aliases[grep]:-grep} --color=auto -n"
alias hosts="vsa /etc/hosts"
alias knownhosts="vsa ~/.ssh/known_hosts"
alias sshconfig="vsa ~/.ssh/config"
alias flushdns="sudo killall -HUP mDNSResponder"

# Utilities
alias myip="dig +short txt ch whoami.cloudflare @1.0.0.1"
alias rmds="find . -name '*.DS_Store' -type f -delete"
alias rmt="trash"
alias weight="tree -a --du -sh"

# Git
alias gcs="git checkout staging"

# ssh-agent
alias sshls="ssh-add -L"
alias sshdl="ssh-add -D"
alias sshad="ssh-add --apple-use-keychain ~/.ssh/id_rsa ~/.ssh/id_ed25519 ~/.ssh/id_ed25519_personal"

# Oh My Zsh and Oh My Custom Zsh
alias ohmyzsh="cd ~/.oh-my-zsh"
alias ohmycustomzsh="cd ~/.oh-my-custom-zsh"

# Visual Studio Code
alias vsls="code --list-extensions"

# Sail
alias sail='bash ./vendor/bin/sail'

# Set default alias for workspace
alias works='ghub'

# Override cat to use bat if available
cat() {
  if command -v bat &>/dev/null; then
    bat --paging=never "$@"
  else
    command cat "$@"
  fi
}

# Print plist file to stdout (XML format)
catplist() {
  plutil -convert xml1 -o - $1
}

# Go to workspace projects
ghub() {
  WORKSPACE_PATH="$HOME/Workspace/GitHub.com"
  PROJ=$1

  if [ ! -d "$WORKSPACE_PATH/$PROJ" ] && [ "$WORKSPACE_PATH/$PROJ" != "" ]; then
    echo "'$PROJ' is not a directory project or not exists!"
  else
    if [ "$PROJ" = "" ]; then
      cd "$WORKSPACE_PATH"
    else
      cd "$WORKSPACE_PATH/$PROJ"
    fi
  fi
  return
}

glab() {
  WORKSPACE_PATH="$HOME/Workspace/GitLab.com"
  PROJ=$1

  if [ ! -d "$WORKSPACE_PATH/$PROJ" ] && [ "$WORKSPACE_PATH/$PROJ" != "" ]; then
    echo "'$PROJ' is not a directory project or not exists!"
  else
    if [ "$PROJ" = "" ]; then
      cd "$WORKSPACE_PATH"
    else
      cd "$WORKSPACE_PATH/$PROJ"
    fi
  fi
  return
}

# Auto completions for go to projects
_ghub() {
  WORKSPACE_PATH="$HOME/Workspace/GitHub.com"
  DIRS=(`ls -d "$WORKSPACE_PATH"/*/ | tr -d ' ' | xargs basename | tr '\n' ' '`)
  compadd -X "Select a 'GitHub.com' project:" $DIRS
}
compdef _ghub ghub

_glab() {
  WORKSPACE_PATH="$HOME/Workspace/GitLab.com"
  DIRS=(`ls -d "$WORKSPACE_PATH"/*/ | tr -d ' ' | xargs basename | tr '\n' ' '`)
  compadd -X "Select a 'GitLab.com' project:" $DIRS
}
compdef _glab glab

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
  if [[ $1 =~ '^[0-9]+$' ]]; then
    if [[ $3 == "char" ]]; then
      PASSWORD=$(pwgen -Bcnsvy -r \<\>\=\+\'\"\?\^\(\)\`\:\~\;\:\[\]\{\}\.\,\\\/\| $1 1 | tr -d "\n");
    else
      PASSWORD=$(pwgen -Bcnsv $1 1 | tr -d "\n");
    fi
  else
    PASSWORD=$1
  fi
  if [[ $2 =~ '^[0-9]+$' ]]; then
    ROUNDS=$2
  else
    ROUNDS=10
  fi
  BCRYPT_HASH=$(htpasswd -nbBC $ROUNDS user $PASSWORD | awk -F 'user:' '{print $2}')
  echo -e "Password: $PASSWORD"
  echo $BCRYPT_HASH | tr -d "\n" | pbcopy
  echo -e "Bcrypt hash with $ROUNDS rounds (copied to clipboard): $BCRYPT_HASH"
}

# Benchmark shell load time
zshbench() {
  SHELL=${1-$SHELL}
  for i in $(seq 1 10); do /usr/bin/time $SHELL -i -c exit; done
}

# PHP Version Manager
pvm() {
  NEW_VERSION=$1
  OLD_VERSION=$(php --version | awk '/^PHP/{print $2}' | cut -d'.' -f1,2)

  if [ "NEW_VERSION" != "$OLD_VERSION" ]; then
    brew unlink php@$OLD_VERSION && brew link --force php@$NEW_VERSION
  else
    cd "It's the same version!"
  fi
  return
}

# Quick jump into WordPress theme folder
theme() {
  if [ -d "website/web/app/themes/$1" ]; then
    cd website/web/app/themes/$1
    return
  fi
  if [ -d "web/app/themes/$1" ]; then
    cd web/app/themes/$1
    return
  fi
  if [ -d "wp-content/themes/$1" ]; then
    cd wp-content/themes/$1
    return
  fi
  if [ -d "themes/$1" ]; then
    cd themes/$1
    return
  fi
  if [ -d "$1" ]; then
    cd $1
    return
  fi
  echo "Theme folder doesn't exist!"
}
