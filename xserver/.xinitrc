#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# make sure this is before the 'exec' command or it won't be sourced.
[ -f ~/.xprofile ] && . ~/.xprofile

# status bar
dwmstatus 2>&1 >/dev/null &

# display manager
exec dwm

