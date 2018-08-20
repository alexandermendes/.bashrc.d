# Constants
WCP_CORE="$HOME/documents/github/wcp-core"

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
    "debug_on")
        im_debug_on
    ;;
    "debug_off")
        im_debug_off
    ;;
    *)
        echo "Usage: $0 {start|update|with|styleguide|debug_on|debug_off}"
    ;;
    esac
}

# Start
im_start() {
    local p=$(pwd)
    cd "${WCP_CORE}"
    vagrant up wcp_devstack
    code "$WCP_CORE"
    cd "$p"
}

# Update
im_update() {
    local p=$(pwd)
    cd "${WCP_CORE}"
    vagrant box update wcp_devstack
    git submodule update --recursive --remote
    cd "${WCP_CORE}/wordpress/themes"
    yarn install
    cd ..
    composer install --no-dev
    cd "$p"
}

# Provision wcp_devstack with
im_with() {
    local p=$(pwd)
    local pr=$(echo "$@" | sed 's/ /,/g')
    cd "${WCP_CORE}"
    vagrant provision wcp_devstack --provision-with "$pr"
    cd "$p"
}

# Update and launch the style guide for slate
im_styleguide() {
    local p=$(pwd)
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
    cd "$p"
}

# Turn on debugging
im_debug_on() {
    local p=$(pwd)
    cd "${WCP_CORE}"
    local pattern="s/php_admin_flag\[display_errors\] = off/php_admin_flag[display_errors] = on/g"
    vagrant ssh wcp_devstack -c "sudo sed -i '$pattern' /etc/php-fpm.d/wcp.conf && sudo service php-fpm restart"
    cd "$p"
}

# Turn off debugging
im_debug_off() {
    local p=$(pwd)
    cd "${WCP_CORE}"
    local pattern="s/php_admin_flag\[display_errors\] = on/php_admin_flag[display_errors] = off/g"
    vagrant ssh wcp_devstack -c "sudo sed -i '$pattern' /etc/php-fpm.d/wcp.conf && sudo service php-fpm restart"
    cd "$p"
}

