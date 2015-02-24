# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit cmake-utils games

EGIT_PN="${PN}-engine"
EGIT_COMMIT="6cb89759831f6960605494f388f272a16f595121"

DESCRIPTION="Free/Libre Action Roleplaying game"
HOMEPAGE="https://github.com/clintbellanger/flare-engine"
SRC_URI="https://github.com/clintbellanger/${EGIT_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${EGIT_PN}-${EGIT_COMMIT}.tar.gz"

LICENSE="CC-BY-SA-3.0 GPL-3 OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="
	>=media-libs/libsdl2-2.0.3[X,sound,joystick,video]
	media-libs/sdl2-image[png]
	media-libs/sdl2-mixer[vorbis]
	media-libs/sdl2-ttf"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${EGIT_PN}-${EGIT_COMMIT}"
DOCS=()

src_configure() {
	local mycmakeargs=(
		-DUSE_SDL2=ON
		-DSDL1_FALLBACK=FALSE
		-DBINDIR="${GAMES_BINDIR}"
		-DDATADIR="${GAMES_DATADIR}/${PN}"
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install

	docinto engine
	dodoc README.engine README.md
	prepgamesdirs
}
