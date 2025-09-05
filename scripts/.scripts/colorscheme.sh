#!/bin/sh

apply_colorscheme () {
  cd ${1}
  ln -sf themes/${2}/${3}.${4} current.${4}
}
cd ~/.config/foot/themes

variant_file="${HOME}/.cache/theme_variant"
theme_file="${HOME}/.cache/theme_name"

if [ -f "${variant_file}" ]; then
  variant=$(cat ${variant_file})
else
  variant="dark"
  echo "${variant}" > ${variant_file}
fi

if [ "${1}" = "no" ]; then

  if [ -f "${theme_file}" ]; then
    theme=$(cat $theme_file)
  else
    theme="catppuccin"
  fi

else
  theme=$(ls | wofi --show=dmenu -p "Choose theme")
fi

if [ -n $theme ]; then
  echo ${theme} > ${theme_file}
  apply_colorscheme ~/.config/tmux $theme $variant conf
  apply_colorscheme ~/.config/mako $theme $variant conf
  apply_colorscheme ~/.config/sway $theme $variant conf
  apply_colorscheme ~/.config/foot $theme $variant ini
  apply_colorscheme ~/.config/waybar $theme $variant css
fi
