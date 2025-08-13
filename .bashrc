# ==============================
# 1. Shell Interactivity Check
# ==============================
# Exit if the shell is non-interactive
if [[ $- != *i* ]] ; then
    # Shell is non-interactive. Be done now!
    return
fi

# ==============================
# 2. Prompt Customization
# ==============================
# Set fallback PS1 if currently set to upstream bash default
if [ "$PS1" = '\s-\v\$ ' ]; then
    PS1='\h:\w\$ '
fi

# ==============================
# 3. Source System and Global Scripts
# ==============================
# Source all readable scripts in /etc/bash/
for f in /etc/bash/*.sh; do
    [ -r "$f" ] && . "$f"
done
unset f

# Source global definitions if available
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# ==============================
# 4. Bash Completion
# ==============================
# Enable bash programmable completion features in interactive shells
if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# ==============================
# 5. Shell Options
# ==============================
# Check the window size after each command and update LINES and COLUMNS if necessary
shopt -s checkwinsize

# Append to the history file, don't overwrite it
shopt -s histappend

# ==============================
# 6. Command History Configuration
# ==============================
# Immediately append new history lines to the history file
PROMPT_COMMAND='history -a'

# Allow Ctrl-S for history navigation (with Ctrl-R)
[[ $- == *i* ]] && stty -ixon

# Set maximum number of lines in the history file
export HISTFILESIZE=10000

# Set maximum number of commands remembered in the current session
export HISTSIZE=5000

# Control how Bash handles command history:
# - erasedups: Remove older duplicate commands from history
# - ignoredups: Do not store duplicate commands in history
# - ignorespace: Do not store commands that start with a space
export HISTCONTROL=ignorespace

# ==============================
# 7. Readline and Input Behavior
# ==============================
# Configure readline for improved tab completion and navigation
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind 'set show-all-if-unmodified on'
bind 'set show-all-if-ambiguous on'
bind 'set colored-stats on'
bind 'set visible-stats on'
bind 'set mark-symlinked-directories on'
bind 'set colored-completion-prefix on'
bind 'set menu-complete-display-prefix on'
bind 'set bell-style visible'
bind 'set completion-ignore-case on'

# ==============================
# 8. Environment Variables
# ==============================
source ~/.config/shell/environment

# ==============================
# 9. Aliases
# ==============================
source ~/.config/shell/aliases

# ==============================
# 10. Shell Integrations
# ==============================
# Starship prompt initialization
eval "$(starship init bash)"

# FZF (fuzzy finder) integration
eval "$(fzf --bash)"

# Zoxide (smarter cd command) integration
eval "$(zoxide init --cmd cd bash)"

# ==============================
# 11. Optional/Commented Out Sections
# ==============================
# Uncomment to run fastfetch at shell startup
# if [ -f /usr/bin/fastfetch ]; then
#     fastfetch
# fi

# Uncomment to start Hyprland on TTY1 if no DISPLAY is set
#if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
#    exec Hyprland
#fi

