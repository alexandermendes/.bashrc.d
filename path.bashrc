# Add to PATH
pathmunge () {
    if ! echo $PATH | $(which egrep) -q "(^|:)$1($|:)" ; then
        if [ "$2" = "after" ] ; then
            PATH=$PATH:$1
        else
            PATH=$1:$PATH
        fi
    fi
}

# Bin directories
pathmunge /sbin
pathmunge /usr/sbin
pathmunge /usr/local/sbin
pathmunge /bin
pathmunge /usr/bin
pathmunge /opt/local/bin
pathmunge /usr/local/bin
pathmunge "$HOME/bin"

# VSCode
pathmunge "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# NPM
pathmunge "$HOME/.npm-packages/bin"

# Node 8
pathmunge "/usr/local/opt/node@8/bin"
