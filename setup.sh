#!/bin/bash

sudo apt update && sudo apt upgrade

# Install Kitty
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/

# Install Nerd Fonts
mkdir -p ~/.local/share/fonts/
wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Regular/HackNerdFontMono-Regular.ttf
wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/ComicShannsMono/ComicShannsMonoNerdFont-Regular.otf
fc-cache -fv

# System wide packages
systemPackagesArray=(
  'git'
  'ripgrep'
  'xsel'
  'xclip'
  'wl-clipboard'
  'curl'
  'cargo'
  'clang-format'
  'python3-pip'
)

# Node packages
npmPackagesArrayG=(
  "neovim"
  "prettier"
)

# Python packages
pipPackagesArray=(
  "black"
  "beautysh"
)

for package in "${systemPackagesArray[@]}"; do
  sudo apt install "$package" -y
done

# Install NodeJs (20x)
curl -fsSL https://deb.nodesource.com/setup_20.x -o nodesource_setup.sh
sudo -E bash nodesource_setup.sh
sudo apt-get install -y nodejs
node -v

for package in "${npmPackagesArrayG[@]}"; do
  sudo npm install -g "$package"
done

for package in "${pipPackagesArray[@]}"; do
  sudo pip3 install "$package"
done

sudo apt autoremove

echo "Do you want to install neovim? (y/n)"
read input

if [ "$input" = "y" ]; then
  git clone https://github.com/neovim/neovim ~/neovim
  cd ~/neovim
  make CMAKE_BUILD_TYPE=Release
  sudo make install

  echo "Installing the config"
  git clone https://github.com/PiyushDuggal-source/neovim ~/.config/nvim
  nvim +PackerSync
fi
