set -o vi

P_GREEN="\[$(tput setaf 2)\]"
P_RESET="\[$(tput sgr0)\]"
PS1="$P_GREEN\u@\h:\w\\$ $P_RESET"
