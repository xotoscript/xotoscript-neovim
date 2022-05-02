USER_HOME=$HOME
NEOVIM_VERSION=0.7.0

################################################ EDITOR

set -ex && sudo apt-get install --yes --no-install-recommends --allow-unauthenticated \
	tmux \
	vim

sudo curl -LO https://github.com/neovim/neovim/releases/download/v${NEOVIM_VERSION}/nvim-linux64.tar.gz ${USER_HOME}/nvim-linux64.tar.gz | bash
tar xzvf ${USER_HOME}/nvim-linux64.tar.gz
sudo ln -sf ${USER_HOME}/nvim-linux64/bin/nvim /usr/bin/nvim

################################################
