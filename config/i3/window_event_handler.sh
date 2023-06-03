#!/bin/bash
# Handles window events
# Solves: now I handle non user-triggered events such as programs exiting
# fullscreen mode or some window focus changes
# Cons: 
#  - There is a minimal but still perceptible delay between i3 event receival
#    and visual result

on_window_event() {
    while read -r event; do
        event_change="$(echo "$event" | jq -r '.change')"
        case $event_change in
            focus)
                mkdir -p /tmp/i3
                last_focused_window=$(cat /tmp/i3/last_focused_window 2>/dev/null)
                if [[ $last_focused_window ]]; then
                    i3-msg [con_id="$last_focused_window"] border pixel 1
                fi
                new_focused_window=$(echo "$event" | jq -r '.container.id')
                echo $new_focused_window > /tmp/i3/last_focused_window
                i3-msg [con_id="$new_focused_window"] border pixel 4
                ;;
            fullscreen_mode)
                output=$(echo "$event" | jq -r '.container.output')
                is_fullscreen_mode=$(echo "$event" | jq -r '.container.fullscreen_mode')
                output_pid=$(\
                    # Check polybar/launch.sh & i3/config
	                cat /tmp/polybar/pids \
	                | grep $output \
	                | awk '{split($0,a,"="); print a[2]}')
                if [[ $is_fullscreen_mode -eq 0 ]]; then
                    polybar-msg -p $output_pid cmd show;
                else
                    polybar-msg -p $output_pid cmd hide;
                fi
                ;;
            *)
                echo "other $event_change"
        esac
    done
}

i3-msg -t subscribe -m '[ "window" ]' | on_window_event

