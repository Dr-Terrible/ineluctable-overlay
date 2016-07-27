# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-utils

DESCRIPTION="The Portable OpenGL FrameWork"
HOMEPAGE="http://www.glfw.org"
SRC_URI="mirror://sourceforge/glfw/${P}.tar.bz2"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="amd64 hppa x86"
IUSE="egl examples doc"

RDEPEND="x11-libs/libXrandr
	x11-libs/libX11
	x11-libs/libXi
	x11-libs/libXxf86vm
	x11-libs/libXinerama
	x11-libs/libXcursor
	virtual/opengl"
DEPEND=${RDEPEND}

src_configure() {
	local mycmakeargs="
		$(cmake-utils_use egl GLFW_USE_EGL)
		$(cmake-utils_use examples GLFW_BUILD_EXAMPLES)
		$(cmake-utils_use doc GLFW_BUILD_DOCS)
		-DBUILD_SHARED_LIBS=1
	"
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	use doc && dodoc -r docs/html
	use examples && dodoc -r examples
}
