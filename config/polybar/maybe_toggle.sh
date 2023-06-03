#!/bin/bash
# Toggles polybar for the current workspace
# depending on whether current window is fullscreen
# or not

current_workspace=$(\
	echo $(\
		i3-msg -t get_workspaces \
		| jq  '.[] | select(.focused==true)| .num')\
	| awk '{print $1}')

output_dimensions=$(\
	echo $(\
		i3-msg -t get_outputs \
		| jq --arg cw "$current_workspace" '.[] | select(.current_workspace==$cw)| .rect | .width, .height')\
	| awk '{print $1"x"$2}')

echo "dimensions $output_dimensions"

window_dimensions=$(\
	echo $(\
		xwininfo -id $(xdotool getactivewindow) -stats \
		| grep -E '(Width|Height):' \
		| awk '{print $2}' \
		| sed -e 's/ /x/')\
	| awk '{print $1"x"$2}')

echo "window_dimensions $window_dimensions"

toggle_at=$(\
	i3-msg -t get_workspaces \
	| jq \
	| awk '/focused/ {focused = $2} /output/ {if (focused == "true,") print $2}' \
	| sed 's/"//g' | sed 's/,//g')

output_pid=$(\
	cat ~/.config/polybar/pids \
	| grep $toggle_at \
	| awk '{split($0,a,"="); print a[2]}')

if [ "$output_dimensions" == "$window_dimensions" ]; then
	polybar-msg -p $output_pid cmd hide
else
	polybar-msg -p $output_pid cmd show
fi

