#!/bin/bash

# NOTE: This installation script is for Void Linux only, if you wish to use
# it you have to change the script, things like:
# - package names and package manager used
# - how system services are activated
# - remove some sections (ie pipewire or bitmap fonts sections are not 
#   necessary on systems like Arch Linux)

COPY_DOTFILES=1
INSTALL_PACKAGES=1
INSTALL_NVM=1
DOWNLOAD_NERD_FONTS=1
START_SERVICES=1
CONFIGURE_GROUPS=1
CONFIGURE_PIPEWIRE=1
CONFIGURE_BITMAP_FONTS=1
CREATE_XDG_USER_DIRS=1

################################################################################

here="$(pwd)"

# List of packages to install
web_browsers='qutebrowser qt5-wayland qt6-wayland firefox python3-adblock'
system='xorg xorg-server-xwayland xdg-user-dirs connman cronie pipewire libjack-pipewire pamixer pavucontrol brightnessctl mako wireplumber wl-clipboard bemenu'
terminals='foot'
tools='fzf ripgrep lf imv tree zip unzip tmux python3-tmuxp curl wget htop grimshot stow ffmpeg socklog-void tree-sitter-devel'
misc='zathura zathura-pdf-mupdf mpv mpc mpd ncmpcpp yt-dlp pywal xdg-desktop-portal xdg-desktop-portal-wlr'
window_managers='polkit sway elogind swaybg swaylock swayidle Waybar'
development='base-devel neovim docker docker-compose docker-buildx openssh gnupg pandoc git'

if [ "${INSTALL_PACKAGES}" = 1 ]; then
    sudo xbps-install -Su
    sudo xbps-install ${web_browsers} ${misc} ${window_managers} ${terminals} ${system} ${tools} ${development}
fi

if [ "${INSTALL_NVM}" = 1 ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi

if [ "${DOWNLOAD_NERD_FONTS}" = 1 ]; then
    mkdir ~/.local/share/fonts -p
    cd ~/.local/share/fonts
    wget -O fonts.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/CascadiaCode.zip
    unzip fonts.zip && rm fonts.zip
    cd ${here}
fi

function disable_service {
    path="/var/service/${1}"
    if [ -e "${path}" ]; then
	sudo rm ${path}
    fi
}

function enable_service {
    path="/etc/sv/${1}"
    if [ -e "${path}" ]; then
	sudo ln -s ${path} /var/service
    fi
}

if [ "${START_SERVICES}" = 1 ]; then
    # I'm assuming it's fresh installation and you're using connman to manage your internet connection
    # because of that any other program managing network must be disabled
    disable_service dhcpcd
    disable_service wpa_supplicant
    enable_service connmand
    enable_service docker
    enable_service cronie
    enable_service dbus
    enable_service socklog-unix
    enable_service nanoklogd
fi

if [ "${CONFIGURE_GROUPS}" = 1 ]; then
    sudo usermod -a -G docker,socklog,network ${USER}
fi

if [ "${CONFIGURE_PIPEWIRE}" = 1 ]; then
    sudo mkdir -p /etc/pipewire/pipewire.conf.d
    sudo ln -s /usr/share/examples/wireplumber/10-wireplumber.conf /etc/pipewire/pipewire.conf.d/
    sudo ln -s /usr/share/examples/pipewire/20-pipewire-pulse.conf /etc/pipewire/pipewire.conf.d/
fi

if [ "${CONFIGURE_BITMAP_FONTS}" = 1 ]; then
    sudo ln -s /usr/share/fontconfig/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d/
    sudo xbps-reconfigure -f fontconfig
fi

if [ "${COPY_DOTFILES}" = 1 ]; then
    # Copy dotfiles files
    rm ~/.bash*
    rm ~/.config
    cd $here
    stow -t ~ $(ls -d */)
fi

if [ "${CREATE_XDG_USER_DIRS}" = 1 ]; then
    cd ~
    awk '{ match($0, /HOME\/([A-Za-z\/]+)/, groups); if (groups[1] != "") print groups[1] }' ~/.config/user-dirs.dirs | xargs mkdir -p
fi
