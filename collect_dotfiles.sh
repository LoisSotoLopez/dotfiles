#!/bin/bash

# MACROS

green='\033[0;32m'
red='\033[0;32m'
reset='\033[0m'

DOTFILE_PATHS=(
    "$HOME/.config/i3"
    "$HOME/.config/polybar"
    "$HOME/.config/rofi"
    "$HOME/.config/autorandr"
    "$HOME/.config/nvim"
    "$HOME/.config/rofi"
    "$HOME/.config/terminator"
)

collect_path() {
    mkdir -p "config"
    if test -d $1; then
        echo -e "${green}Collecting${reset} $1"
        cp -r $1 "config/$(basename $path)"
    else
        echo -e "${red}Couldn't find${reset} $1 dir"
    fi
}

for path in ${DOTFILE_PATHS[@]}; do
    collect_path $path 
done
