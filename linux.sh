#!/bin/bash

# emacs
[ -e ~/.emacs ] && rm -f ~/.emacs 
ln -s ~/dev/configs/.emacs ~/.emacs

# bash
[ -e ~/.bashrc ] && rm -f ~/.bashrc 
ln -s ~/dev/configs/.bashrc ~/.bashrc

# wezterm
[ -e ~/.wezterm.lua ] && rm -f ~/.wezterm.lua
ln -s ~/dev/configs/wezterm.lua ~/.wezterm.lua

# tmux
[ -e ~/.tmux.conf ] && rm -f ~/.tmux.conf
ln -s ~/dev/configs/.tmux.conf ~/.tmux.conf
