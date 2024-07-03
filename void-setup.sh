#!/bin/bash

# List of packages to install
web_browsers='qutebrowser qt5-wayland qt6-wayland firefox python3-adblock'
system='xorg xorg-server-xwayland xdg-user-dirs'
terminals='foot'
tools='fzf ripgrep lf imv tree zip unzip tmux python3-tmuxp'
misc='zathura zathura-pdf-mupdf'
window_managers='polkit sway elogind swaybg swaylock swayidle Waybar'
development='base-devel neovim'

# Packages
sudo xbps-install -Su
sudo xbps-install ${web_browsers} ${window_managers} ${terminals} ${system} ${tools} ${development}

# Services
sudo rm /var/service/dhcpd
sudo rm /var/service/wpa_supplicant
sudo ln -s /etc/sv/connmand /var/service
sudo ln -s /etc/sv/docker /var/service
sudo ln -s /etc/sv/cronie /var/service
sudo ln -s /etc/sv/dbus /var/service

# Pipewire
sudo mkdir -p /etc/pipewire/pipewire.conf.d
sudo ln -s /usr/share/examples/wireplumber/10-wireplumber.conf /etc/pipewire/pipewire.conf.d/
sudo ln -s /usr/share/examples/pipewire/20-pipewire-pulse.conf /etc/pipewire/pipewire.conf.d/

# Copy dotfiles files
# XDG User dirs
# GPG and SSH keys
