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


# Define the maximum number of lines contained in the shell command history file.
export HISTFILESIZE=10000

# Define the maximum number of commands to remember in the current shell session.
export HISTSIZE=5000

# Control how Bash handles command history:
#   - erasedups: Remove older duplicate commands from history.
#   - ignoredups: Do not store duplicate commands in history.
#   - ignorespace: Do not store commands that start with a space in history.
export HISTCONTROL=erasedups:ignoredups:ignorespace

# Enable colored output for the `ls` command and related utilities.
export CLICOLOR=0

# Define color codes for different file types in the `ls` command output.
# Colors make it easier to distinguish between file types (e.g., directories, symlinks, executables).
#export LS_COLORS='no=00:fi=00:di=00;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:*.xml=00;31:'

# Set options for readline directly in bashrc
bind 'set show-all-if-unmodified on'
bind 'set show-all-if-ambiguous on'
bind 'set colored-stats on'
bind 'set visible-stats on'
bind 'set mark-symlinked-directories on'
bind 'set colored-completion-prefix on'
bind 'set menu-complete-display-prefix on'
bind 'set bell-style visible'
bind 'set completion-ignore-case on'

# Exports
export EDITOR="nano"
export VISUAL="nano"
export GTK_THEME="Adwaita:dark"
export PAGER="less"
export TERM="xterm-256color"
export PATH="/bin:/sbin:/usr/sbin:/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl:$HOME/.local/bin"
export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always {} 2>/dev/null || cat {} 2>/dev/null' --preview-window=right:60%"

# Aliases
alias ls='eza  --icons --color --group-directories-first'
alias la='ls -a'
alias l='ls -l'
alias ll='ls -la'
alias lt='ls -lT'

# Shell integrations
eval "$(starship init bash)"
eval "$(fzf --bash)"
eval "$(zoxide init --cmd cd bash)"

#if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
#  exec Hyprland
#fi

alias v=nvim
alias vi=nvim
alias vim=nvim
