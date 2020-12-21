#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done

# Get dpi (at the moment one for all the screen)
dpi=$(xrdb -query |grep dpi | awk '{print $2}')

if type "xrandr" > /dev/null; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    DPI=$dpi MONITOR=$m polybar --reload mainbar -c ~/.config/polybar/config &
  done
else
polybar --reload mainbar -c ~/.config/polybar/config &
fi
# second polybar at bottom
# if type "xrandr" > /dev/null; then
#   for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
#     MONITOR=$m polybar --reload mainbar-extra -c ~/.config/polybar/config &
#   done
# else
# polybar --reload mainbar-extra -c ~/.config/polybar/config &
# fi