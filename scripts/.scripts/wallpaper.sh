#!/bin/sh

variant_file="${HOME}/.cache/theme_variant"

if [ -f "${variant_file}" ]; then
  variant=$(cat ${variant_file})
else
  variant="dark"
  echo "${variant}" > ${variant_file}
fi

cd "$(xdg-user-dir WALLPAPERS)/${variant}"

files=$(find . -maxdepth 1 -type f -printf "%f\n")

# Convert list to an array
set -- $files
num_files=$#

# Exit if no files
[ "$num_files" -eq 0 ] && { echo "No files in directory"; exit 1; }

# Get current day of month (01 to 31)
day=$(date +%d)

# Remove leading zero to avoid octal interpretation
day=$(expr "$day" + 0)

# Compute index (0-based)
index=$((day % num_files))

filename=""
# Get the file at computed index
i=0
for file in "$@"; do
    [ "$i" -eq "$index" ] && { filename="$file"; break; }
    i=$((i + 1))
done

ln -sf ${variant}/${filename} ../current.png
