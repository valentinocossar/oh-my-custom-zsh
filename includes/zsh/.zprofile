# Prefix $PATH to override a system command, suffix to add a missing one
# Exports are listed low to high priority: the last one ends up first in $PATH

# Homebrew
export HOMEBREW_BUNDLE_FILE_GLOBAL="$HOME/.config/homebrew/Brewfile"
export HOMEBREW_NO_AUTO_UPDATE=1
eval "$(/opt/homebrew/bin/brew shellenv)"

# LM Studio CLI (lms)
export PATH="$HOME/.lmstudio/bin:$PATH"

# Golang
export GOPATH="$HOME/.go"
export PATH="$GOPATH/bin:$PATH"

# MySQL client
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"

# Local binaries
export PATH="$HOME/.local/bin:$PATH"
