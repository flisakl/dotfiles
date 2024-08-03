#!/bin/bash

# Install lutris + drivers for Intel and Radeon + wine dependencies

sudo xbps-install void-repo{,-multilib}-nonfree
sudo xbps-install -Su
sudo xbps-install wine{,-devel}
sudo xbps-install {mesa-vulkan-intel,mesa-vulkan-radeon,MesaLib-devel,alsa-lib-devel,alsa-plugins,libpulseaudio}{,-32bit} {vulkan-loader,v4l-utils,sqlite,SDL2,ocl-icd,libXcomposite,libva,alsa-lib,giflib,gnutls,gst-plugins-base1,libgamemode}{,-devel}{,-32bit} gamemode lutris
