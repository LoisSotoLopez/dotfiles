#!/bin/bash
# Handles window events
# Solves: now I handle non user-triggered events such as programs exiting
# fullscreen mode or some window focus changes
# Cons: 
#  - There is a minimal but still perceptible delay between i3 event receival
#    and visual result

readonly TMP_FILE_BASE_I3=/tmp/i3
readonly TMP_FILE_BASE_POLYBAR=/tmp/polybar
readonly LAST_FOCUSED_WINDOW_FILE=$TMP_FILE_BASE_I3/last_focused_window 
readonly WINDOW_LAST_OUTPUT=$TMP_FILE_BASE_I3/window_last_output
readonly POLYBAR_PIDS_FILE=$TMP_FILE_BASE_POLYBAR/pids

output_to_polybar_pid(){
    output=$1
    # Check polybar/launch.sh & i3/config
	cat $POLYBAR_PIDS_FILE \
	| grep $output \
	| awk '{split($0,a,"="); print a[2]}'
}

set_in_kv_file(){
    key=$1
    value=$2
    file=$3
    echo "set_in_kv_file($1,$2,$3)"
    if [ ! -f "$file" ]; then
        echo "attempting to create $file"
        touch "$file"
    fi
    sed "/^$key=/d" -i $file 
    echo "$key=$value" >> $file
}

toggle_fullscreen() {
    event=$1
    window=$(echo "$event" | jq -r '.container.id')
    output=$(echo "$event" | jq -r '.container.output')
    is_fullscreen_mode=$(echo "$event" | jq -r '.container.fullscreen_mode')
    polybar_pid=$(output_to_polybar_pid $output)
    if [[ $is_fullscreen_mode -eq 0 ]]; then
        polybar-msg -p $polybar_pid cmd show;
    else
        polybar-msg -p $polybar_pid cmd hide;
    fi
}

find_in_kv_file() {
    key=$1
    file=$2
    value=$(grep -m 1 "^$key=" $file | cut -d '=' -f 2)
    if [[ "$value" -eq "" ]]; then
        echo "none"
    else
        echo $value;
    fi
}

window_last_output() {
    window=$1
    find_in_kv_file $window $WINDOW_LAST_OUTPUT
}

is_dst_container_visible() {
    event=$1
    dst_container=$(echo "$event" | jq -r '.container.id')
    i3-msg -t get_workspaces | jq "any(.[]; (.visible==true) and (.id==$dst_container))"
}

on_window_event() {
    while read -r event; do
        event_change="$(echo "$event" | jq -r '.change')"
        case $event_change in
            move)
                moved_window=$(echo "$event" | jq -r '.container.window')
                is_fullscreen_mode=$(echo "$event" | jq -r '.container.fullscreen_mode')
                output=$(echo "$event" | jq -r '.container.output')
                last_output=$(window_last_output $moved_window)
                cat $POLYBAR_PIDS_FILE
                if [[ $is_fullscreen_mode -eq 1 ]]; then
                    last_polybar_pid=$(output_to_polybar_pid $last_output)
                    polybar-msg -p $last_polybar_pid cmd show
                fi

                if [[ $is_fullscreen_mode -eq 1 ]]; then
                    if [[ $output -ne $last_output ]]; then
                        is_result_true=$(is_dst_container_visible $event)
                        echo "is result true $is_result_zero"
                        if [[ $is_result_true == "true" ]]; then
                            echo "moving to visible"
                            polybar_pid=$(output_to_polybar_pid $output)
                            polybar-msg -p $polybar_pid cmd hide
                        else
                            echo "moving to not visible"
                        fi
                    fi
                fi
                set_in_kv_file $moved_window $output $WINDOW_LAST_OUTPUT
                ;;
            new)
                window=$(echo "$event" | jq -r '.container.window')
                output=$(echo "$event" | jq -r '.container.output')
                set_in_kv_file $window $output $WINDOW_LAST_OUTPUT
                ;;
            focus)
                toggle_fullscreen "$event"
                mkdir -p /tmp/i3
                last_focused_window=$(cat $LAST_FOCUSED_WINDOW_FILE 2>/dev/null)
                if [[ $last_focused_window ]]; then
                    i3-msg [con_id="$last_focused_window"] border pixel 1>/dev/null
                fi
                new_focused_window=$(echo "$event" | jq -r '.container.id')
                echo $new_focused_window > $LAST_FOCUSED_WINDOW_FILE 
                i3-msg [con_id="$new_focused_window"] border pixel 4 > /dev/null
                ;;
            fullscreen_mode)
                toggle_fullscreen "$event"
                ;;
            close)
                output=$(echo "$event" | jq -r '.container.output')
                polybar_pid=$(output_to_polybar_pid $output)
                if [[ $is_fullscreen_mode -eq 1 ]]; then
                    polybar-msg -p $polybar_pid cmd show;
                fi 
                ;;
            *)
                echo "other $event_change"
        esac
    done
}

i3-msg -t subscribe -m '[ "window" ]' | on_window_event

