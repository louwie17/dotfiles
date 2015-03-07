#! /bin/sh

# File:      install.sh
# Author:    louwie17
# Date:      2015-03-03
# Version:   1.0

# Purpose:
# Install the essential terminal tools for OSX

if [ `whoami` = root ]
then
  echo 'Please execute the script as a normal user.'
  exit
fi

if [ `find -maxdepth 1 -name 'install.sh' | wc -l` -ne 1 ]
then
  echo 'Expected to find install.sh in current directory.'
  echo 'Please run from within the script directory.'
  exit
fi

# Install the Xcode development files
xcode-select --install

# Install Homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew doctor
brew update

brew install wget
# Intall git
#brew install git
# Install RVM
# curl -L https://get.rvm.io | bash -s stable --auto-dotfiles --autolibs=enable --rails

sudo apt-get install arandr chromium-browser curl deluge emacs git gitk oracle-java7-installer libreoffice mkvtoolnix mkvtoolnix-gui python-pip rar skippy-xd tilda tmux vim-gnome vlc xclip zsh

# symlink function (link $1 to $2)
link() {
  from="$1"
  to="$2"
  echo "Linking '$from' to '$to'"
  ln -s "$from" "$to" --backup
}

# create folder structure for symlinks
cd ../symlinks
find . -type d | cpio -pdvm ~/
cd ../script

# link everything in symlinks folder
for file in `find ../symlinks/ -type f`
do
  from=`pwd | sed 's/\/script$//'``echo "$file" | sed 's/^..//'`
  to=$HOME`echo "$file" | sed 's/^\.\.\/symlinks//'`
  link $from $to
done

# openbox
openbox --reconfigure

# oh-my-zsh
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
chsh -s /bin/zsh

# tmux
tmux source-file ~/.tmux.conf

# powerline
pip install --user git+git://github.com/Lokaltog/powerline

# powerline fonts
wget https://github.com/Lokaltog/powerline/raw/develop/font/PowerlineSymbols.otf https://github.com/Lokaltog/powerline/raw/develop/font/10-powerline-symbols.conf
mkdir -p ~/.fonts/ && mv PowerlineSymbols.otf ~/.fonts/
fc-cache -vf ~/.fonts
mkdir -p ~/.config/fontconfig/conf.d/ && mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/

# vundle
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
vim +BundleInstall +qall
