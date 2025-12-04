#!/bin/bash

# NOTE: This installation script is for Void Linux only, if you wish to use
# it you have to change the script, especially things like:
# - package names and package manager used
# - how system services are activated
# - remove some sections (ie. pipewire or bitmap fonts sections are not 
#   necessary on systems like Arch Linux)

CONFIGURE_BITMAP_FONTS=1
CONFIGURE_GROUPS=1
CONFIGURE_PIPEWIRE=1
COPY_DOTFILES=1
CREATE_XDG_USER_DIRS=1
DOWNLOAD_NERD_FONTS=1
INSTALL_PACKAGES=1
INSTALL_PNPM=1
INSTALL_NIX=1
# If you decide to use neovim from flake, nix has to be enabled
INSTALL_NEOVIM_FLAKE=1
INSTALL_GPU_SCREEN_RECORDER=1
START_SERVICES=1
SETUP_AUTOLOGIN=1

################################################################################

here="$(pwd)"

# List of packages to install
web_browsers='qutebrowser qt5-wayland qt6-wayland firefox python3-adblock'
system='xorg xorg-server-xwayland xwayland-satellite xdg-user-dirs connman cronie pipewire libjack-pipewire pamixer pavucontrol brightnessctl wireplumber wl-clipboard libnotify'
terminals='foot'
tools='fzf ripgrep lf imv tree zip unzip tmux python3-tmuxp curl wget htop stow ffmpeg socklog-void tree-sitter-devel pinentry-qt'
misc='zathura zathura-pdf-mupdf mpv mpc mpd ncmpcpp xdg-desktop-portal xdg-desktop-portal-gnome xdg-desktop-portal-gtk'
window_managers='polkit elogind swaylock swayidle'
development='base-devel openssh gnupg pandoc git meson ninja'
gpu_recorder='mesa mesa-vaapi mesa-vdpau mesa-vulkan-intel mesa-vulkan-overlay-layer mesa-vulkan-radeon wayland-scanner++ wayland-devel wayland-utils wayland-protocols libdbus-c++ libdbus-c++-devel libva-devel libdrm-devel Vulkan-Headers libglvnd-devel libcap-devel libavcodec ffmpeg-devel libXcomposite-devel libXrandr-devel libXdamage-devel pulseaudio-devel pipewire-devel intel-media-driver'
niri='cliphist quickshell ddcutil brightnessctl niri wlsunset evolution-data-server polkit-kde-agent power-profiles-daemon upower'

if [ "${INSTALL_PACKAGES}" = 1 ]; then
  sudo xbps-install -Su
  sudo xbps-install ${web_browsers} ${misc} ${window_managers} ${terminals} ${system} ${tools} ${development} ${gpu_recorder} ${niri}
fi

if [ "${INSTALL_PNPM}" = 1 ]; then
  curl -fsSL https://get.pnpm.io/install.sh | sh -
fi

if [ "${INSTALL_NIX}" = 1 ]; then
  sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --no-daemon
  mkdir -p ~/.config/nix
  echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf
  if [ -e /home/${USER}/.nix-profile/etc/profile.d/nix.sh ]; then . /home/${USER}/.nix-profile/etc/profile.d/nix.sh; fi

  if [ "${INSTALL_NEOVIM_FLAKE}" = 1 ]; then
    nix profile add github:flisakl/neovim.nix
  fi

fi

if [ "${DOWNLOAD_NERD_FONTS}" = 1 ]; then
  mkdir ~/.local/share/fonts/CaskaydiaMono -p
  cd ~/.local/share/fonts/CaskaydiaMono/
  wget -O fonts.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/CascadiaMono.zip
  unzip fonts.zip && rm fonts.zip
  cd ${here}
fi

function service {
  path="/var/service/${1}"

  if [ "${2}" = "disable" ]; then
    if [ -e "${path}" ]; then
      sudo rm ${path}
    fi
  else
    sudo ln -s /etc/sv/${1} /var/service/
  fi
}

if [ "${START_SERVICES}" = 1 ]; then
  # I'm assuming it's fresh installation and you're using connman to manage your internet connection
  # because of that any other program managing network must be disabled
  service dhcpcd disable
  service wpa_supplicant disable
  service connmand enable
  service  power-profiles-daemon enable
  #service docker enable
  service cronie enable
  service dbus enable
  service socklog-unix enable
  service nanoklogd enable
fi

if [ "${CONFIGURE_GROUPS}" = 1 ]; then
  sudo usermod -a -G socklog,network ${USER}
fi

if [ "${CONFIGURE_PIPEWIRE}" = 1 ]; then
  sudo mkdir -p /etc/pipewire/pipewire.conf.d
  sudo ln -s /usr/share/examples/wireplumber/10-wireplumber.conf /etc/pipewire/pipewire.conf.d/
  sudo ln -s /usr/share/examples/pipewire/20-pipewire-pulse.conf /etc/pipewire/pipewire.conf.d/
fi

if [ "${CONFIGURE_BITMAP_FONTS}" = 1 ]; then
  sudo ln -s /usr/share/fontconfig/conf.avail/70-no-bitmaps-except-emoji.conf /etc/fonts/conf.d/
  sudo xbps-reconfigure -f fontconfig
fi

if [ "${COPY_DOTFILES}" = 1 ]; then
  # Copy dotfiles files
  rm ~/.bash*
  if [ -e "~/.config" ]; then
    rm ~/.config -r
  fi
  cd $here
  stow -t ~ $(ls -d */)
fi

if [ "${CREATE_XDG_USER_DIRS}" = 1 ]; then
  cd ~
  awk '{ match($0, /HOME\/([A-Za-z\/]+)/, groups); if (groups[1] != "") print groups[1] }' ~/.config/user-dirs.dirs | xargs mkdir -p
fi


if [ "${INSTALL_GPU_SCREEN_RECORDER}" = 1 ]; then
  mkdir -p ~/repositories
  git clone https://repo.dec05eba.com/gpu-screen-recorder ~/repositories/gpu-screen-recorder
  cd ~/repositories/gpu-screen-recorder
  meson setup build
  meson install -C build
fi


# Install my fork of noctalia-shell
git clone https://github.com/flisakl/noctalia-shell ~/.config/quickshell

if [ "${SETUP_AUTOLOGIN}" = 1 ]; then
  sudo cp -r /etc/sv/agetty-tty1 /etc/sv/agetty-autologin-tty1
  sudo sed -i "s/--noclear/--noclear --autologin ${USER}/" /etc/sv/agetty-autologin-tty1/conf
  service agetty-tty1 disable
  service agetty-autologin-tty1 enable
fi
