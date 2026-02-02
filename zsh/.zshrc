# Universal paths
export PATH=/usr/local/bin:$PATH
export PATH=$HOME/bin:$PATH
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH
export PATH=$HOME/.poetry/bin:$PATH

# macOS-specific paths (Homebrew)
if [[ "$(uname -s)" == "Darwin" ]]; then
    export PATH=/opt/homebrew/bin:$PATH
    export PATH=/opt/homebrew/opt/libpq/bin:$PATH
    # Detect available OpenJDK version
    if [[ -d /opt/homebrew/opt/openjdk@11 ]]; then
        export PATH=/opt/homebrew/opt/openjdk@11/bin:$PATH
        export CPPFLAGS="-I/opt/homebrew/opt/openjdk@11/include"
    elif [[ -d /opt/homebrew/opt/openjdk@17 ]]; then
        export PATH=/opt/homebrew/opt/openjdk@17/bin:$PATH
        export CPPFLAGS="-I/opt/homebrew/opt/openjdk@17/include"
    fi
fi

# Alias bat to batcat on Debian/Ubuntu (package name conflict)
if [[ -f /usr/bin/batcat ]] && ! command -v bat &>/dev/null; then
    alias bat="batcat"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Source env files if they exist
[ -f ~/.env ] && source ~/.env
[ -f ~/.bash_profile ] && source ~/.bash_profile

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
    tmux
    web-search
    zsh-autosuggestions
    zoxide
)

source $ZSH/oh-my-zsh.sh

# Preferred editor
export EDITOR='nvim'

ssh-add --apple-use-keychain

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

# macOS-specific completions
if [[ "$(uname -s)" == "Darwin" ]]; then
    autoload -U +X bashcompinit && bashcompinit
    [ -f /opt/homebrew/bin/terraform ] && complete -o nospace -C /opt/homebrew/bin/terraform terraform
fi

eval "$(starship init zsh)"

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

if command -v pyenv-virtualenv-init &>/dev/null; then eval "$(pyenv virtualenv-init -)"; fi

# better cd command
eval "$(zoxide init zsh)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
