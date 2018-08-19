# Constants
WCP_CORE='~/documents/github/wcp-core'

# Inteface
im() {
    case "$1" in
    "start" | "s")
        im_start
    ;;
    "update" | "u")
        im_update
    ;;
    "with" | "w")
        shift
        im_with "$@"
    ;;
    "stylguide" | "sg")
        im_styleguide
    ;;
    *)
        echo "Usage: $0 {start|update|with|styleguide}"
    ;;
    esac
}

# Start
im_start() {
    cd "${WCP_CORE}"
    vagrant up wcp_devstack
    code "$WCP_CORE"
}

# Update
im_update() {
    cd "${WCP_CORE}"
    git submodule update --recursive --remote
    cd "${WCP_CORE}/wordpress/themes"
    yarn install
}

# Provision wcp_devstack with
im_with() {
    local pr=$(echo "$@" | sed 's/ /,/g')
    cd "${WCP_CORE}"
    vagrant provision wcp_devstack --provision-with "$pr"
}

# Update and launch the style guide for slate
im_styleguide() {
    local pr='link_vendor,link_plugin_im-styleguide,link_theme_im-slate-theme'
    local sg='./wordpress/plugins/im-styleguide'
    local sl="${WCP_CORE}/wordpress/themes/im-slate-theme"
    cd "${WCP_CORE}"
    git submodule update "$sg"
    cd "$sg"
    composer install
    cd "$sl"
    webpack
    vagrant provision wcp_devstack --provision-with "$p"
    open "https://slate.local.wcp.imdserve.com/styleguide/"
}

