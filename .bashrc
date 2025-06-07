#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto -lah'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
alias vi='vim'
alias cls='clear'
