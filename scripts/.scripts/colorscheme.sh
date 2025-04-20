#!/bin/sh

SCHEME_FILE="${HOME}/.cache/colorscheme"

if [ -e "${SCHEME_FILE}" ]; then
    current=$(cat ${SCHEME_FILE})
else
    current="kanagawa"
fi

cd $(xdg-user-dir WALLPAPERS)
choice=$(ls -1d * | wofi -d)

if [ -n "${choice}" ]; then
    echo "${choice}" > ${SCHEME_FILE}
    wal --iterative -qi "$(xdg-user-dir WALLPAPERS)/$(head -n 1 $SCHEME_FILE)"
    sed -i "s/${current}/${choice}/" ~/.config/nvim/init.lua ~/.config/foot/foot.ini
fi
