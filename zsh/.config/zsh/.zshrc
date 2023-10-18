#!/bin/sh

# source ~/.oh-my-zsh/lib/completion.zsh
# source ~/.oh-my-zsh/lib/history.zsh
# source ~/.oh-my-zsh/lib/key-bindings.zsh>

# some useful options (man zshoptions)
setopt autocd extendedglob nomatch menucomplete
setopt interactive_comments
stty stop undef		# Disable ctrl-s to freeze terminal.
zle_highlight=('paste:none')
unsetopt BEEP # beeping is annoying

# history
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.cache/zsh/.zsh_history"
[ "$HISTSIZE" -lt 50000 ] && HISTSIZE=50000
[ "$SAVEHIST" -lt 10000 ] && SAVEHIST=10000

setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt share_history          # share command history data

# completions
if [[ -z "$ZSH_COMPDUMP" ]]; then
  ZSH_COMPDUMP="$HOME/.cache/zsh/.zcompdump"
fi
autoload -Uz compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]-_}={[:upper:][:lower:]_-}' 'r:|=*' 'l:|=* r:|=*'
zmodload zsh/complist
compinit -d $ZSH_COMPDUMP
_comp_options+=(globdots)		# Include hidden files.

# keybindings
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
  function zle-line-init() {
    echoti smkx
  }
  function zle-line-finish() {
    echoti rmkx
  }
  zle -N zle-line-init
  zle -N zle-line-finish
fi

bindkey -v

autoload -U up-line-or-beginning-search
zle -N up-line-or-beginning-search
bindkey -M viins "${terminfo[kcuu1]}" up-line-or-beginning-search
bindkey -M vicmd "k" up-line-or-beginning-search

autoload -U down-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey -M viins "${terminfo[kcud1]}" down-line-or-beginning-search
bindkey -M vicmd "j" down-line-or-beginning-search

# colors
autoload -Uz colors && colors

# fzf
[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh

# prompt, aliases and functions
source "$ZDOTDIR/prompt"
source "$ZDOTDIR/aliases"
source "$ZDOTDIR/functions"

# plugins
zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"
