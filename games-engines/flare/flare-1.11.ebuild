# Copyright 1999-2021 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake

DESCRIPTION="Free/Libre Action Roleplaying game"
HOMEPAGE="https://github.com/flareteam/${PN}-engine"
SRC_URI="https://github.com/flareteam/${PN}-engine/archive/v${PV}.tar.gz -> ${P}-engine.tar.gz"

LICENSE="CC-BY-SA-3.0 GPL-3 OFL-1.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="cpu_flags_x86_sse"
RESTRICT="mirror"

RDEPEND="media-libs/libsdl2:=[X,sound,joystick,video,cpu_flags_x86_sse?]
	media-libs/sdl2-image[png]
	media-libs/sdl2-mixer[vorbis]
	media-libs/sdl2-ttf"

S="${WORKDIR}/${PN}-engine-${PV}"

DOCS=(README.engine.md)

src_configure() {
	local mycmakeargs=(
		-DBINDIR="/usr/bin"
		-DDATADIR="/usr/share/${PN}"
	)
	cmake_src_configure
}
