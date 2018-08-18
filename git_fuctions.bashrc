# Switch to a branch and fetch, if it exists upstream
fetch() {
  if [[ $(git branch -r | grep "$1" | (wc -l)) -eq "1" ]]; then
    printf "${GREEN}$(basename `pwd`) fetching branch '$1' ${NC}\n"
    git checkout -B "$1" -q
    git branch --set-upstream-to=origin/"$1" "$1" -q
    git fetch -q
  fi
}
