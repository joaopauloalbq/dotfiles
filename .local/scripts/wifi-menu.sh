#!/bin/bash
# wifi-menu
# notify-send -t 1000 "Getting WiFi networks..."
chosen_network=$(nmcli -g SSID device wifi | rofi -dmenu -i -p "" -no-custom -theme list.rasi)
if [[ -z $chosen_network ]]; then
    # If we have not chosen a network, the previous command will return an empty string
    # and we can exit right away
    exit 1
fi

if [[ -n $(nmcli -g NAME connection | grep $chosen_network) ]]; then
    nmcli connection up id $chosen_network
else
    nmcli device wifi connect $chosen_network
fi
