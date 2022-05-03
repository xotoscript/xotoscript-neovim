#!/bin/sh

################################# COLOR ENVIRONMENTS

NEOVIM_VERSION=0.7.0

NC='\033[0m'
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'

################################# VARS

SYSTEM_MACHINE=''
SYSTEM_OS="$(uname)"

################################# CLEAN

trap cleanup 1 2 3 6
PROXY_ID=''
cleanup() {
	echo "Cleanup..."
	kill -9 ${PROXY_ID}
	echo "Done cleanup ... quitting."
	exit 1
}

##################### PROGRESSBAR

function progress_bar() {
	bar=""
	total=10
	[[ -z $1 ]] && input=0 || input=${1}
	x="##"
	for i in $(seq 1 10); do
		if [ $i -le $input ]; then
			bar=$bar$x
		else
			bar="$bar  "
		fi
	done
	#pct=$((200*$input/$total % 2 + 100*$input/$total))
	pct=$(($input * 10))
	echo -ne "Progress : [ ${bar} ] (${pct}%) \r"
	sleep 1
	if [ $input -eq 10 ]; then
		echo -ne '\n'
	fi

}
################################# CASES

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

################################# INSTALL

function install() {
	echo ""
	echo "${GREEN} 🧑🏽‍💻 INSTALLING NVIM${NC}"
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

################################# REMOVE NVIM

function removeInstalledNvim() {
	echo ""
	echo "${RED} ❌ REMOVING NVIM${NC}"
	echo ""
	rm -rf ${HOME}/nvim-osx64 ${HOME}/nvim.appimage /usr/local/Cellar/nvim /usr/local/bin/nvim ${HOME}/.cache/nvim ${HOME}/.cache/nvim ${HOME}/.local/share/nvim /usr/local/share/lua /usr/local/Cellar/luajit-openresty /usr/local/share/luajit-2.1.0-beta3 /usr/local/lib/lua
}

################################# REMOVE LVIM

function removeInstalledLvim() {
	echo ""
	echo "${RED} ❌ REMOVING LVIM${NC}"
	echo ""
	bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/uninstall.sh)
}

################################# CREATE NVIM FOLDER

function createNvim() {
	if [ ! -d "${HOME}/.config" ]; then
		echo ""
		echo "${RED} ❌ NO ./.CONFIG CREATING${NC}"
		echo ""
		mkdir ${HOME}/.config
	fi
}

################################# CREATE EDITOR

function createEditor() {
	if [ -d "${HOME}/.config/nvim" ]; then
		echo ""
		echo "${RED} ❌ REMOVING NVIM FROM ./.CONFIG FOLDER${NC}"
		echo ""
		rm -rf ${HOME}/.config/nvim
		echo ""
		echo "${GREEN} 🧑🏽‍💻 INSTALLING LVIM${NC}"
		echo ""

		bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh) -y

		echo ""
		echo "${GREEN} 🧑🏽‍💻 INSTALLING COSMIC-NVIM${NC}"
		echo ""

		git clone git@github.com:CosmicNvim/CosmicNvim.git ${HOME}/.config/nvim
	else
		echo ""
		bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh) -y
		git clone git@github.com:CosmicNvim/CosmicNvim.git ${HOME}/.config/nvim
	fi
}

################################# PROCESS

progress_bar 1
removeInstalledNvim
progress_bar 2
removeInstalledLvim
progress_bar 3
install
progress_bar 5
createNvim
progress_bar 8
createEditor
progress_bar 10

echo ""

################################# END

echo "${YELLOW}.########.####.##....##.####..######..##.....##.########.########.${NC}"
echo "${YELLOW}.##........##..###...##..##..##....##.##.....##.##.......##.....##${NC}"
echo "${YELLOW}.##........##..####..##..##..##.......##.....##.##.......##.....##${NC}"
echo "${YELLOW}.######....##..##.##.##..##...######..#########.######...##.....##${NC}"
echo "${YELLOW}.##........##..##..####..##........##.##.....##.##.......##.....##${NC}"
echo "${YELLOW}.##........##..##...###..##..##....##.##.....##.##.......##.....##${NC}"
echo "${YELLOW}.##.......####.##....##.####..######..##.....##.########.########.${NC}"

echo ""
echo ""
echo "${YELLOW} 🖍 NOW JUST RUN : ${NC}"
echo ""
echo "${GREEN}nvim +PackerSync # to install and run all deps for nvim ${NC}"
echo "${GREEN}lvim +PackerSync # to install and run all deps for lvim ${NC}"
echo ""
echo ""

################################# END
