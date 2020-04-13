# Copyright 1999-2020 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{5,6,7} )
inherit python-any-r1 scons-utils

DESCRIPTION="Open source 3D voxel editor"
HOMEPAGE="https://github.com/guillaumechereau/goxel"
SRC_URI="https://github.com/guillaumechereau/${PN}/archive/v${PV}.tar.gz -> ${PF}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug"
RESTRICT="mirror"

DEPEND="media-libs/glfw[-wayland]
	dev-libs/atk:0
	dev-libs/glib:2
	virtual/opengl
	sys-libs/zlib:0
	x11-libs/cairo:0
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/pango:0"

src_prepare(){
	# remove bundled libs
	rm -r ext_src/glew || die
	default
}

src_configure() {
	MYSCONS=(
#		CCFLAGS="$CXXFLAGS"
		werror=0
		debug=$(usex debug debug 0 1)
#		sound=$(usex sound sound 0 1)
	)
}

src_compile() {
	escons "${MYSCONS[@]}" mode=release
}

src_install() {
	dobin ${PN}
}
