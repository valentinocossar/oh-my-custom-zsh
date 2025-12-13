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

# macOS
alias ll="ls -alhF"
alias rm="${aliases[rm]:-rm} -vi"
alias mv="${aliases[mv]:-mv} -vi"
alias cp="${aliases[cp]:-cp} -v"
alias grep="${aliases[grep]:-grep} --color=auto -n"
alias rmds="find . -name '*.DS_Store' -type f -delete"
alias rmt="trash"
alias hosts="vsa /etc/hosts"
alias exports="vsa /etc/exports"
alias knownhosts="vsa ~/.ssh/known_hosts"
alias sshconfig="vsa ~/.ssh/config"
alias resetls="/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -kill -seed -r -f -v -domain local -domain user -domain system"
alias flushdns="sudo killall -HUP mDNSResponder"
alias clearkext="sudo kextcache --clear-staging"
alias myip="dig +short txt ch whoami.cloudflare @1.0.0.1"
alias qrscan="zbarimg"
alias weight="tree -a --du -sh"

# Cat
cat() {
  if command -v bat &>/dev/null; then
    bat --paging=never "$@"
  else
    command cat "$@"
  fi
}

# Git
alias gcs="git checkout staging"

# ssh-agent
alias sshls="ssh-add -L"
alias sshdl="ssh-add -D"
alias sshad="ssh-add --apple-use-keychain ~/.ssh/id_rsa ~/.ssh/id_ed25519 ~/.ssh/id_ed25519_personal"

# Oh My Zsh and Oh My Custom Zsh
alias ohmyzsh="cd ~/.oh-my-zsh"
alias ohmycustomzsh="cd ~/.oh-my-custom-zsh"

# Vagrant
alias vau="vagrant up"
alias vah="vagrant halt"
alias vas="vagrant status"
alias var="vagrant reload"
alias vap="vagrant provision"
alias vaup="vagrant up --provision"
alias vass="vagrant ssh"
alias vabu="vagrant box update"

# Visual Studio Code
alias vsls="code --list-extensions"

# BeDo CLI
alias bedo="./bedo.sh"

# Sail
alias sail='bash ./vendor/bin/sail'

# Stalk
alias stalk="bash ./stalk"

# Print plist file to stdout (XML format)
catplist() {
  plutil -convert xml1 -o - $1
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

# Go to projets
works() {
  WORKSPACE_PATH="$HOME/Workspace/Beliven - GitLab CE"
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
  WORKSPACE_PATH="$HOME/Workspace/Beliven - GitLab.com"
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

ghub() {
  WORKSPACE_PATH="$HOME/Workspace/Beliven - GitHub.com"
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

ghubp() {
  WORKSPACE_PATH="$HOME/Workspace/Personal - GitHub.com"
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

ado() {
  WORKSPACE_PATH="$HOME/Workspace/Beliven - Azure DevOps"
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

aquest() {
  WORKSPACE_PATH="$HOME/Workspace/AQuest - GitLab CE"
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

timenet() {
  WORKSPACE_PATH="$HOME/Workspace/Timenet - GitLab CE"
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
_works() {
  WORKSPACE_PATH="$HOME/Workspace/Beliven - GitLab CE"
  DIRS=(`ls -d "$WORKSPACE_PATH"/*/ | tr -d ' ' | xargs basename | tr '\n' ' '`)
  compadd -X "Select a 'Beliven - GitLab CE' project:" $DIRS
}
compdef _works works

_glab() {
  WORKSPACE_PATH="$HOME/Workspace/Beliven - GitLab.com"
  DIRS=(`ls -d "$WORKSPACE_PATH"/*/ | tr -d ' ' | xargs basename | tr '\n' ' '`)
  compadd -X "Select a 'Beliven - GitLab.com' project:" $DIRS
}
compdef _glab glab

_ghub() {
  WORKSPACE_PATH="$HOME/Workspace/Beliven - GitHub.com"
  DIRS=(`ls -d "$WORKSPACE_PATH"/*/ | tr -d ' ' | xargs basename | tr '\n' ' '`)
  compadd -X "Select a 'Beliven - GitHub.com' project:" $DIRS
}
compdef _ghub ghub

_ghubp() {
  WORKSPACE_PATH="$HOME/Workspace/Personal - GitHub.com"
  DIRS=(`ls -d "$WORKSPACE_PATH"/*/ | tr -d ' ' | xargs basename | tr '\n' ' '`)
  compadd -X "Select a 'Personal - GitHub.com' project:" $DIRS
}
compdef _ghubp ghubp

_ado() {
  WORKSPACE_PATH="$HOME/Workspace/Beliven - Azure DevOps"
  DIRS=(`ls -d "$WORKSPACE_PATH"/*/ | tr -d ' ' | xargs basename | tr '\n' ' '`)
  compadd -X "Select a 'Beliven - Azure DevOps' project:" $DIRS
}
compdef _ado ado

_aquest() {
  WORKSPACE_PATH="$HOME/Workspace/AQuest - GitLab CE"
  DIRS=(`ls -d "$WORKSPACE_PATH"/*/ | tr -d ' ' | xargs basename | tr '\n' ' '`)
  compadd -X "Select a 'AQuest - GitLab CE' project:" $DIRS
}
compdef _aquest aquest

_timenet() {
  WORKSPACE_PATH="$HOME/Workspace/Timenet - GitLab CE"
  DIRS=(`ls -d "$WORKSPACE_PATH"/*/ | tr -d ' ' | xargs basename | tr '\n' ' '`)
  compadd -X "Select a 'Timenet - GitLab CE' project:" $DIRS
}
compdef _timenet timenet

# Benchmark shell load time
zshbench() {
  shell=${1-$SHELL}
  for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
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
