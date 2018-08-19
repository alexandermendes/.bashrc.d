# Switch to a branch and fetch, if it exists upstream
gitf() {
    if [[ $(git branch -r | grep "$1" | (wc -l)) -eq "1" ]]; then
        printf "${GREEN}$(basename `pwd`) fetching branch '$1' ${NC}\n"
        git checkout -B "$1" -q
        git branch --set-upstream-to=origin/"$1" "$1" -q
        git fetch -q
    fi
}

# Delete merged branches
function gitdm() {
    git branch --merged | grep -v "\*" | grep -v master | xargs -n 1 git branch -d
    git remote prune origin
}
