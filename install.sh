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

progreSh() {
	LR='\033[1;31m'
	LG='\033[1;32m'
	LY='\033[1;33m'
	LC='\033[1;36m'
	LW='\033[1;37m'
	NC='\033[0m'
	if [ "${1}" = "0" ]; then TME=$(date +"%s"); fi
	SEC=$(printf "%04d\n" $(($(date +"%s") - ${TME})))
	SEC="$SEC sec"
	PRC=$(printf "%.0f" ${1})
	SHW=$(printf "%3d\n" ${PRC})
	LNE=$(printf "%.0f" $((${PRC} / 2)))
	LRR=$(printf "%.0f" $((${PRC} / 2 - 12)))
	if [ ${LRR} -le 0 ]; then LRR=0; fi
	LYY=$(printf "%.0f" $((${PRC} / 2 - 24)))
	if [ ${LYY} -le 0 ]; then LYY=0; fi
	LCC=$(printf "%.0f" $((${PRC} / 2 - 36)))
	if [ ${LCC} -le 0 ]; then LCC=0; fi
	LGG=$(printf "%.0f" $((${PRC} / 2 - 48)))
	if [ ${LGG} -le 0 ]; then LGG=0; fi
	LRR_=""
	LYY_=""
	LCC_=""
	LGG_=""
	for ((i = 1; i <= 13; i++)); do
		DOTS=""
		for ((ii = ${i}; ii < 13; ii++)); do DOTS="${DOTS}."; done
		if [ ${i} -le ${LNE} ]; then LRR_="${LRR_}#"; else LRR_="${LRR_}."; fi
		echo -ne "${2} ${LW}${SEC}  ${LR}${LRR_}${DOTS}${LY}............${LC}............${LG}............ ${SHW}%${NC}\r"
		if [ ${LNE} -ge 1 ]; then sleep .05; fi
	done
	for ((i = 14; i <= 25; i++)); do
		DOTS=""
		for ((ii = ${i}; ii < 25; ii++)); do DOTS="${DOTS}."; done
		if [ ${i} -le ${LNE} ]; then LYY_="${LYY_}#"; else LYY_="${LYY_}."; fi
		echo -ne "${2} ${LW}${SEC}  ${LR}${LRR_}${LY}${LYY_}${DOTS}${LC}............${LG}............ ${SHW}%${NC}\r"
		if [ ${LNE} -ge 14 ]; then sleep .05; fi
	done
	for ((i = 26; i <= 37; i++)); do
		DOTS=""
		for ((ii = ${i}; ii < 37; ii++)); do DOTS="${DOTS}."; done
		if [ ${i} -le ${LNE} ]; then LCC_="${LCC_}#"; else LCC_="${LCC_}."; fi
		echo -ne "${2} ${LW}${SEC}  ${LR}${LRR_}${LY}${LYY_}${LC}${LCC_}${DOTS}${LG}............ ${SHW}%${NC}\r"
		if [ ${LNE} -ge 26 ]; then sleep .05; fi
	done
	for ((i = 38; i <= 49; i++)); do
		DOTS=""
		for ((ii = ${i}; ii < 49; ii++)); do DOTS="${DOTS}."; done
		if [ ${i} -le ${LNE} ]; then LGG_="${LGG_}#"; else LGG_="${LGG_}."; fi
		echo -ne "${2} ${LW}${SEC}  ${LR}${LRR_}${LY}${LYY_}${LC}${LCC_}${LG}${LGG_}${DOTS} ${SHW}%${NC}\r"
		if [ ${LNE} -ge 38 ]; then sleep .05; fi
	done
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

function installNvim() {
	URL="https://github.com/neovim/neovim/releases/download/v${NEOVIM_VERSION}/${SYSTEM_MACHINE}.tar.gz"
	curl -LO $URL
	tar xzvf ${SYSTEM_MACHINE}.tar.gz >/dev/null 2>&1
	rm -rf ${SYSTEM_MACHINE}.tar.gz
	mv ./${FILE} ${HOME}/${FILE}
	ln -sf ${HOME}/${FILE}/bin/nvim /usr/local/bin/nvim
}

################################# REMOVE NVIM

function removeInstalledNvim() {
	rm -rf ${HOME}/nvim-osx64 ${HOME}/nvim.appimage /usr/local/Cellar/nvim /usr/local/bin/nvim ${HOME}/.cache/nvim ${HOME}/.cache/nvim ${HOME}/.local/share/nvim /usr/local/share/lua /usr/local/Cellar/luajit-openresty /usr/local/share/luajit-2.1.0-beta3 /usr/local/lib/lua
}

################################# REMOVE LVIM

function removeInstalledLvim() {
	bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/uninstall.sh)
}

################################# CREATE NVIM FOLDER

function createNvimDir() {
	if [ ! -d "${HOME}/.config" ]; then
		mkdir ${HOME}/.config
	fi
}

################################# CREATE EDITOR

function createEditor() {
	if [ -d "${HOME}/.config/nvim" ]; then
		rm -rf ${HOME}/.config/nvim
		bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh) -y
		git clone git@github.com:CosmicNvim/CosmicNvim.git ${HOME}/.config/nvim
	else
		bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh) -y
		git clone git@github.com:CosmicNvim/CosmicNvim.git ${HOME}/.config/nvim
	fi
}

################################# PROCESS

printf "\n\n\n\n\n\n\n\n\n\n"
progreSh 0 "${RED} ❌ REMOVING NVIM${NC}"
removeInstalledNvim
progreSh 20 "${RED} ❌ REMOVING LVIM{NC}"
removeInstalledLvim
progreSh 40 "${GREEN} 🧑🏽‍💻 DOWNLOADING NEOVIM${NC}"
installNvim
progreSh 60 "${GREEN} 🧑🏽‍💻 SETTING UP NVIM DIR ${NC}"
createNvimDir
progreSh 80 "${GREEN} 🧑🏽‍💻 INSTALLING COSMICVIM AND LVIM ${NC}"
createEditor
progreSh 100 "${PURPLE} 🖍 CLEANING UP ${NC}"
printf "\n\n\n\n\n\n\n\n\n\n"

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
echo "${YELLOW} NOW JUST RUN : ${NC}"
echo ""
echo "${GREEN}nvim +PackerSync # to install and run all deps for nvim ${NC}"
echo "${GREEN}lvim +PackerSync # to install and run all deps for lvim ${NC}"
echo ""
echo ""

################################# END
