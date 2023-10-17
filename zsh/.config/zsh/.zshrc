#!/bin/sh

# some useful options (man zshoptions)
setopt autocd extendedglob nomatch menucomplete
setopt interactive_comments
stty stop undef		# Disable ctrl-s to freeze terminal.
zle_highlight=('paste:none')

# history
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=$HOME/.cache/zsh/zsh_history

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

