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
    path=$1
    mkdir -p "config"
    if test -d $path; then
        echo -e "${green}Collecting${reset} $path"
        rsync -ruv $path "config/"
    else
        echo -e "${red}Couldn't find${reset} $1 dir"
    fi
    echo ""
}

for path in ${DOTFILE_PATHS[@]}; do
    collect_path $path 
done
