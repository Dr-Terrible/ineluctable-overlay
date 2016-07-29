# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
AUTOTOOLS_IN_SOURCE_BUILD=1
inherit autotools-utils flag-o-matic

MY_PN=${PN/o-a/oa}
MY_P=${P/o-a/oa}
SRC_HOME="http://sourceforge.net/projects/${MY_PN}/files/UFO_AI%202.x/${PV}"

DESCRIPTION="UFO: Alien Invasion - X-COM inspired strategy game"
HOMEPAGE="http://ufoai.sourceforge.net"
SRC_URI="${SRC_HOME}/${MY_P}-source.tar.bz2
	${SRC_HOME}/${MY_P}-data.tar"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug dedicated editor +game sse doc"

RESTRICT="mirror"

DEPEND="!dedicated? (
		virtual/opengl
		virtual/glu
		media-libs/libsdl2
		media-libs/sdl2-image[jpeg,png]
		media-libs/sdl2-ttf
		media-libs/sdl2-mixer
		virtual/jpeg
		media-libs/libpng:0
		media-libs/libogg
		media-libs/libvorbis
		x11-proto/xf86vidmodeproto
	)
	net-misc/curl
	sys-devel/gettext
	sys-libs/zlib
	editor? (
		dev-libs/libxml2
		virtual/jpeg
		media-libs/openal
		x11-libs/gtkglext
		x11-libs/gtksourceview:2.0
	)
	doc? ( app-doc/doxygen )"

S=${WORKDIR}/${MY_P}-source

DOCS=(README)

src_prepare() {
	mv "${WORKDIR}"/base "${S}" || die
}

src_configure() {
	local myeconfargs=(
		--disable-cgame-campaign
		--disable-cgame-multiplayer
		--disable-cgame-skirmish
		--disable-memory
		--disable-testall
		--disable-ufomodel
		--disable-ufoslicer
		--disable-dependency-tracking
		$(use_enable !debug release)
		$(use_enable editor ufo2map)
		$(use_enable editor uforadiant)
		$(use_enable sse)
		$(use_enable game ufo)
		$(use_enable dedicated ufoded)
		--enable-game
		--target-os=linux
		--bindir="/bin/dir"
		--libdir="$(games_get_libdir)"
		--datadir="/usr/share/${PN/-}"
		--localedir="${EPREFIX}/usr/share/locale/"
		--prefix="/usr/games"
	)
	./configure ${myeconfargs[@]} || die
}

src_compile() {
	# compile game engine
	autotools-utils_src_compile

	# compile languages
	emake lang || die

	# compile editor
	if use editor; then
		emake uforadiant || die
	fi

	# generated documentation
	if use doc; then
		emake doxygen-docs || die
	fi
}

src_install() {
	# install game engine and data
	autotools-utils_src_install
	newicon src/ports/linux/ufo.png ${PN}.png || die
	use game && make_desktop_entry ufo "UFO: Alien Invasion" ${PN}

	if ! use dedicated; then
		rm "${ED}"/usr/bin/ufoded || die
	fi
	use dedicated && make_desktop_entry ufoded "UFO: Alien Invasion Server" ${PN}

	if ! use editor; then
		rm "${ED}"/usr/bin/uforadiant || die
	fi

	prepgamesdirs
}
