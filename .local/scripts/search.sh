#!/usr/bin/env bash
# sudo updatedb -U "$HOME" -e "$HOME/.config" -e "$HOME/.local" -e "$HOME/.cache"
xdg-open "$(locate -e -i --regex "$HOME/[^\.]+" | rofi -theme list.rasi -threads 0 -dmenu -keep-right -i -p  )"

# find $HOME > database.txt
# rofi -theme list.rasi -threads 0 -dmenu -i -keep-right -input database.txt -p  
