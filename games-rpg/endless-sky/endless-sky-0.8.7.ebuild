# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit scons-utils gnome2-utils games

ECOMMIT="7b0d801c04e15a6cdf57922296bbcd24ea7f9101"

DESCRIPTION="Space exploration, trading, and combat game"
HOMEPAGE="http://endless-sky.github.io"
SRC_URI="https://github.com/${PN}/${PN}/archive/${ECOMMIT}.tar.gz -> ${P}.tar.gz"

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

S="${WORKDIR}/${PN}-${ECOMMIT}"

src_prepare(){
	sed -i \
		-e "s:\$PREFIX/games:\$PREFIX/games/bin:" \
		SConstruct || die
}

src_compile() {
	escons
}

src_install() {
	escons DESTDIR="${D}" PREFIX="/usr" install
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}