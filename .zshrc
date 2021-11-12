# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# >>> basic zsh config >>>
DISTNAME=$(cat /etc/os-release | grep "^ID=" | sed "s/ID=//")
PACMAN_DISTS="arch endeavouros garuda kaos manjaro"
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

autoload -Uz compinit
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

zstyle ':completion:*' menu select
setopt COMPLETE_ALIASES

compinit
# <<< basic zshrc config <<<

# >>> powerlevel10k >>>
# Load powerlevel if present, else install using AUR helper or install manually
if [[ -f "/usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme" ]]; then
    source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
elif type yay &> /dev/null || type paru &> /dev/null; then
    if type yay &> /dev/null; then
        yay -Syu --noconfirm zsh-theme-powerlevel10k-git
        yay -Syu powerline-fonts-git
        # source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
    else
        paru zsh-theme-powerlevel10k-git
        paru powerline-fonts-git
    fi
    source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
else
    if type git &> /dev/null; then
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
        source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
    fi
fi
# <<< powerlevel10k <<<

# >>> Functions >>>
_isin () {  # Check if item in list
    echo "$1" | tr " " "\n" | grep -F -x -q "$2"
}
# <<< Functions <<<

# >>> Aliases >>>
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

# niche aliases
if type arp-scan &> /dev/null; then
    alias localnet="sudo arp-scan -l"
elif ! _isin "${DISTNAME}" "${PACMAN_DISTS}"; then
    sudo pacman -Syu arp-scan
    alias localnet="sudo arp-scan -l"
fi
# <<< Aliases <<<

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
