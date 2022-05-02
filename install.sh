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

################################################ EDITOR

install
echo ""
echo "✅ script complete"

################################################
