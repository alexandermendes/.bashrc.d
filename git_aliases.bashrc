# Constants
SRC_GIT_FUNCS='source ~/.bashrc.d/git_functions.bashrc'

# Aliases
git config --global alias.l "log --pretty=format:\"%C(yellow)%h\\ %ad%Cred%d\\ %Creset%s%Cblue\\ [%cn]\" --decorate --date=short"

git config --global alias.a "add"
git config --global alias.co "checkout"
git config --global alias.cob "checkout -B"
git config --global alias.cam "commit -a -m"
git config --global alias.d "diff"
git config --global alias.s "status -s"
git config --global alias.f "fetch"

git config --global alias.fb "!eval ${SRC_GIT_FUNCS} && git_fetch_branch"
git config --global alias.fab "!eval ${SRC_GIT_FUNCS} && git_fetch_all_branches"
git config --global alias.dm "!eval ${SRC_GIT_FUNCS} && git_delete_merged"
git config --global alias.dam "!eval ${SRC_GIT_FUNCS} && git_delete_all_merged"
git config --global alias.open "!eval ${SRC_GIT_FUNCS} && git_open"
git config --global alias.pr "!eval ${SRC_GIT_FUNCS} && git_pr"
