# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit eutils cmake-utils

MY_P=SFML-${PV}

DESCRIPTION="Simple and Fast Multimedia Library (SFML)"
HOMEPAGE="http://sfml.sourceforge.net/ https://github.com/LaurentGomila/SFML"
SRC_URI="https://github.com/LaurentGomila/SFML/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc examples gles1 static-libs"

RDEPEND="media-libs/flac
	media-libs/freetype:2
	media-libs/libogg:0
	media-libs/libvorbis:0
	media-libs/openal
	virtual/jpeg:0
	virtual/udev
	media-libs/mesa[egl]
	gles1? (
		media-libs/mesa[gles1]
	)
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXrandr
	x11-libs/xcb-util-image"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

DOCS="changelog.txt readme.txt"

S=${WORKDIR}/${MY_P}

src_prepare() {
	sed -i "s:DESTINATION .*:DESTINATION ${EPREFIX}/usr/share/doc/${PF}:" \
		doc/CMakeLists.txt || die
	sed -i "s:share/SFML:share/${PF}:" \
		cmake/Config.cmake || die
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DINSTALL_MISC_DIR="${EPREFIX}/usr/share/doc/${PF}"
		-DSFML_INSTALL_PKGCONFIG_FILES="TRUE"
		$(cmake-utils_use gles1 SFML_OPENGL_ES)
		$(cmake-utils_use doc SFML_BUILD_DOC)
		$(cmake-utils_use examples SFML_BUILD_EXAMPLES)
		$(cmake-utils_use !static-libs BUILD_SHARED_LIBS)
	)
	cmake-utils_src_configure
}