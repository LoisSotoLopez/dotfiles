#!/bin/sh
# Toggles polybar for the current output screen only
# Relies on <OUTPUT>=<POLYBAR_PID> assignation in ~/.config/polybar/pids
toggle_at=$(\
	i3-msg -t get_workspaces \
	| jq \
	| awk '/focused/ {focused = $2} /output/ {if (focused == "true,") print $2}' \
	| sed 's/"//g' | sed 's/,//g')

output_pid=$(\
	cat ~/.config/polybar/pids \
	| grep $toggle_at \
	| awk '{split($0,a,"="); print a[2]}')

polybar-msg -p $output_pid cmd toggle


