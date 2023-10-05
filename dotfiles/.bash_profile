# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs
export PATH=~/.local/bin:$PATH

export FEDORA_DIST_GIT_REPOS=~/Documents/release/fedora
export FEDORA_SOURCE_GIT_REPOS=~/Documents/release/upstream

. "$HOME/.cargo/env"
