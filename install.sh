#!/bin/sh

NEOVIM_VERSION=0.7.0

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

SYSTEM_MACHINE=''
SYSTEM_OS="$(uname)"

trap cleanup 1 2 3 6
PROXY_ID=''
cleanup() {
	echo "Cleanup..."
	kill -9 ${PROXY_ID}
	echo "Done cleanup ... quitting."
	exit 1
}

################################################ CASES

case $SYSTEM_OS in
'Linux')
	SYSTEM_MACHINE='nvim-linux64'
	FILE='nvim-linux64'
	;;
'Darwin')
	SYSTEM_MACHINE='nvim-macos'
	FILE="nvim-osx64"
	;;
*) ;;
esac

################################################ INSTALL

function install() {
	echo "${GREEN}Installing NVIM...${NC}"
	echo ""
	URL="https://github.com/neovim/neovim/releases/download/v${NEOVIM_VERSION}/${SYSTEM_MACHINE}.tar.gz"
	echo $URL
	echo ""
	curl -LO $URL
	tar xzvf ${SYSTEM_MACHINE}.tar.gz >/dev/null 2>&1
	rm -rf ${SYSTEM_MACHINE}.tar.gz
	mv ./${FILE} ${HOME}/${FILE}
	ln -sf ${HOME}/${FILE}/bin/nvim /usr/local/bin/nvim
}

################################################ REMOVE

function removeInstalled() {
	echo "${RED}REMOVING NVIM...${NC}"
	echo ""
	rm -rf ${HOME}/nvim-osx64 ${HOME}/nvim.appimage /usr/local/Cellar/nvim /usr/local/bin/nvim ${HOME}/.cache/nvim ${HOME}/.cache/nvim ${HOME}/.local/share/nvim /usr/local/share/lua /usr/local/Cellar/luajit-openresty /usr/local/share/luajit-2.1.0-beta3 /usr/local/lib/lua
}

################################################ CREATE NVIM FOLDER

function createNvim() {
	if [ ! -d "${HOME}/.config" ]; then
		echo "${RED}NO .CONFIG CREATING...${NC}"
		echo ""
		mkdir ${HOME}/.config
	fi
}

################################################ CREATE EDITOR

function createEditor() {
	if [ -d "${HOME}/.config/nvim" ]; then
		echo "${RED}REMOVING NVIM FROM .CONFIG FOLDER...${NC}"
		echo ""
		rm -rf ${HOME}/.config/nvim
		bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh) -y
	else
		bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh) -y
	fi
}

################################################ PROCESS

removeInstalled
install
createNvim
createEditor

echo ""
echo "${GREEN}COMPLETED... 🥘${NC}"

lvim +PackerSync

################################################ END
