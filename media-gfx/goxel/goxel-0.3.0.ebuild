# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit scons-utils

DESCRIPTION="Open source 3D voxel editor"
HOMEPAGE="https://github.com/guillaumechereau/goxel"
SRC_URI="https://github.com/guillaumechereau/${PN}/archive/v${PV}.tar.gz -> ${PF}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug"
RESTRICT="mirror"

DEPEND=">=media-libs/glfw-3.1.1
	dev-libs/atk:0
	dev-libs/glib:2
	virtual/opengl
	sys-libs/zlib:0
	x11-libs/cairo:0
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/pango:0"

src_prepare(){
	sed -i \
		-e "s:-Werror::" \
		-e "s:-Wall::" \
		SConstruct || die

	# remove bundled libs
	rm -r ext_src/glew || die
	default
}

src_configure() {
	MYSCONS=(
		CCFLAGS="$CXXFLAGS"
#		CFLAGS="$CFLAGS"
#		CXXFLAGS="$CXXFLAGS"
		debug=$(usex debug debug 0 1)
	)
}

src_compile() {
	escons "${MYSCONS[@]}"
}

src_install() {
	dobin ${PN}
}
