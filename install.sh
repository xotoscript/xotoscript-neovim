VERSION=0.6.0
SYSTEM_OSS=''
SYSTEM_OS="$(uname)"

################################################ EDITOR

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

if [[ "$1" = "" ]]; then
	NEOVIM_VERSION=$VERSION
else
	NEOVIM_VERSION=$1
fi

################################################ EDITOR

function install() {
	URL="https://github.com/neovim/neovim/releases/download/v$NEOVIM_VERSION/${SYSTEM_OSS}.tar.gz"
	echo "🖍 installing from : "
	echo $URL
	echo ""
	curl -LO $URL
	tar -xvf ${SYSTEM_OSS}.tar.gz
	rm -rf ${SYSTEM_OSS}.tar.gz
	mv ./${FILE} ${HOME}/${FILE}
	ln -sf ${HOME}/${FILE}/bin/nvim /usr/local/bin/nvim
}

function removeInstalled() {
	rm -rf ${HOME}/nvim-osx64 ${HOME}/nvim.appimage \
		/usr/local/Cellar/nvim \
		/usr/local/bin/nvim \
		${HOME}/.cache/nvim \
		${HOME}/.cache/nvim \
		${HOME}/.local/share/nvim \
		/usr/local/share/lua \
		/usr/local/Cellar/luajit-openresty \
		/usr/local/share/luajit-2.1.0-beta3 \
		/usr/local/lib/lua
}

################################################ EDITOR

if [ $(which nvim 2>/dev/null) ]; then
	echo "NEOVIM FOUND"

	echo "REMOVING"
	removeInstalled

	echo "INSTALLING"
	install

	echo ""
	echo "✅ script complete"
else
	echo "NEOVIM not found"
	install
	echo ""
	echo "✅ script complete"
fi

################################################
