# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils games

DESCRIPTION="Free/Libre Action Roleplaying game"
HOMEPAGE="https://github.com/clintbellanger/flare-game"
SRC_URI="https://github.com/clintbellanger/flare-engine/archive/v${PV}.tar.gz -> ${P}-engine.tar.gz"

LICENSE="CC-BY-SA-3.0 GPL-3 OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	media-libs/libsdl[X,audio,joystick,video]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-ttf"
DEPEND="${RDEPEND}"

S=${WORKDIR}/flare-engine-${PV}

src_configure() {
	local mycmakeargs=(
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
	dodoc README.engine
	prepgamesdirs
}
