USER_HOME=$HOME
BYPASS=true
VERSION=0.6.0
NEOVIM_VERSION=""
MAIN_BYPASS=""

################################################ EDITOR

# CHECK VERSION
if [[ "$1" = "" ]]; then
	NEOVIM_VERSION=$VERSION
else
	NEOVIM_VERSION=$1
fi

# CHECK BYPASS
if [[ "$2" = "" ]]; then
	MAIN_BYPASS=false
else
	MAIN_BYPASS=$BYPASS
fi

################################################ EDITOR

function install() {
	sudo curl -LO https://github.com/neovim/neovim/releases/download/v${NEOVIM_VERSION}/nvim-linux64.tar.gz ${USER_HOME}/nvim-linux64.tar.gz | bash
	tar xzvf ${USER_HOME}/nvim-linux64.tar.gz
	sudo ln -sf ${USER_HOME}/nvim-linux64/bin/nvim /usr/bin/nvim
}

################################################ EDITOR

if [[ $(which vim 2>/dev/null) || $MAIN_BYPASS ]]; then
	echo "vim found"
	install
else
	echo "vim is not found please install it "

fi

echo "complete : "

################################################
