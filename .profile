# Set the system PATH variable, which defines the directories to search for executable files.
# This includes standard system directories, user-specific local binaries, and Flatpak export paths.
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:$HOME/.local/bin:$HOME/.cargo/bin:/var/lib/flatpak/exports/bin:/.local/share/flatpak/exports/bin

# Set the system language and locale settings to English (United States) with UTF-8 encoding.
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Define the maximum number of lines contained in the shell command history file.
export HISTFILESIZE=10000

# Define the maximum number of commands to remember in the current shell session.
export HISTSIZE=500

# Control how Bash handles command history:
#   - erasedups: Remove older duplicate commands from history.
#   - ignoredups: Do not store duplicate commands in history.
#   - ignorespace: Do not store commands that start with a space in history.
export HISTCONTROL=erasedups:ignoredups:ignorespace

# Set the default text editor to nano for command-line text editing tasks.
export EDITOR=nano

# Set the default visual text editor to nano (used by some applications that require visual editing).
export VISUAL=nano

# Enable colored output for the `ls` command and related utilities.
export CLICOLOR=1

# Define color codes for different file types in the `ls` command output.
# Colors make it easier to distinguish between file types (e.g., directories, symlinks, executables).
export LS_COLORS='no=00:fi=00:di=00;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:*.xml=00;31:'

# Customize the appearance of man pages viewed through `less`:
#   - LESS_TERMCAP_mb: Start blink (bold red).
#   - LESS_TERMCAP_md: Start bold (bold red).
#   - LESS_TERMCAP_me: End all attributes.
#   - LESS_TERMCAP_se: End standout-mode.
#   - LESS_TERMCAP_so: Start standout-mode (blue background, yellow text).
#   - LESS_TERMCAP_ue: End underline.
#   - LESS_TERMCAP_us: Start underline (bold green).
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'