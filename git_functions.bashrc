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

# Open current branch in GitHub
git_open() {
    local origin=$(git config remote.origin.url)
    local base=$(echo "$origin" | sed "s/git@\(.*\):\(.*\).git/https:\/\/\1\/\2/" | sed "s/\.git$//")
    local branch=$(git symbolic-ref --quiet --short HEAD )
    open "$base/tree/$branch"
}

# Compare the current against the base branch
git_compare() {
    local origin=$(git config remote.origin.url)
    local base=$(echo "$origin" | sed "s/git@\(.*\):\(.*\).git/https:\/\/\1\/\2/" | sed "s/\.git$//")
    local branch=$(git symbolic-ref --quiet --short HEAD )
    local default=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
    open "$base/compare/$default...$branch"
}

# Create a new PR for the current branch
git_pr() {
    local origin=$(git config remote.origin.url)
    local base=$(echo "$origin" | sed "s/git@\(.*\):\(.*\).git/https:\/\/\1\/\2/" | sed "s/\.git$//")
    local branch=$(git symbolic-ref --quiet --short HEAD )
    open "$base/pull/new/$branch"
}

# Print all my branches
git_print_my_branches() {
    p=`pwd` && (echo .; git submodule foreach --recursive) | while read entering path; do
        cd "$p/${path//\'/}"
        git fetch --all --quiet
        local name=$(basename "$path")
        local refs=$(git for-each-ref --format='%(authordate:format:%m/%d/%Y) %(align:10,left)%(authoremail)%(end) %(refname:strip=3)' refs/remotes)
        local mine=$(echo "$refs" | grep -w "mendes")
        if [ -z "$mine" ]; then
            continue
        fi
        printf "\n${GREEN}$(basename `pwd`)${NC}\n"
        echo "$mine" | column -t
    done
}
