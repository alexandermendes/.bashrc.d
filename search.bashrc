# Google
google() {
    q="$@"
    open "http://www.google.com/search?q=$q"
}

# Stack Overflow
so() {
    q="$@"
    open "http://www.stackoverflow.com/search?q=$q"
}

# Processes
alias pgrep='ps aux | grep'

# File system
alias qfind="find . -name "
