# Constants
WCP_CORE='~/documents/github/wcp-core'

# Start
imstart() {
  cd "${WCP_CORE}"
  vagrant up wcp_devstack 
}

# Update
imupdate() {
  cd "${WCP_CORE}"
  git submodule update --recursive --remote
}

# Provision wcp_devstack with
imvp() {
  cd "${WCP_CORE}"
  vagrant provision wcp_devstack --provision-with "$1"
}

# Update and launch the style guide for slate
imsg() {
  cd "${WCP_CORE}"
  git submodule update ./wordpress/plugins/im-styleguide
  scripts='link_vendors,link_plugin_im-styleguide,link_theme_im-slate-theme'
  vagrant provision wcp_devstack --provision-with "$scripts"
  open "https://slate.local.wcp.imdserve.com/styleguide/"
}

