# macOS
alias sudo='sudo '
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
alias uncommit="git reset --soft HEAD~1"

# SSH agent
alias sshls="ssh-add -L"
alias sshdl="ssh-add -D"
alias sshad="ssh-add --apple-use-keychain ~/.ssh/id_ed25519"

# Oh My Zsh and Oh My Custom Zsh
alias ohmyzsh="cd ~/.oh-my-zsh"
alias ohmycustomzsh="cd ~/.oh-my-custom-zsh"

# Visual Studio Code
alias vsls="code --list-extensions"

# Sail
alias sail='bash ./vendor/bin/sail'
