#
# ~/.bashrc
#

# If not running interactively, don't do anythingl

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ff='fastfetch'
alias cpu='cpufetch'
alias gpu='gpufetch'
alias nq='nautilus -q'
alias tv='twt-v'

PS1='[\u@\h \W]\$ '

eval "$(oh-my-posh init bash --config /home/k/.config/ohmyposh/config.json)"
export PATH="$PATH:/home/k/Documents/Apps"
export LIBVA_DRIVER_NAME=i965

# terminal greeter
#term-greet