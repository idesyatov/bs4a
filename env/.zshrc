# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
export EDITOR=vim

ZSH_THEME="gentoo"

plugins=(git docker sudo colored-man-pages colorize)

HISTFILESIZE=10000
HISTSIZE=10000

setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt INC_APPEND_HISTORY

autoload -U compinit && compinit
unsetopt menu_complete
setopt completealiases

if [ -f ~/.aliases ]; then
  source ~/.aliases
fi

source $ZSH/oh-my-zsh.sh
