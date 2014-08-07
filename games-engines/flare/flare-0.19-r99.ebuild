# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit cmake-utils games git-2

EGIT_REPO_URI="https://github.com/clintbellanger/${PN}-engine.git"
EGIT_COMMIT="144960cefe"

DESCRIPTION="Free/Libre Action Roleplaying game"
HOMEPAGE="https://github.com/clintbellanger/flare-engine"

LICENSE="CC-BY-SA-3.0 GPL-3 OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=media-libs/libsdl2-2.0.3[X,sound,joystick,video]
	media-libs/sdl2-image[png]
	media-libs/sdl2-mixer[vorbis]
	media-libs/sdl2-ttf"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}-engine-${PV}

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
	rm "${D}"/usr/share/games/flare/mods/mods.txt || die

	dodoc README.engine
	prepgamesdirs
}
