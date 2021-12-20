#
# ~/.bashrc
#

[[ $- != *i* ]] && return

colors() {
    local fgc bgc vals seq0

    printf "Color escapes are %s\n" '\e[${value};...;${value}m'
    printf "Values 30..37 are \e[33mforeground colors\e[m\n"
    printf "Values 40..47 are \e[43mbackground colors\e[m\n"
    printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

    # foreground colors
    for fgc in {30..37}; do
        # background colors
        for bgc in {40..47}; do
            fgc=${fgc#37} # white
            bgc=${bgc#40} # black

            vals="${fgc:+$fgc;}${bgc}"
            vals=${vals%%;}

            seq0="${vals:+\e[${vals}m}"
            printf "  %-9s" "${seq0:-(default)}"
            printf " ${seq0}TEXT\e[m"
            printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
        done
        echo; echo
    done
}

[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# Change the window title of X terminals
case ${TERM} in
    xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
        PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
        ;;
    screen*)
        PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
        ;;
esac

use_color=true

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.

safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs=""

[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
    && type -P dircolors >/dev/null \
    && match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color} ; then
    # Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
    if type -P dircolors >/dev/null ; then
        if [[ -f ~/.dir_colors ]] ; then
            eval $(dircolors -b ~/.dir_colors)
        elif [[ -f /etc/DIR_COLORS ]] ; then
            eval $(dircolors -b /etc/DIR_COLORS)
        fi
    fi

    # PS1
    if [[ ${EUID} == 0 ]] ; then
        PS1="\[\033[34m\][ \[\033[1;33m\]\u\[\033[37m\] | \[\033[1;36m\]\h\[\033[37m\] | \[\033[32m\]\w\[\033[1;32m\]\[\033[32m\]\[\033[0;34m\] ]"
        PS1+="\n\[\033[2;35m\]$(echo $0 | sed -e 's^/bin/^^')"
        PS1+=" \[\033[01;$((31+!$?))m\]\$\[\033[00m\] "
    else
        PS1="\[\033[34m\][ \[\033[1;33m\]\u\[\033[37m\] | \[\033[1;36m\]\h\[\033[37m\] | \[\033[32m\]\w\[\033[1;32m\]\[\033[32m\]\[\033[0;34m\] ]"
        PS1+="\n\[\033[2;35m\]$(echo $0 | sed -e 's^/bin/^^')"
        PS1+=' \[\033[01;$((31+!$?))m\]\$\[\033[00m\] '
    fi

    # COLOURED ALIASES
    alias diff='diff --color=auto --suppress-common-lines'
    alias ls='ls --color=auto --group-directories-first'
    alias tree='tree -aC -I .git --dirsfirst'
    alias grep='grep --colour=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}'
    alias egrep='egrep --colour=auto'
    alias fgrep='fgrep --colour=auto'
else
    if [[ ${EUID} == 0 ]]; then
        PS1="[ \u | \h | \W ]\n$(echo $0 | sed -e 's^/bin/^^') \$ "
    else
        PS1="[ \u | \h | \w ]\n$(echo $0 | sed -e 's^/bin/^^') \$ "
    fi
    # UNCOLOURED ALIASES
    alias ls='ls --group-directories-first'
    alias tree='tree -a -I .git --dirsfirst'
    alias grep='grep --exclude-dir={.bzr,CVS,.git,.hg,.svn}'
fi

unset use_color safe_term match_lhs sh

alias cp="cp -i"        # confirm before overwriting something
alias df='df -h'        # human-readable sizes
alias free='free -m'    # show sizes in MB
alias more=less         # this is obvious

xhost +local:root > /dev/null 2>&1

# Bash won't get SIGWINCH if another process is in the foreground.
shopt -s checkwinsize
shopt -s expand_aliases
shopt -s histappend

# Generic extractor
extract ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1;;
      *.tar.gz)    tar xzf $1;;
      *.bz2)       bunzip2 $1;;
      *.rar)       unrar x $1;;
      *.gz)        gunzip $1;;
      *.tar)       tar xf $1;;
      *.tbz2)      tar xjf $1;;
      *.tgz)       tar xzf $1;;
      *.zip)       unzip $1;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1;;
      *)           echo "'$1' cannot be extracted!" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# bash completion
if [[ -f /usr/share/bash-completion/bash_completion ]]; then
  source /usr/share/bash-completion/bash_completion
elif [[ -f /etc/bash_completion ]]; then
  source /etc/bash_completion
fi

# gitstatus
if [[ -d ~/gitstatus ]]; then
  GITSTATUS_LOG_LEVEL=DEBUG
  source ~/gitstatus/gitstatus.prompt.sh
fi

# hook nvidia-smi to watch
if type nvidia-smi &> /dev/null; then
    alias nvidia-smi="watch -n 0.25 nvidia-smi"
fi

# Memory statistics
if type vmstat &> /dev/null && type head &> /dev/null; then
    alias memstat="vmstat -s --unit M | head"
fi

# Pacman-based distro things
PACMAN_DISTS=("arch endeavouros garuda kaos manjaro")

case $(uname) in
    Darwin)
        DISTNAME="$(uname)";;
    Linux)
        DISTNAME=$(cat /etc/os-release | grep "^ID=" | sed "s/ID=//");;
esac

_isin () {
    echo "$1" | tr " " "\n" | grep -F -x -q "$2"
}

# PKGFILE - Missing command handler
## https://wiki.archlinux.org/title/pkgfile
if _isin "${DISTNAME}" "${PACMAN_DISTS}"; then
    if ! type pkgfile &> /dev/null; then
        sudo pacman -Syu pkgfile && sudo pkgfile --update
    elif [[ -f "/usr/share/doc/pkgfile/command-not-found.bash" ]]; then
        source /usr/share/doc/pkgfile/command-not-found.bash
    fi
fi
 
