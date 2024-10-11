#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias sb="source ~/.bashrc"
alias yta='yt-dlp -x --audio-quality 0 --audio-format opus'

# play videos with mpv from playlist file
function mpvp () {
    VIDEOS_DIR="$(xdg-user-dir VIDEOS)"

    cd ${VIDEOS_DIR}
    pfile="$(find . -name "playlist.txt" | fzf)"

    if [ -e "${pfile}" ]; then
        mpv --save-position-on-quit --playlist=${pfile}
    else
        echo "Playlist file does not exist."
    fi
}

# compile latex document to pdf
alias lm='latexmk -pdf -pvc -output-directory=output main.tex'

# void specific aliases
alias reboot='loginctl reboot'
poweroff () {
    # This will also poweroff raspberry server
    # ssh home 'sudo poweroff'
    loginctl poweroff
}

# git
alias gs='git status'
alias gd='git diff'
alias gc='git commit'
alias gr='git remote --verbose'
alias gl='git log --oneline --graph'
alias gb='git branch -a --column'
alias glc="git log --oneline --graph | wc -l"
alias gss='git switch'

# python's virtual environments
alias activate='source .venv/bin/activate'
alias mkenv='python -m venv .venv'

# tmux
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


PROMPT_COMMAND='PS1_CMD1=$(git branch --show-current 2>/dev/null)'
PS1='\[\e[93m\][\u\[\e[0m\]@\[\e[95m\]\H]\[\e[0m\] \[\e[96m\]\w\[\e[0m\] \[\e[91m\]${PS1_CMD1}\[\e[0m\] \$ '

export PATH="${PATH}:${HOME}/.scripts/"
export GPG_TTY=$(tty)
export EDITOR='nvim'
# start sway session
if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
  exec dbus-run-session sway
fi
