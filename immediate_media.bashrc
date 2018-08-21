# Constants
WCP_CORE="$HOME/documents/github/wcp-core"

# Inteface
im() {
    case "$1" in
    "update" | "u")
        im_update
    ;;
    "with" | "w")
        shift
        im_with "$@"
    ;;
    "ll")
        im_with 'list_linked'
    ;;
    "lv")
        im_with 'link_vendor'
    ;;
    "styleguide" | "sg")
        im_styleguide
    ;;
    "debug_on" | "debugon")
        im_debug_on
    ;;
    "debug_off" | "debugoff")
        im_debug_off
    ;;
    *)
        echo "Usage: $0 {update|with|styleguide|debug_on|debug_off}"
    ;;
    esac
}

# Update
im_update() {
    local p=$(pwd)
    cd "${WCP_CORE}"
    vagrant box update wcp_devstack
    git submodule update --recursive --remote
    vagrant up wcp_devstack --provision
    cd "${WCP_CORE}/wordpress/themes"
    yarn install
    cd ..
    composer install --no-dev
    vagrant reload wcp_devstack
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
    local sg='/wordpress/plugins/im-styleguide'
    local sl="/wordpress/themes/im-slate-theme"
    cd "${WCP_CORE}"
    git submodule update "$sg"
    git submodule update "$sl"
    cd "${WCP_CORE}/$sg"
    composer install --no-dev
    cd "${WCP_CORE}/$sl"
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

