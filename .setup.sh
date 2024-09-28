#!/bin/bash

here="$(pwd)"

# List of packages to install
web_browsers='qutebrowser qt5-wayland qt6-wayland firefox python3-adblock'
system='xorg xorg-server-xwayland xdg-user-dirs connman cronie pipewire libjack-pipewire pamixer pavucontrol brightnessctl mako wireplumber wl-clipboard bemenu'
terminals='foot'
tools='fzf ripgrep lf imv tree zip unzip tmux python3-tmuxp curl wget htop grimshot stow ffmpeg socklog-void'
misc='zathura zathura-pdf-mupdf mpv mpc mpd ncmpcpp yt-dlp'
window_managers='polkit sway elogind swaybg swaylock swayidle Waybar'
development='base-devel neovim docker docker-compose openssh gnupg pandoc git'

# Packages
sudo xbps-install -Su
sudo xbps-install ${web_browsers} ${misc} ${window_managers} ${terminals} ${system} ${tools} ${development}

# Node version manager (for some neovim language servers)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# Nerd fonts
mkdir ~/.local/share/fonts -p
cd ~/.local/share/fonts
wget -O fonts.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/CascadiaCode.zip
unzip fonts.zip && rm fonts.zip
cd ${here}

# Services
sudo rm /var/service/dhcpcd
sudo rm /var/service/wpa_supplicant
sudo ln -s /etc/sv/connmand /var/service
sudo ln -s /etc/sv/docker /var/service
sudo ln -s /etc/sv/cronie /var/service
sudo ln -s /etc/sv/dbus /var/service
sudo ln -s /etc/sv/socklog-unix /var/service
sudo ln -s /etc/sv/nanoklogd /var/service

# Groups
sudo usermod -a -G docker,socklog ${USER}

# Pipewire
sudo mkdir -p /etc/pipewire/pipewire.conf.d
sudo ln -s /usr/share/examples/wireplumber/10-wireplumber.conf /etc/pipewire/pipewire.conf.d/
sudo ln -s /usr/share/examples/pipewire/20-pipewire-pulse.conf /etc/pipewire/pipewire.conf.d/

# Disable bitmap fonts
sudo ln -s /usr/share/fontconfig/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d/
sudo xbps-reconfigure -f fontconfig

# Copy dotfiles files
rm ~/.bash*
cd $here
stow -t ~ *

# XDG User dirs
cd
awk '{ match($0, /HOME\/([A-Za-z\/]+)/, groups); if (groups[1] != "") print groups[1] }' ~/.config/user-dirs.dirs | xargs mkdir -p
