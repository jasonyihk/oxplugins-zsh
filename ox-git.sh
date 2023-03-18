##########################################################
# config
##########################################################

export GPG_TTY=$(tty)

OX_OXYGEN[oxg]=${OXIDIZER}/defaults/.gitconfig
OX_ELEMENT[g]=${HOME}/.gitconfig

##########################################################
# query
##########################################################

alias gh="git help"
alias gst="git status"
alias gcf="git config"

##########################################################
# project management
##########################################################

alias gii="git init"
# ui
alias gui="gitui"

##########################################################
# item management
##########################################################

alias ga="git add"
alias gdf="git diff"
alias gpl="git pull"
alias gps="git push"
alias gcm="git commit"

##########################################################
# clean
##########################################################

# clean files
gcl() {
    case $1 in
    --his)
        git checkout --orphan new
        git add -A
        git commit -am "🎉 New Start"

        local branch=${2:-master}
        git branch -D $branch
        git branch -m $branch
        git push -f origin $branch
        ;;
    --ig)
        git rm -rf --cached .
        git add .
        ;;
    *) git clean $@ ;;
    esac
}

# list fat files
#
# $1: item number to display
gjk() {
    local number=${1:-10}
    git rev-list --objects --all | git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' | rg 'blob' | sort -k 2 -n | tail -$number
}

# git republish
grpb() {
    git remote add origin $1
    local branch=${2:-master}
    git pull $1 $branch
    git push --set-upstream origin $branch
}

##########################################################
# tag
##########################################################

alias gt="git tag"
alias gth="git help tag"
alias gtls="git tag --list"
alias gta="git tag --annotate"
alias gtrm="git tag --delete"
alias gted="git tag --edit"
alias gtcl="git tag --cleanup"
