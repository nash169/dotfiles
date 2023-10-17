#!/bin/sh

# some useful options (man zshoptions)
setopt autocd extendedglob nomatch menucomplete
setopt interactive_comments
stty stop undef		# Disable ctrl-s to freeze terminal.
zle_highlight=('paste:none')

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

# beeping is annoying
unsetopt BEEP

# completions
autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# colors
autoload -Uz colors && colors

# plugins
PLUGINS_DIR=/usr/share/zsh/plugins
[ -f $PLUGINS_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source $PLUGINS_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 
[ -f $PLUGINS_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source $PLUGINS_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh 

# fzf
# [ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh
# [ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh

# prompt, aliases and functions
source "$ZDOTDIR/prompt"
source "$ZDOTDIR/aliases"
source "$ZDOTDIR/functions"

