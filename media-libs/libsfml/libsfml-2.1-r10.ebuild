# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit flag-o-matic cmake-utils eutils

MY_P=SFML-${PV}

DESCRIPTION="Simple and Fast Multimedia Library (SFML)"
HOMEPAGE="http://sfml.sourceforge.net/ https://github.com/LaurentGomila/SFML"
SRC_URI="https://github.com/LaurentGomila/SFML/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc examples static-libs"

RDEPEND="media-libs/freetype:2
	media-libs/glew:0
	media-libs/libpng:0=
	media-libs/libsndfile
	media-libs/mesa
	media-libs/openal
	sys-libs/zlib
	virtual/jpeg:0
	x11-libs/libX11
	x11-libs/libXrandr"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

DOCS="readme.txt"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.0_pre20121126-shared-glew.patch
	epatch "${FILESDIR}"/${PN}-2.0-cmake-modules.patch

	sed -i "s:DESTINATION .*:DESTINATION /usr/share/doc/${PF}:" \
		doc/CMakeLists.txt || die
}

src_configure() {
	append-flags -fPIC
	local mycmakeargs=(
		$(cmake-utils_use doc SFML_BUILD_DOC)
		$(cmake-utils_use !static-libs BUILD_SHARED_LIBS)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	if use examples ; then
		docompress -x /usr/share/doc/${PF}/examples
		dodoc -r examples
		find "${ED}"/usr/share/doc/${PF}/examples -name CMakeLists.txt -delete
	fi
}
