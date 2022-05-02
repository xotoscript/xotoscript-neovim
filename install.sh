#!/bin/sh

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

SYSTEM_OSS=''
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
	SYSTEM_OSS='nvim-linux64'
	;;
'Darwin')
	SYSTEM_OSS='nvim-macos'
	FILE="nvim-osx64"
	;;
*) ;;
esac

################################################ INSTALL

function install() {
	echo "${GREEN}Installing NVIM...${NC}"
	URL="https://github.com/neovim/neovim/releases/download/v$VERSION/${SYSTEM_OSS}.tar.gz"
	echo $URL
	echo ""
	curl -LO $URL
	tar xzvf ${SYSTEM_OSS}.tar.gz
	rm -rf ${SYSTEM_OSS}.tar.gz
	mv ./${FILE} ${HOME}/${FILE}
	ln -sf ${HOME}/${FILE}/bin/nvim /usr/local/bin/nvim
}

################################################ REMOVE

function removeInstalled() {
	echo "${RED}REMOVING NVIM...${NC}"
	rm -rf ${HOME}/nvim-osx64 ${HOME}/nvim.appimage /usr/local/Cellar/nvim /usr/local/bin/nvim ${HOME}/.cache/nvim ${HOME}/.cache/nvim ${HOME}/.local/share/nvim /usr/local/share/lua /usr/local/Cellar/luajit-openresty /usr/local/share/luajit-2.1.0-beta3 /usr/local/lib/lua
}

################################################ PROCESS

if [ $(which nvim 2>/dev/null) ]; then
	echo "${GREEN}NVIM FOUND...${NC}"

	removeInstalled

	install

	echo ""
	echo "${GREEN}COMPLETED...${NC}"
else
	echo "${GREEN}NVIM NOT FOUND...${NC}"

	install

	echo ""
	echo "${RED}NVIM INSTALL WITHOUT REMOVE...${NC}"

fi

################################################ END
