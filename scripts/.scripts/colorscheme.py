#!/usr/bin/python

import subprocess
import argparse
import os
import sys
import datetime
import random
import json

sunset_file = "/tmp/sunset.json"
theme_file = os.path.expanduser("~/.cache/theme.json")
theme_directory = os.path.expanduser("~/.config/foot/themes")

latitude = None
longtitude = None
timezone = None

theme = None
variant = None
initial_theme = None
initial_variant = None

if os.path.exists(theme_file):
    with open(theme_file, "r") as f:
        data = json.load(f)
        initial_theme, initial_variant = data["theme"], data["variant"]
        latitude = data.get("latitude")
        longtitude = data.get("longtitude")
        timezone = data.get("timezone")
else:
    initial_theme = "catppuccin"
    initial_variant = "dark"


parser = argparse.ArgumentParser(
    "colorscheme.py",
    description="Apply colorschemes to many programs at once",
    add_help=True
)

parser.add_argument(
    '--sunset', help='switch between dark and light mode based on sunset',
    action='store_true')
parser.add_argument(
    '--toggle', help='switch from dark to light mode and vice versa',
    action='store_true')
parser.add_argument(
    '--dark', help='apply dark version of colorscheme', action='store_true')
parser.add_argument(
    '--light', help='apply light version of colorscheme', action='store_true')
parser.add_argument(
    '-l', '--list', help='list available colorschemes', action='store_true')
parser.add_argument(
    'colorscheme', help='name of the colorscheme to apply', nargs='?',
    default=None)

arguments = parser.parse_args()

if all([arguments.dark, arguments.light]):
    sys.exit("Pick either dark or light variant")
if all([arguments.toggle,
        any([arguments.dark, arguments.light, arguments.sunset])]):
    sys.exit(
        "--toggle option is mutually exclusive with --dark and --light options"
    )

colorschemes = os.listdir(theme_directory)


if arguments.list:
    print("Available colorschemes:")

    for c in colorschemes:
        print("*", c)

    sys.exit(0)

if arguments.dark:
    variant = "dark"

if arguments.light:
    variant = "light"

if arguments.sunset:

    if not any([latitude, longtitude, timezone]):
        sys.exit(
            "timezone, latitude and longtitude are required to use --sunset")

    if not os.path.exists(sunset_file):
        import requests

        params = {
            "lat": latitude,
            "lng": longtitude,
            "formatted": 1,
            "tzid": timezone
        }
        response = requests.get("https://api.sunrise-sunset.org/json", params)
        json_data = response.json()

        if json_data["status"] == "OK":
            json_data = json_data["results"]
            with open(sunset_file, "w") as f:
                json.dump(json_data, f)
        else:
            sys.exit("Invalid request or API is down")
    else:
        with open(sunset_file, "r") as f:
            json_data = json.load(f)

    now = datetime.datetime.now().time()
    fmt = "%I:%M:%S %p"
    sunrise = datetime.datetime.strptime(
        json_data["sunrise"], fmt).time()
    sunset = datetime.datetime.strptime(
        json_data["sunset"], fmt).time()

    if now >= sunrise and now < sunset:
        variant = "light"
    else:
        variant = "dark"


theme = initial_theme if not theme else theme
variant = initial_variant if not variant else variant

if arguments.toggle:
    variant = "dark" if variant == "light" else "light"

if arguments.colorscheme:
    theme = arguments.colorscheme

    if theme not in colorschemes:
        sys.exit("Invalid colorscheme")


def find_file(path: str, theme: str, variant: str):
    full_path = os.path.expanduser(path)
    p = os.path.join(full_path, "themes/", theme)
    filename = None

    for f in os.listdir(p):
        if variant in f:
            filename = f

    return os.path.join(p, filename) if filename else None


def create_symlink(target_path: str, source_path: str):
    full_path = os.path.expanduser(target_path)
    bname = os.path.splitext(source_path)

    if len(bname) == 2:
        target = f"current{bname[1]}"
    else:
        target = "current"

    os.symlink(source_path, "dud")
    os.rename("dud", os.path.join(full_path, target))


def change_wallpaper(variant: str):
    with open(os.path.expanduser("~/.config/user-dirs.dirs"), "r") as f:
        lines = f.readlines()
        for line in lines:
            if "WALLPAPER" in line:
                _, wallpaper_dir = line.split("=")
                wallpaper_dir = os.path.expanduser(
                    wallpaper_dir.replace('"', '').replace(
                        "$HOME", "~").strip()
                )

    os.chdir(os.path.expanduser(wallpaper_dir))
    files = os.listdir(os.path.join(os.getcwd(), variant))
    file = files[random.randint(0, len(files) - 1)]
    source = os.path.join(os.getcwd(), variant, file)
    create_symlink(os.getcwd(), source)


# Update theme file
if any([initial_theme != theme, initial_variant != variant]):

    print("Updating theme file")
    with open(theme_file, "w") as f:
        data = json.dump(
            {
                "theme": theme,
                "variant": variant,
                "latitude": latitude,
                "longtitude": longtitude,
                "timezone": timezone
            }, f)

    directories = [
        "~/.config/foot",
        "~/.config/sway",
        "~/.config/waybar",
        "~/.config/tmux",
        "~/.config/wofi",
        "~/.config/mako",
    ]

    for d in directories:
        file = find_file(d, theme, variant)
        if file:
            create_symlink(d, file)

    # Change wallpaper when variant has changed
    if initial_variant != variant:
        change_wallpaper(variant)

    if variant == "dark":
        subprocess.Popen(['pkill', '-USR2', 'foot'])
    else:
        subprocess.Popen(['pkill', '-USR1', 'foot'])

    # Make applications reload their config files
    subprocess.Popen(['makoctl', 'reload'])
    subprocess.Popen(['pkill', '-USR1', 'nvim'])
    subprocess.Popen(['swaymsg', 'reload'])
    process = subprocess.Popen(
        ['tmux', 'source-file',
         os.path.expanduser('~/.config/tmux/tmux.conf')])
