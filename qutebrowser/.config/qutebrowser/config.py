import os
from urllib.request import urlopen
from qutebrowser.config.configfiles import ConfigAPI  # noqa: F401
from qutebrowser.config.config import ConfigContainer  # noqa: F401
config: ConfigAPI = config  # noqa: F821 pylint: disable=E0602,C0103
c: ConfigContainer = c  # noqa: F821 pylint: disable=E0602,C0103

# Disable passthrough mode
config.unbind('<Ctrl-v>')
config.bind("<Ctrl-n>", "prompt-item-focus next", "prompt")
config.bind("<Ctrl-p>", "prompt-item-focus prev", "prompt")
config.bind("<Ctrl-r>", "config-source", "normal")

c.content.autoplay = False
c.downloads.position = "bottom"
c.downloads.remove_finished = 10000
c
c.fonts.default_family = "CaskaydiaMono Nerd Font"
c.fonts.default_size = "14px"
c
c.scrolling.bar = "always"
c.url.searchengines = {
    "DEFAULT": "https://duckduckgo.com/?q={}",
    "dj": "https://docs.djangoproject.com/en/dev/search/?q={}",
    "yt": "https://www.youtube.com/results?search_query={}",
    "br": "https://wikibr.pl/index.php?search={}",
    "aa": "https://annas-archive.org/search?&ext=epub&q={}"
}


# Load catppuccin theme
config.load_autoconfig(False)

if not os.path.exists(config.configdir / "theme.py"):
    theme = "https://raw.githubusercontent.com/catppuccin/qutebrowser/main/setup.py"
    with urlopen(theme) as themehtml:
        with open(config.configdir / "theme.py", "a") as file:
            file.writelines(themehtml.read().decode("utf-8"))

if os.path.exists(config.configdir / "theme.py"):
    import theme
    theme.setup(c, 'mocha', True)
