#!/bin/bash

# Define the ANSI colors.
export         CLEAR="\033[00m"
export           RED="\033[0;31m"
export     LIGHT_RED="\033[1;31m"
export         GREEN="\033[0;32m"
export   LIGHT_GREEN="\033[1;32m"
export         GREEN="\033[0;32m"
export   LIGHT_GREEN="\033[1;32m"
export        YELLOW="\033[0;33m"
export  LIGHT_YELLOW="\033[1;33m"
export          BLUE="\033[0;34m"
export    LIGHT_BLUE="\033[1;34m"
export       MAGENTA="\033[0;35m"
export LIGHT_MAGENTA="\033[1;35m"
export         WHITE="\033[1;37m"
export    LIGHT_GRAY="\033[0;37m"

if [ -f ~/.bashrc ]; then . ~/.bashrc; fi
if [ -f ~/.bash_functions ]; then . ~/.bash_functions; fi

# Set the prompts.
export PS1="\[\033[G\]\[$BLUE\][\[$LIGHT_GREEN\]\h \$(rbenv_prompt)\$(repo_prompt) \[$LIGHT_YELLOW\]\w\[$BLUE\]]\[$BLUE\]\$ \[$CLEAR\]"
export PS2="> "
export PS4="+ "
