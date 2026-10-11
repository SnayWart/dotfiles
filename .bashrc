#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export XDG_DATA_DIRS="${HOME}/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ll='ls -lah --color=auto'
alias fetch='fastfetch'

# Pretty Pastel Prompt (Sakura & Honey)
PS1='\[\e[38;2;244;167;185m\]󰄛 \w\[\e[0m\] \[\e[38;2;245;205;130m\]❯\[\e[0m\] '

# Display fastfetch when opening an interactive Kitty terminal
if [ "$TERM" = "xterm-kitty" ] && [ -t 1 ]; then
    fastfetch
fi
