#!/bin/bash

sudo apt update && sudo apt upgrade

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

npmPackagesArrayG=(
    "neovim"
    "prettier"
)

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


