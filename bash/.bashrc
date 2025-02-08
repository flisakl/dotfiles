#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias sb="source ~/.bashrc"
alias yta='yt-dlp -x --audio-quality 0 --audio-format opus'

# Play videos with mpv from playlist file
function mpvp () {
    VIDEOS_DIR="$(xdg-user-dir VIDEOS)"

    cd ${VIDEOS_DIR}
    pfile="$(find . -name "*.txt" | fzf)"

    if [ -e "${pfile}" ]; then
        mpv --save-position-on-quit --playlist=${pfile}
    else
        echo "Playlist file does not exist."
    fi
}

# Compile latex document to pdf
alias lm='latexmk -pdf -pvc -output-directory=output main.tex'

# Void Linux specific aliases
alias reboot='loginctl reboot'
alias poweroff='loginctl poweroff'

# Git related aliases
alias gs='git status'
alias gd='git diff'
alias gc='git commit'
alias gr='git remote --verbose'
alias gl='git log --oneline --graph'
alias gb='git branch -a --column'
alias glc="git log --oneline --graph | wc -l"
alias gss='git switch'

# Activate Python virtual environment
alias activate='source .venv/bin/activate'

# Create Python virtual environment and install packages from "requirements.txt"
mkenv () {
    python -m venv .venv
    source .venv/bin/activate
    pip install -U pip
    if [[ -f "requirements.txt" ]]; then
        pip install -r requirements.txt
    fi
}

# Tmux & tmuxp aliases
alias ta='tmux attach'
alias tks='tmux kill-server'
tl () {
    cd ~/.tmuxp
    session="$(fzf)"
    if [ -n "${session}" ]; then
        tmuxp load $session
    else
        cd -
    fi
}


# Custom colored prompt with current git branch appended
PROMPT_COMMAND='PS1_CMD1=$(git branch --show-current 2>/dev/null)'
PS1='\[\e[93m\][\u\[\e[0m\]@\[\e[95m\]\H]\[\e[0m\] \[\e[96m\]\w\[\e[0m\] \[\e[91m\]${PS1_CMD1}\[\e[0m\] \$ '

export PATH="${PATH}:${HOME}/.scripts/"
export GPG_TTY=$(tty)
export EDITOR='nvim'

# Start sway session
if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
  exec dbus-run-session sway
fi
