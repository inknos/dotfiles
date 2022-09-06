#!/bin/sh
DOTFILES=/home/nsella/Documents/personal_projects/dotfiles
/usr/bin/git --git-dir=$DOTFILES/.git pull
pushd $DOTFILES
$DOTFILES/install.py --dry-run --quiet --install
