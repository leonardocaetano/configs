#!/bin/bash

# emacs
[ -e ~/.emacs ] && rm -f ~/.emacs 
ln -s ~/dev/configs/.emacs ~/.emacs

# bash
[ -e ~/.bashrc ] && rm -f ~/.bashrc 
ln -s ~/dev/configs/.bashrc ~/.bashrc
