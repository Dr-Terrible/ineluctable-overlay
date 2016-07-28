# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
CMAKE_IN_SOURCE_BUILD=1
inherit cmake-utils

EGIT_PN="${PN}-engine"
EGIT_COMMIT="e8d0dab83f9b963a792d129d5f6e791d61af1966"

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
		-DBINDIR="/usr/bin"
		-DDATADIR="/usr/share/${PN}"
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
