# This file contains git short-cuts and commands users may find useful

alias ga="git add -A"
alias gs="git status"
alias gch="git checkout"
alias gcho="git checkout --ours --"
alias gcht="git checkout --theirs --"
alias gc="git commit"
alias gcm="git commit -m"
alias gp="git push"

# Short cuts similar to the above but add the --no-verify flag, 
# common to when you have commit and push hooks enabled on your repo.
alias gcnv="git commit --no-verify"
alias gpnv="git push --no-verify"

# A quick way to ensure you have the latest changes from remote and update your current branch.
alias gfp="git fetch && git pull"

# Quickly see what branch you are currently on, which is indicated by a '*',
# as 'git branch' will show you all branches you have locally, which can be visually noisy.
alias gb="git branch | grep -i '*'"

