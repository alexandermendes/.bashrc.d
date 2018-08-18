# Constants
WCP_CORE='~/documents/github/wcp-core'

# Start
im_start() {
  cd "${WCP_CORE}"
  vagrant up wcp_devstack 
}

# Update
im_update() {
  cd "${WCP_CORE}"
  git submodule update --recursive --remote
}

# Provision wcp_devstack with
im_vp() {
  cd "${WCP_CORE}"
  vagrant provision wcp_devstack --provision-with "$1"
}

# Update and launch the style guide for slate
im_sg() {
  cd "${WCP_CORE}"
  git submodule update ./wordpress/plugins/im-styleguide
  scripts='link_vendors,link_plugin_im-styleguide,link_theme_im-slate-theme'
  vagrant provision wcp_devstack --provision-with "$scripts"
  open "https://slate.local.wcp.imdserve.com/styleguide/"
}

