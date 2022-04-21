# Git aware prompt
export GITAWAREPROMPT="$Home/.bash/git-aware-prompt"
source "${GITAWAREPROMPT}/main.sh"
export PS1="\u@\h \W \[$txtcyn\]\$git_branch\[$txtred\]\$git_dirty\[$txtrst\]\$ "
