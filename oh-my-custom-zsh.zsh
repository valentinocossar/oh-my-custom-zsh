# Read from ENV
export $(egrep -v '^#' $ZSH_CUSTOM/.env | xargs)

# PWLen - custom password generator function
# Usage: pwlen 20 (without special characters) or pwlen 20 char (with special characters)
# Required pwgen, install with: brew install pwgen
# For further help: pwgen -h
pwlen() {
  if [[ $2 == "char" ]]; then
    pwgen -Bcnsvy -r \<\>\=\+\'\"\?\^\(\)\`\:\~\;\:\[\]\{\}\.\,\\\/\| $1 1 | tr -d "\n" | pbcopy;
  else
    pwgen -Bcnsv $1 1 | tr -d "\n" | pbcopy;
  fi
  echo -e "$(pbpaste)\nCopied to clipboard!"
}

# macOS
alias rm="${aliases[rm]:-rm} -vi"
alias cp="${aliases[cp]:-cp} -vi"
alias mv="${aliases[mv]:-mv} -vi"
alias grep="grep --color=auto"
alias rmds="find . -name '*.DS_Store' -type f -delete"
alias hosts="vsa /etc/hosts"
alias exports="vsa /etc/exports"
alias knownhosts="vsa ~/.ssh/known_hosts"
alias resetls="/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -kill -seed -r -f -v -domain local -domain user -domain system"
alias flushdns="sudo dscacheutil -flushcache;sudo killall -HUP mDNSResponder;"
alias restartbar="sudo pkill TouchBarServer && sudo pkill 'Touch Bar agent' && sudo killall 'ControlStrip'"
# alias lsdropbox="find ~/Dropbox\ \(Personale\) ~/Dropbox\ \(Company\) -path '*(Copia in conflitto di * [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]*' -print"
# alias cldropbox="find ~/Dropbox\ \(Personale\) ~/Dropbox\ \(Company\) -path '*(Copia in conflitto di * [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]*' -exec rm -f {} \;"

# ssh-agent
alias lsssh="ssh-add -L"
alias clssh="ssh-add -D"
alias adssh="ssh-add -K ~/.ssh/id_rsa"

# Oh My Zsh and Oh My Custom Zsh
alias ohmyzsh="cd ~/.oh-my-zsh"
alias customohmyzsh="cd ~/.oh-my-custom-zsh"

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

# Get SSH config from GitLab
sshget() {
  SSH_CONFIG_PATH=~/.ssh/config
  CONTENT=$(curl -s --header "PRIVATE-TOKEN: $SSH_CONFIG_REPO_TOKEN" "https://gitlab.com/api/v4/projects/$SSH_CONFIG_REPO_ID/repository/files/config/raw?ref=master")
  if [ ! -w "$SSH_CONFIG_PATH" ]; then
    touch $SSH_CONFIG_PATH
    chmod 600 $SSH_CONFIG_PATH
  fi
  if [ ! -z "$CONTENT" ] && [ -w "$SSH_CONFIG_PATH" ]; then
    echo "$CONTENT" > "$SSH_CONFIG_PATH"
    echo "File ~/.ssh/config updated!"
  fi
}

# Print SSH config formatted hosts aliases
sshls() {
  GREEN=$(tput setaf 2)
  NORMAL=$(tput sgr0)
  HOSTS=( $(sed -n '/*/! s/Host //p' ~/.ssh/config) )
  USERS=( $(sed -n 's/User //p' ~/.ssh/config) )
  HOSTNAMES=( $(sed -n 's/Hostname //p' ~/.ssh/config) )
  PORTS=( $(sed -n 's/Port //p' ~/.ssh/config) )
  for ((i=1;i<=${#HOSTS[@]};++i)); do
    printf "%s -> %s@%s:%s\n" "${GREEN}${HOSTS[i]}${NORMAL}" "${USERS[i]}" "${HOSTNAMES[i]}" "${PORTS[i]}"
  done
}

# Print plist file to stdout (XML format)
catplist() {
  plutil -convert xml1 -o - $1
}

# Quick jump into WordPress theme folder
theme() {
  if [ -d "../site/web/app/themes/$1" ]; then
    cd ../site/web/app/themes/$1
    return
  fi
  if [ -d "site/web/app/themes/$1" ]; then
    cd site/web/app/themes/$1
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
  echo "Theme folder doesn't exist!"
}

# Quick change Ansible installed version
avm() {
  ACV=$(pip show ansible | grep Version | cut -d\  -f2)
  ANV=$1
  ANV_REGEX="^([0-9]\.[0-9]\.[0-9])"
  if [ "$ANV" = "" -o "$ANV" = "-v" -o "$ANV" = "-V" -o "$ANV" = "--version" -o "$ANV" = "v" -o "$ANV" = "V" -o "$ANV" = "version" ]; then
    echo "Ansible current version: $ACV"
    return
  fi
  if [[ ! $ANV =~ $ANV_REGEX ]]; then
    tput setaf 1; echo "Incorrect entry '$ANV' (semantic versioning with three (>= 2.5.0) or four (< 2.5.0) digits)"
    return
  fi
  if [ "$ACV" = "$ANV" ]; then
    tput setaf 1; echo "Version already installed (ansible-$ANV)"
    return
  fi
  if [ "$ACV" != "" ]; then
    echo "Attempt to uninstall ansible-$ACV"
    pip uninstall -q -y ansible
    wait
    echo "Successfully uninstalled ansible-$ACV"
  fi
  echo "Installing ansible-$ANV"
  pip install -q ansible==$ANV
  if [ $? -eq 0 ]; then
    echo "Successfully installed ansible-$ANV"
  fi
}

# Change workspace
works() {
  PROJ=$1
  if [ ! -d "$HOME/Workspace/$PROJ" ] && [ "$PROJ" != "" ]; then
    echo "$HOME/Workspace/$PROJ is not a directory!"
  else
    if [ "$PROJ" = "" ]; then
      cd $HOME/Workspace
    else
      cd $HOME/Workspace/$PROJ
    fi
  fi
  return
}

# Personal aliases
alias trellis-database-uploads-migration="cd ~/Workspace/trellis-database-uploads-migration"
alias rankz="cd ~/Workspace/wordpress-plugins/rankz"
alias bedrock-lando-shipit="cd ~/Workspace/bedrock-lando-shipit"

# Other customers aliases
alias ellegiti="cd ~/Workspace/ellegiti.it/app/public"
alias remida="cd ~/Workspace/gioielliremida.it/app/public"

# Example workspace alias
alias example="cd ~/Workspace/example.com"
