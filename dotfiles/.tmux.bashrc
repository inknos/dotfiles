# start tmux only if not in tty
if [ "$XDG_SESSION_TYPE" != "tty" ]; then
	# if tmux already started attach to existing
	if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
		tmux attach -t main || tmux new -s main
	fi
fi

# start new session mail if no session exist
# tmux has-session -t "mail" 2>/dev/null
# if [ $? != 0 ]; then
#     export XDG_CONFIG_HOME="$HOME/.config"
#     export XDG_CACHE_HOME="$HOME/.cache"
#     tmux new-session -d -s mail "NOTMUCH_PROFILE=redhat /usr/bin/neomutt"
#     #tmux new-window -t mail:1 -n outlook "NOTMUCH_PROFILE=outlook /usr/bin/neomutt"
#     #tmux new-window -t mail:2 -n disroot "NOTMUCH_PROFILE=disroot /usr/bin/neomutt"
#     #tmux kill-window -t mail:0
#     #tmux new-window -t mail:0 -n redhat "NOTMUCH_PROFILE=redhat /usr/bin/neomutt"
# fi

# start new session telegram if no session exist
# tmux has-session -t "telegram" 2>/dev/null
# if [ $? != 0 ]; then
#     export XDG_CONFIG_HOME="$HOME/.config"
#     export XDG_CACHE_HOME="$HOME/.cache"
#     tmux new-session -d -s telegram ~/.local/bin/tg
# fi

# start new session irc if no session exist
tmux has-session -t "irc" 2>/dev/null
if [ $? != 0 ]; then
    export XDG_CONFIG_HOME="$HOME/.config"
    export XDG_CACHE_HOME="$HOME/.cache"
    tmux new-session -d -s irc /usr/bin/weechat
fi

