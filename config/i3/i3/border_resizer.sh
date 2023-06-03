#!/bin/bash
on_window_event() {
    jq '.change' $1 
    #i3-msg '[all] border pixel 1' 
    #i3-msg border pixel 3
    #on_window_change
}

i3-msg -t subscribe -m '[ "window" ]' | on_window_event

