# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# fnm
eval "$(fnm env --use-on-cd --shell zsh)"

# Golang
export GOPATH="$HOME/.go"
export GOROOT="$(brew --prefix golang)/libexec"
export PATH="$PATH:$GOPATH/bin:$GOROOT/bin"

# Google Cloud SDK
export PATH="/opt/homebrew/share/google-cloud-sdk/bin:$PATH"

# MySQL client
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"

# OpenSSL
export PATH="/opt/homebrew/opt/openssl@3/bin:$PATH"

# PostgreSQL client
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
