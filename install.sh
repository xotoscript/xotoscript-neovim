USERHOME=$HOME
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
if [[ "$1" = "" ]]; then
	NEOVIM_VERSION=$VERSION
else
	NEOVIM_VERSION=$1
fi

################################################ EDITOR

function install() {
	echo "☑ installing from : "
	echo "https://github.com/neovim/neovim/releases/download/v$NEOVIM_VERSION/$OS $USERHOME/$OS"
	echo ""
	sudo curl -LO https://github.com/neovim/neovim/releases/download/v$NEOVIM_VERSION/$OS $USER_HOME/$OS| bash
	sudo curl -LO $URL $USERHOME/$OS | bash
	tar xzvf $USERHOME/$OS 
	sudo ln -sf $USERHOME/$OS/bin/nvim /usr/local/bin/nvim
}

################################################ EDITOR

install

echo "complete : 🍳"

################################################
