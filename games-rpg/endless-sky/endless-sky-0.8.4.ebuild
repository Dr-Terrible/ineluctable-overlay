# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit scons-utils games

DESCRIPTION="Space exploration, trading, and combat game"
HOMEPAGE="http://endless-sky.github.io"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="mirror"

DEPEND="media-libs/glew:0/1.10
	media-libs/libpng:0/16
	media-libs/libsdl2:0[opengl,gles]
	virtual/jpeg:0
	virtual/opengl
	media-libs/openal:0"
RDEPEND="${DEPEND}"

src_prepare(){
	sed -i \
		-e "s:\$PREFIX/games:\$PREFIX/games/bin:" \
		SConstruct || die
}
src_configure() {
	myesconsargs=(
		CC="$(tc-getCC)"
	)
}
src_compile() {
	escons
}
src_install() {
	escons DESTDIR="${D}" PREFIX="/usr" install
}

#src_install() {
#	cmake-utils_src_install
#
#	games_make_wrapper "flare-game" "flare --game=flare-game"
#	make_desktop_entry "flare-game" "Flare (game)"
#
#	docinto game
#	dodoc README
#	prepgamesdirs
#}

pkg_preinst() {
	games_pkg_preinst
#	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
#	gnome2_icon_cache_update
}

#pkg_postrm() {
#	gnome2_icon_cache_update
#}