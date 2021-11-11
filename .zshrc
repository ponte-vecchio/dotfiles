# >>> basic zsh config >>>
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
        source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
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
