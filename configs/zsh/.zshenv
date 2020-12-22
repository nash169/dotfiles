# Default programs:
export EDITOR="nvim"
export TERMINAL="st"
export READER="zathura"
export FILE="ranger"
export BROWSER="brave"
export DMENU_RUN="dmenu_run -fn 'Hack Nerd Font Mono-16'"
export DMENU="dmenu -w 245 -x 10 -y 30 -i"

# Interfaces
export WIRED=$(ip link | awk -F: '$0 !~ "lo|vir|wl|^[^0-9]"{print $2;getline}')

# Ranger
export RANGER_LOAD_DEFAULT_RC=false

# Local executables
export PATH="$HOME/.local/bin:$PATH"