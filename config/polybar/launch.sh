#!/usr/bin/env bash
# Launches one instance of polybar per output screen
# Stores an assignation of <OUTPUT>=<POLYBAR_PID> inside ~/.config/polybar/pids
polybar-msg cmd quit

echo "---" \ tee -a /tmp/polybar1.log
rm -rf ~/.config/polybar/pids
if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload default &
	echo "$m=$!" >> ~/.config/polybar/pids &
  done
else
  polybar --reload default &
fi

echo "Bar launched"
