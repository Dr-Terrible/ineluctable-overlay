# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit cmake-utils games

EGIT_PN="${PN}-engine"
EGIT_COMMIT="28ab56f5a54de51ff4b38a4915c1ea63a13cf6bf"

DESCRIPTION="Free/Libre Action Roleplaying game"
HOMEPAGE="https://github.com/clintbellanger/flare-engine"
SRC_URI="https://github.com/clintbellanger/${EGIT_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${EGIT_PN}-${EGIT_COMMIT}.tar.gz"

LICENSE="CC-BY-SA-3.0 GPL-3 OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cpu_flags_x86_sse"
RESTRICT="mirror"

RDEPEND="media-libs/libsdl2:=[X,sound,joystick,video,cpu_flags_x86_sse?]
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
	dodoc README.md
	prepgamesdirs
}
