#!/bin/sh
username=$(/usr/bin/whoami)
export $(dbus-launch)
eval "export $(egrep -z DBUS_SESSION_BUS_ADDRESS /proc/$(pgrep -u $LOGNAME gnome-session)/environ)";

DOTFILES=/home/nsella/Documents/personal_projects/dotfiles
/usr/bin/git --git-dir=$DOTFILES/.git pull 1> /dev/null
pushd $DOTFILES 1> /dev/null
$DOTFILES/install.py --check --quiet
EXIT_CODE=$?
if [ $EXIT_CODE -eq 12 ]; then
    DISPLAY=:0.0 /usr/bin/notify-send -i warning -t 0 "Backup Dotfiles" "Hey, you should back up!" --icon=dialog-information
elif [ $EXIT_CODE -eq 14 ]; then
    DISPLAY=:0.0 /usr/bin/notify-send -i warning -t 0 "Update Dotfiles" "You have newer dotfiles!" --icon=dialog-information
elif [ $EXIT_CODE -eq 10 ]; then
    DISPLAY=:0.0 /usr/bin/notify-send -i warning -t 0 "Dotfiles need inspection" "There are several changes in your dotfiles!" --icon=dialog-information
fi
popd 1> /dev/null

