# Switch to a branch and fetch, if it exists upstream
git_fetch_branch() {
    if [[ $(git branch -r | grep "$1" | (wc -l)) -eq "1" ]]; then
        printf "${GREEN}$(basename `pwd`) fetching branch '$1' ${NC}\n"
        git checkout -B "$1" -q
        git branch --set-upstream-to=origin/"$1" "$1" -q
        git fetch -q
    fi
}

# Fetch branch by name for all submodules
git_fetch_all_branches() {
    p=`pwd` && (echo .; git submodule foreach --recursive) | while read entering path; do
        cd "$p/${path//\'/}"
        git_fetch_branch "$1"
    done
}

# Delete merged branches
git_delete_merged() {
    git branch --merged | grep -v "\*" | grep -v master | xargs -n 1 git branch -d
    git remote prune origin
}

# Delete merged branches for all submodules
git_delete_all_merged() {
    p=`pwd` && (echo .; git submodule foreach --recursive) | while read entering path; do
        cd "$p/${path//\'/}"
        git_delete_merged
    done 
}

