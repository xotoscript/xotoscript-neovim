USER_HOME=$HOME
VERSION=0.6.0

################################################ EDITOR

# Detect the platform (similar to $OSTYPE)
OS="$(uname)"
case $OS in
'Linux')
	OS='nvim-linux64.tar.gz'
	;;
'Darwin')
	OS='nvim-macos.tar.gz'
	;;
*) ;;
esac

# CHECK VERSION
if [[ "$1" == "" ]]; then
	NEOVIM_VERSION=$VERSION
else
	NEOVIM_VERSION=$1
fi

################################################ EDITOR

function install() {
	echo "☑ installing from : "
	echo "https://github.com/neovim/neovim/releases/download/v${NEOVIM_VERSION}/nvim-linux64.tar.gz ${USER_HOME}/${OS}"
	sudo curl -LO https://github.com/neovim/neovim/releases/download/v${NEOVIM_VERSION}/nvim-linux64.tar.gz ${USER_HOME}/${OS} | bash
	tar xzvf ${USER_HOME}/nvim-linux64.tar.gz
	sudo ln -sf ${USER_HOME}/nvim-linux64/bin/nvim /usr/bin/nvim
}

################################################ EDITOR

install

echo "complete : 🍳"

################################################
