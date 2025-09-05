#!/bin/sh

variant_file="${HOME}/.cache/theme_variant"

if [ -f "${variant_file}" ]; then
  variant=$(cat ${variant_file})
else
  variant="dark"
fi

if [ "${variant}" = "dark" ]; then
  variant="light"
else
  variant="dark"
fi

echo "${variant}" > ${variant_file}

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
sh "$SCRIPT_DIR/wallpaper.sh"
sh "$SCRIPT_DIR/colorscheme.sh" "no"
swaymsg reload
