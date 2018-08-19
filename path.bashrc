# Constants
EGREP=$(which egrep)

# Add to PATH
pathmunge () {
    if ! echo $PATH | $EGREP -q "(^|:)$1($|:)" ; then
        if [ "$2" = "after" ] ; then
            PATH=$PATH:$1
        else
            PATH=$1:$PATH
        fi
    fi
}

# VSCode
pathmunge "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# NPM
# pathmunge "$HOME/.npm-packages/bin"
