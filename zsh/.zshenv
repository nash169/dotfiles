# preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# terminal
export TERMINAL="st"

# pdf reader
export READER="zathura"

# file explorer
export FILE="lf"

# browser
export BROWSER="firefox"

# interfaces
export WIRED=$(ip link | awk -F: '$0 !~ "lo|vir|wl|^[^0-9]"{print $2;getline}')

# local executables
export PATH="$HOME/.local/bin:$PATH"

# zsh config
export ZDOTDIR="$HOME/.config/zsh"

# gpg-agent
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi
export GPG_TTY=$(tty)

# sudo
export SUDO_ASKPASS="$HOME/.local/bin/dmenupass"
