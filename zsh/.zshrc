export PATH=/usr/local/bin:$PATH
export PATH=$HOME/bin:$PATH
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH
export PATH=$HOME/.poetry/bin:$PATH
export PATH=/opt/homebrew/bin:$PATH
export PATH=/opt/homebrew/opt/libpq/bin:$PATH
export PATH=/opt/homebrew/opt/openjdk@17/bin:$PATH

export CPPFLAGS="-I/opt/homebrew/opt/openjdk@17/include"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

source ~/.env
source ~/.bash_profile

zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' frequency 13

# make use of fzf-tab popup feature https://github.com/Aloxaf/fzf-tab?tab=readme-ov-file#tmux
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(
    aws
    copypath
    docker
    dotenv
    emoji
    fzf-tab
    git
    gitignore
    kubectl
    pre-commit
    ripgrep
    tmux
    web-search
    zsh-autosuggestions
    zoxide
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

alias fm="frogmouth"

alias maelstrom=$MARTINABELEDA/nautilus/maelstrom/maelstrom

batdiff() {
    git diff --name-only --relative --diff-filter=d | xargs bat --diff
}

git_cleanup() {
    git branch --merged | egrep -v "(^\*|master|main)" | xargs git branch -d
}

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform

eval "$(starship init zsh)"

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

# better cd command
eval "$(zoxide init zsh)"
