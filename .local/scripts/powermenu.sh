#!/bin/bash

if [ -z "$@" ]; then
    echo -en "Shutdown\0icon\x1fsystem-shutdown\n"
    echo -en "Suspend\0icon\x1fsystem-suspend\n"
    echo -en "Restart\0icon\x1fsystem-restart\n"
    echo -en "Logout\0icon\x1fsystem-log-out\n"
else
    if [ "$1" = "Shutdown" ]; then
        systemctl poweroff
    elif [ "$1" = "Suspend" ]; then
    	awesome-client 'awful = require("awful") awful.spawn.with_shell("bash ~/.local/scripts/lockscreen.sh && systemctl suspend")'
    elif [ "$1" = "Restart" ]; then
        systemctl reboot
    elif [ "$1" = "Logout" ]; then
        awesome-client 'awesome.quit()'
    fi
fi
