# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# >>> funcs >>>
_isin () {
    echo "$!" | tr " " "\n" | grep -F -x -q "$2"
}
# <<< funcs <<<

# >>> basic zsh config >>>
# DISTNAME=$(cat /etc/os-release | grep "^ID=" | sed "s/ID=//")
PACMAN_DISTS="arch endeavouros garuda kaos manjaro"
case $(uname) in
    Darwin) DISTNAME="$(uname)";;
    Linux)  DISTNAME='$(cat /etc/os-release | grep "^ID=" | sed "s/ID=//" )';;
esac
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

autoload -Uz compinit
if [[ -f "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ -f "/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
if [[ -f "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [[ -f "/usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
zstyle ':completion:*' menu select
setopt COMPLETE_ALIASES

compinit
# <<< basic zshrc config <<<

# >>> powerlevel10k >>>
# Load powerlevel if present, else install using AUR helper or install manually
if _isin ${DISTNAME} ${PACMAN_DISTS}; then
    if [[ -f "/usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme" ]]; then
        source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
    elif type yay &> /dev/null || type paru &> /dev/null; then
        if type yay &> /dev/null; then
            yay -Syu --noconfirm zsh-theme-powerlevel10k-git
            yay -Syu powerline-fonts-git
            source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
        else
            paru zsh-theme-powerlevel10k-git
            paru powerline-fonts-git
            source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
        fi
    fi
    # else
    #    if type git &> /dev/null; then
    #        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
    #        source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
    #    fi
elif [[ "${DISTNAME}" == "Darwin" ]]; then
    if [[ -f "$(brew --prefix)/opt/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
        source $(brew --prefix)/opt/powerlevel10k/powerlevel10k.zsh-theme
    elif type git &> /dev/null; then
        brew install romkatv/powerlevel10k/powerlevel10k
        source $(brew --prefix)/opt/powerlevel10k/powerlevel10k.zsh-theme
    fi
    if ! type fd &> /dev/null; then
        brew install fd
    fi
fi
# <<< powerlevel10k <<<

# >>> Aliases >>>
if [[ "${DISTNAME}" == "Darwin" ]]; then
    alias cp="cp -i"
    alias df="df -h"
    alias diff="diff --color=auto"
    alias egrep="egrep --colour=auto"
    alias fgrep="fgrep --colour=auto"
    alias free="free -m"↵
    alias grep="grep --colour=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}"↵
    alias ls="ls --color=auto" # --group-directories-first"↵
    alias more="less"↵
    alias np="nano -w PKGBUILD"↵
    alias tree="tree -aC -I .git" # --dirsfirst"↵
    alias :q="exit"↵
else
    alias cp="cp -i"
    alias df="df -h"
    alias diff="diff --color=auto"
    alias egrep="egrep --colour=auto"
    alias fgrep="fgrep --colour=auto"
    alias free="free -m"
    alias grep="grep --colour=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}"
    alias ls="ls --color=auto --group-directories-first"
    alias more="less"
    alias np="nano -w PKGBUILD"
    alias tree="tree -aC -I .git --dirsfirst"
    alias :q="exit"
fi

# niche aliases
if type arp-scan &> /dev/null; then
    alias localnet="sudo arp-scan -l"
elif _isin "${DISTNAME}" "${PACMAN_DISTS}"; then
    sudo pacman -Syu arp-scan
    alias localnet="sudo arp-scan -l"
fi
# <<< Aliases <<<

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
if [[ ! -f ~/.p10k.zsh ]]; then
    source ~/.p10k.zsh
fi
