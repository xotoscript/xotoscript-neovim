USER_HOME=$HOME

VERSION=0.6.0

if [[ "$1" == "" ]]; then
  NEOVIM_VERSION=VERSION
else
 NEOVIM_VERSION=$1
fi

################################################ EDITOR

set -ex && sudo apt-get install --yes --no-install-recommends --allow-unauthenticated \
	tmux \
	vim

sudo curl -LO https://github.com/neovim/neovim/releases/download/v${NEOVIM_VERSION}/nvim-linux64.tar.gz ${USER_HOME}/nvim-linux64.tar.gz | bash
tar xzvf ${USER_HOME}/nvim-linux64.tar.gz
sudo ln -sf ${USER_HOME}/nvim-linux64/bin/nvim /usr/bin/nvim

################################################
