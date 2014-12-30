# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit cmake-utils eutils

MY_P=SFML-${PV}

DESCRIPTION="Simple and Fast Multimedia Library (SFML)"
HOMEPAGE="http://sfml.sourceforge.net/ https://github.com/LaurentGomila/SFML"
SRC_URI="https://github.com/LaurentGomila/SFML/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc examples static-libs"

RDEPEND="media-libs/freetype:2
	media-libs/glew:=
	media-libs/libpng:0=
	media-libs/libsndfile
	media-libs/mesa
	media-libs/openal
	sys-libs/zlib
	virtual/jpeg:0
	virtual/udev
	x11-libs/libX11
	x11-libs/libXrandr"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

DOCS="changelog.txt readme.txt"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${P}-no-docs.patch
	epatch "${FILESDIR}"/${P}-shared-glew.patch

	sed -i "s:DESTINATION .*:DESTINATION /usr/share/doc/${PF}:" \
		doc/CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use doc SFML_BUILD_DOC)
		$(cmake-utils_use !static-libs BUILD_SHARED_LIBS)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	insinto /usr/share/cmake/Modules
	doins cmake/Modules/FindSFML.cmake

	if use examples ; then
		docompress -x /usr/share/doc/${PF}/examples
		dodoc -r examples
		find "${ED}"/usr/share/doc/${PF}/examples -name CMakeLists.txt -delete
	fi
}
