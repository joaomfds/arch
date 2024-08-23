if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi

# set fallback PS1; only if currently set to upstream bash default
if [ "$PS1" = '\s-\v\$ ' ]; then
	PS1='\h:\w\$ '
fi

for f in /etc/bash/*.sh; do
	[ -r "$f" ] && . "$f"
done
unset f

# search through partial command history (autocomplete)

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'


#if [ -f /usr/bin/fastfetch ]; then
#	fastfetch
#fi

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Enable bash programmable completion features in interactive shells
if [ -f /usr/share/bash-completion/bash_completion ]; then
	. /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi

# Check the window size after each command and, if necessary, update the values of LINES and COLUMNS
shopt -s checkwinsize

# Causes bash to append to history instead of overwriting it so if you start a new terminal, you have old session history
shopt -s histappend
PROMPT_COMMAND='history -a'

# Allow ctrl-S for history navigation (with ctrl-R)
[[ $- == *i* ]] && stty -ixon

# Set Starship prompt
# Install Starship - curl -sS https://starship.rs/install.sh | sh
eval "$(starship init bash)"
eval "$(zoxide init bash)"
export EDITOR="nano"
export VISUAL="nano"
export GTK_THEME="Adwaita:dark"

alias l='eza -la --icons --color'
alias ls='eza -a --icons --color'
alias la='eza -la --icons --color'
alias ll='eza -l --icons --color'
