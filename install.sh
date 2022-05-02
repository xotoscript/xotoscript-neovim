USER_HOME=$HOME
NEOVIM_VERSION=0.6.0
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
	NEOVIM_VERSION=$NEOVIM_VERSION
else
	NEOVIM_VERSION=$1
fi

################################################ EDITOR

function install() {
	URL="https://github.com/neovim/neovim/releases/download/v${NEOVIM_VERSION}/${OS}"
	echo "☑ installing from : "
	echo "$URL ${USER_HOME}/${OS}"
	echo ""
	sudo curl -LO $URL ${USER_HOME}/${OS} | bash
	tar xzvf ${USER_HOME}/${OS}
	sudo ln -sf ${USER_HOME}/${OS}/bin/nvim /usr/local/bin/nvim
}

################################################ EDITOR

install

echo "complete : 🍳"

################################################
