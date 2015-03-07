#!/bin/sh

# File:      install.sh
# Author:    louwie17
# Date:      2015-03-03
# Version:   1.0

# Purpose:
# Install the essential terminal tools for OSX
# Credits:
# Function written below are borrowed from thoughtbot:
#   https://github.com/thoughtbot/laptop

fancy_echo() {
  local fmt="$1"; shift

  # shellcheck disable=SC2059
  printf "\n$fmt\n" "$@"
}

append_to_file() {
  local file="$1"
  local text="$2"

  if [ "$file" = "$HOME/.zshrc" ]; then
    if [ -w "$HOME/.zshrc.local" ]; then
      file="$HOME/.zshrc.local"
    else
      file="$HOME/.zshrc"
    fi
  fi

  if ! grep -Fqs "$text" "$file"; then
    printf "\n%s\n" "$text" >> "$file"
  fi
}

case "$SHELL" in
  */zsh) : ;;
  *)
    fancy_echo "Changing your shell to zsh ..."
      chsh -s "$(which zsh)"
    ;;
esac

brew_install_or_upgrade() {
  if brew_is_installed "$1"; then
    if brew_is_upgradable "$1"; then
      fancy_echo "Upgrading %s ..." "$1"
      brew upgrade "$@"
    else
      fancy_echo "Already using the latest version of %s. Skipping ..." "$1"
    fi
  else
    fancy_echo "Installing %s ..." "$1"
    brew install "$@"
  fi
}

brew_is_installed() {
  brew list -1 | grep -Fqx "$1"
}

brew_is_upgradable() {
  ! brew outdated --quiet "$1" >/dev/null
}

brew_tap_is_installed() {
  brew tap | grep -Fqx "$1"
}

brew_tap() {
  if ! brew_tap_is_installed "$1"; then
    fancy_echo "Tapping $1..."
    brew tap "$1" 2> /dev/null
  fi
}

gem_install_or_update() {
  if gem list "$1" --installed > /dev/null; then
    fancy_echo "Updating %s ..." "$1"
    gem update "$@"
  else
    fancy_echo "Installing %s ..." "$1"
    gem install "$@"
  fi
}

brew_cask_expand_alias() {
  brew cask info "$1" 2>/dev/null | head -1 | awk '{gsub(/:/, ""); print $1}'
}

brew_cask_is_installed() {
  local NAME=$(brew_cask_expand_alias "$1")
  brew cask list -1 | grep -Fqx "$NAME"
}

app_is_installed() {
  local app_name=$(echo "$1" | cut -d'-' -f1)
  find /Applications -iname "$app_name*" -maxdepth 1 | egrep '.*' > /dev/null
}

brew_cask_install() {
  if app_is_installed "$1" || brew_cask_is_installed "$1"; then
    fancy_echo "$1 is already installed. Skipping..."
  else
    fancy_echo "Installing $1..."
    brew cask install "$@"
  fi
}

if ! command -v brew >/dev/null; then
  fancy_echo "Installing Homebrew ..."
    curl -fsSL \
      'https://raw.githubusercontent.com/Homebrew/install/master/install' | ruby

    brew doctor
    # shellcheck disable=SC2016
    append_to_file "$HOME/.zshrc" 'export PATH="/usr/local/bin:$PATH"'
else
  fancy_echo "Homebrew already installed. Skipping ..."
fi

fancy_echo "Updating Homebrew formulas ..."
brew update

brew_install_or_upgrade 'wget'
brew_install_or_upgrade 'git'

brew_tap 'gapple/services'

brew_install_or_upgrade 'qt'

brew_install_or_upgrade 'hub'
# shellcheck disable=SC2016
append_to_file "$HOME/.zshrc" 'eval "$(hub alias -s)"'

#if ! command -v rvm >/dev/null; then
#  fancy_echo 'Installing RVM and the latest Ruby...'
#  curl -L https://get.rvm.io | bash -s stable --ruby --auto-dotfiles --autolibs=enable
#  . ~/.rvm/scripts/rvm
#else
#  local_version="$(rvm -v 2> /dev/null | awk '$2 != ""{print $2}')"
#  latest_version="$(curl -s https://raw.githubusercontent.com/wayneeseguin/rvm/stable/VERSION)"
#  if [ "$local_version" != "$latest_version" ]; then
#    rvm get stable --auto-dotfiles --autolibs=enable
#  else
#    fancy_echo "Already using the latest version of RVM. Skipping..."
#  fi
#fi

#fancy_echo 'Updating Rubygems...'
#gem update --system

#gem_install_or_update 'bundler'

fancy_echo "Configuring Bundler ..."
  number_of_cores=$(sysctl -n hw.ncpu)
  bundle config --global jobs $((number_of_cores - 1))

brew_tap 'caskroom/cask'

brew_install_or_upgrade 'brew-cask'

brew_tap 'caskroom/versions'

brew_cask_install 'iterm2'

brew_install_or_upgrade 'vim'
brew_install_or_upgrade 'tmux'
brew_install_or_upgrade 'reattach-to-user-namespace'

find ../symlinks/ -type d | cpio -pdvm ~/
for file in `find ../symlinks/ -type f`
do
  from=`pwd | sed 's/\/script$//'``echo "$file" | sed 's/^..//'`
  to=$HOME`echo "$file" | sed 's/^\.\.\/symlinks//'`
  cp $from $to
done
brew_install_or_upgrade 'python'
pip install git+git://github.com/Lokaltog/powerline

# powerline fonts
wget https://github.com/Lokaltog/powerline/raw/develop/font/PowerlineSymbols.otf https://github.com/Lokaltog/powerline/raw/develop/font/10-powerline-symbols.conf
mkdir -p ~/.fonts/ && mv PowerlineSymbols.otf ~/.fonts/
fc-cache -vf ~/.fonts
mkdir -p ~/.config/fontconfig/conf.d/ && mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/

# Extra Vundle add ons
git clone https://github.com/fatih/vim-go.git ~/.vim/bundle/vim-go
git clone https://github.com/moll/vim-node.git ~/.vim/bundle/vim-node
git clone git@github.com:leshill/vim-json.git ~/.vim.bundle/vim-json

# vundle
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
vim +BundleInstall +qall

echo "Go to the ~/.fonts folder, and double click the font and install it"
echo "Open your term2 profile and set non-ascii font to powerline font"
#append_to_file "$HOME/.rvmrc" 'rvm_auto_reload_flag=2'

#if [ ! -f "$HOME/.ssh/github_rsa.pub" ]; then
#  open ~/Applications/GitHub.app
#fi
