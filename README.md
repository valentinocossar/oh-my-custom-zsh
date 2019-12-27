Oh My Custom Zsh
================

Custom Oh My Zsh folder and other utilities.

**DISCLAIMER:** this repo is specific for my personal workflow and configuration. Don't use it as is, fork and customize if you like it.

## Getting Started

### Prerequisites

**IMPORTANT:** install prerequisites before install Oh My Custom Zsh.

  * [Xcode](https://developer.apple.com/xcode) - recommended install from Mac App Store
  * [Command Line Tools](https://developer.apple.com/xcode/features) - recommended install with `xcode-select --install`
  * [Homebrew](https://brew.sh/index_it.html) - recommended install from website
  * [Oh My Zsh](https://github.com/robbyrussell/oh-my-zsh) - recommended install with curl
  * [Mackup](https://github.com/lra/mackup) - recommended install with brew
  * [NVM](https://github.com/creationix/nvm) - recommended install with brew
  * [rbenv](https://github.com/rbenv/rbenv) - recommended install with brew
  * [PHP](https://php-osx.liip.ch) - recommended install with brew
  * [Python](https://www.python.org) - recommended install with brew
  * [pwgen](https://sourceforge.net/projects/pwgen) - recommended install with brew
  * [Composer](https://getcomposer.org) - recommended install with brew
  * [Gulp](http://gulpjs.com) - recommended install with npm
  * [Yarn](https://yarnpkg.com) - recommended install with npm
  * [Vagrant](https://www.vagrantup.com) - recommended install with brew cask

### Basic Installation

  1. Clone this repository in your $HOME folder.

  ```sh
  git clone https://github.com/valentinocossar/oh-my-custom-zsh.git ~/.oh-my-custom-zsh
  ```

  2. If your default shell is already /bin/zsh, backup (if you want) and delete these two files.

  ```sh
  rm ~/.zshrc
  rm ~/.zprofile
  ```

  3. Create symbolic links of `.zshrc` and `.zprofile` into your $HOME folder.

  ```sh
  ln -s $HOME/.oh-my-custom-zsh/zfiles/.zshrc $HOME/.zshrc
  ln -s $HOME/.oh-my-custom-zsh/zfiles/.zprofile $HOME/.zprofile
  ```

  4. Create symbolic link of `.mackup.cfg` into your $HOME folder.

  ```sh
  ln -s $HOME/.oh-my-custom-zsh/mackup/.mackup.cfg $HOME/.mackup.cfg
  ```

  5. Restore files with mackup.

  ```sh
  mackup restore
  ```

  6. Start a new terminal session.

  7. Install all custom themes and plugins.

## Using Oh My Custom Zsh

### Custom plugins

  * [vscode](https://github.com/valentinocossar/vscode)
  * [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
  * [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)

### Custom themes

  * [spaceship](https://github.com/denysdovhan/spaceship-zsh-theme)

## Other Homebrew formulas

  * [ack](https://beyondgrep.com)
  * [bat](https://github.com/sharkdp/bat)
  * [dnsmasq](http://www.thekelleys.org.uk/dnsmasq/docs/dnsmasq-man.html)
  * [duti](https://github.com/moretension/duti)
  * [helm](https://helm.sh)
  * [helmfile](https://github.com/roboll/helmfile)
  * [kubectx](https://github.com/ahmetb/kubectx)
  * [mas](https://github.com/mas-cli/mas)
  * [stern](https://github.com/wercker/stern)
  * [thefuck](https://github.com/nvbn/thefuck)
  * [tidy-html5](http://www.html-tidy.org)
  * [tree](https://formulae.brew.sh/formula/tree)
  * [watch](https://formulae.brew.sh/formula/watch)
  * [wget](https://formulae.brew.sh/formula/wget)

## Authors

  - [Valentino](https://github.com/valentinocossar)
