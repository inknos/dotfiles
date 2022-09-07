#!/bin/sh
username=$(/usr/bin/whoami)
export $(dbus-launch)

DOTFILES=/home/nsella/Documents/personal_projects/dotfiles
/usr/bin/git --git-dir=$DOTFILES/.git pull 1> /dev/null
pushd $DOTFILES 1> /dev/null
$DOTFILES/install.py --check --quiet
EXIT_CODE=$?
if [ $EXIT_CODE -eq 12 ]; then
    /usr/bin/notify-send "Hey, dotfles should be backed up!"
elif [ $EXIT_CODE -eq 14 ]; then
    /usr/bin/notify-send "You have newer dotfiles!"
elif [ $EXIT_CODE -eq 10 ]; then
    /usr/bin/notify-send "There are several changes in your dotfiles!"
fi
popd 1> /dev/null

