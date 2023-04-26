# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"

# Source environment file
source ~/.env

if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

# If you come from bash you might have to change your $PATH.
export PATH=/usr/local/bin:$PATH
export PATH=$HOME/bin:$PATH
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH
export PATH=$HOME/.fig/bin:$PATH
export PATH=$HOME/.poetry/bin:$PATH
export PATH=/opt/homebrew/opt/libpq/bin:$PATH
export PATH=/opt/homebrew/opt/openjdk@17/bin:$PATH

export CPPFLAGS="-I/opt/homebrew/opt/openjdk@17/include"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' frequency 13

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(
    copypath
    dotenv
    git
    gitignore
    tmux
    web-search
    zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='nvim'
fi

# Set personal aliases, overriding those provided by oh-my-zsh libs,
alias v="nvim"
alias vim="nvim"
alias lh="ls -alh"

# Aliases for project folders
export DEVELOPMENT="$HOME/Development"
export MARTINABELEDA="$DEVELOPMENT/martinabeleda"
alias cstrava="cd $MARTINABELEDA/strava/ && poetry shell"
alias cathena="cd $MARTINABELEDA/athena/"
alias caoc="cd $MARTINABELEDA/advent-of-code/"
alias cdot="cd $MARTINABELEDA/dotfiles/"

# Aliases for tmux sessions
alias default="tmux attach -t default"

alias maelstrom=$MARTINABELEDA/nautilus/maelstrom/maelstrom

batdiff() {
    git diff --name-only --relative --diff-filter=d | xargs bat --diff
}

gcl() {
    git branch --merged | egrep -v "(^\*|master|main)" | xargs git branch -d
}

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform

eval "$(starship init zsh)"

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"
