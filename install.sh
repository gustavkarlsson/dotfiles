#!/bin/bash

# Install packages
sudo apt-get update
sudo apt-get install \
    bat \
    tree \
    git \
    vim \
    wget \
    curl \
    less \
    ssh \
    zsh \
    qemu-kvm \
    libvirt-daemon-system \
    libvirt-clients \
    bridge-utils \
    dtrx \
    python3-dev \
    python3-pip \
    python3-setuptools \
    ruby-full \
    fonts-hack-ttf \
    dconf-cli \
    unrar \
    unzip \
    ubuntu-restricted-extras \
    ttf-mscorefonts-installer \
    fonts-noto-color-emoji \
    snapd \
    apt-transport-https \
    ca-certificates \
    gnupg-agent \
    software-properties-common    

# Install snaps
sudo snap install --classic android-studio
sudo snap install --classic intellij-idea-community
sudo snap install --classic slack
sudo snap install --classic code
sudo snap install vlc

# Install thefuck
sudo pip3 install thefuck

# Install docker
sudo sh -c "$(curl -fsSL https://get.docker.com)"
sudo usermod -aG docker `id -un`

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Setup KVM
sudo adduser `id -un` libvirt
sudo adduser `id -un` kvm

# Install SDKMAN
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install java 8.0.232.fx-zulu
sdk install gradle
sdk install kotlin

# Install ktlint
mkdir -p ~/bin
cd ~/bin
curl -sSLO https://github.com/shyiko/ktlint/releases/download/0.36.0/ktlint && chmod a+x ktlint
cd ~

# Install jetbrains mono font
mkdir -p "$HOME/.fonts" &&
    wget https://download.jetbrains.com/fonts/JetBrainsMono-1.0.0.zip -O jetbrains-mono-font.zip &&
    unzip -o jetbrains-mono-font.zip -d "$HOME/.fonts" &&
    sudo fc-cache -f -v
rm jetbrains-mono-font.zip

# Clone all git repos
mkdir ~/Development
cd ~/Development
curl "https://api.github.com/users/gustavkarlsson/repos?page=1&per_page=100" |
    grep -e 'ssh_url*' |
    cut -d \" -f 4 |
    xargs -L1 git clone --recurse-submodules
cd ~

# Link dotfiles
cd ~/Development/dotfiles
./link_dotfiles.sh
cd ~

# Change to ZSH
chsh -s /usr/bin/zsh `id -un`
