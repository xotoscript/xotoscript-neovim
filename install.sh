#!/bin/sh

################################# COLOR ENVIRONMENTS

NEOVIM_VERSION=0.7.0

NC='\033[0m'
BLACK='\033[0;30m'  # Black
RED='\033[0;31m'    # Red
GREEN='\033[0;32m'  # Green
YELLOW='\033[0;33m' # Yellow
BLUE='\033[0;34m'   # Blue
PURPLE='\033[0;35m' # Purple
CYAN='\033[0;36m'   # Cyan
WHITE='\033[0;37m'  # White

################################# PROGRESS ENVIRONMENTS

CODE_SAVE_CURSOR="\033[s"
CODE_RESTORE_CURSOR="\033[u"
CODE_CURSOR_IN_SCROLL_AREA="\033[1A"
COLOR_FG="\e[30m"
COLOR_BG="\e[42m"
RESTORE_FG="\e[39m"
RESTORE_BG="\e[49m"

################################# VARS

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

##################### PROGRESSBAR

function setup_scroll_area() {
	lines=$(tput lines)
	let lines=$lines-1
	echo -en "\n"
	echo -en "$CODE_SAVE_CURSOR"
	echo -en "\033[0;${lines}r"
	echo -en "$CODE_RESTORE_CURSOR"
	echo -en "$CODE_CURSOR_IN_SCROLL_AREA"
	draw_progress_bar 0
}

function destroy_scroll_area() {
	lines=$(tput lines)
	echo -en "$CODE_SAVE_CURSOR"
	echo -en "\033[0;${lines}r"
	echo -en "$CODE_RESTORE_CURSOR"
	echo -en "$CODE_CURSOR_IN_SCROLL_AREA"
	clear_progress_bar
	echo -en "\n\n"
}

function draw_progress_bar() {
	percentage=$1
	lines=$(tput lines)
	let lines=$lines
	echo -en "$CODE_SAVE_CURSOR"
	echo -en "\033[${lines};0f"
	tput el
	print_bar_text $percentage
	echo -en "$CODE_RESTORE_CURSOR"
}

function clear_progress_bar() {
	lines=$(tput lines)
	let lines=$lines
	echo -en "$CODE_SAVE_CURSOR"
	echo -en "\033[${lines};0f"
	tput el
	echo -en "$CODE_RESTORE_CURSOR"
}

function print_bar_text() {
	local percentage=$1
	let remainder=100-$percentage
	progress_bar=$(
		echo -ne "["
		echo -en "${COLOR_FG}${COLOR_BG}"
		printf_new "#" $percentage
		echo -en "${RESTORE_FG}${RESTORE_BG}"
		printf_new "." $remainder
		echo -ne "]"
	)
	if [ $1 -gt 99 ]; then
		echo -ne "${progress_bar}"
	else
		echo -ne "${progress_bar}"
	fi
}

printf_new() {
	str=$1
	num=$2
	v=$(printf "%-${num}s" "$str")
	echo -ne "${v// /$str}"
}

################################# CASES

setup_scroll_area

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

removeInstalledNvim
setup_scroll_area 10
removeInstalledLvim
setup_scroll_area 30
install
setup_scroll_area 50
createNvim
setup_scroll_area 70
createEditor
setup_scroll_area 100
sleep 1
destroy_scroll_area

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
