#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# NVM and Latex will be available inside tmux session
export PNPM_HOME="/home/flisak/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
