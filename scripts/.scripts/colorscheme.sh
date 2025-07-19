#!/bin/sh

# Theme is changed by making a symbolic link for one of available colorschemes
# Theme is applied to:
# - foot
# - tmux
# - mako
# - waybar
# - sway

# Each app on the list above has "themes" folder

# Currently available themes are:
# - catppuccin-mocha

apply_colorscheme () {
  # First parameter is a config directory
  # Second is the theme name
  # Third is the extension
  cd ${1}
  ln -sf themes/${2}.${3} current.${3}
}
themes="catppuccin-mocha\n"
theme=$(echo $themes | fzf)

if [ -n $theme ]; then
  apply_colorscheme ~/.config/tmux $theme conf
  apply_colorscheme ~/.config/mako $theme conf
  apply_colorscheme ~/.config/sway $theme conf
  apply_colorscheme ~/.config/foot $theme ini
  apply_colorscheme ~/.config/waybar $theme css
fi
