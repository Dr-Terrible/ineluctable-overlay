# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit cmake-multilib

DESCRIPTION="Importer library to import assets from 3D files"
HOMEPAGE="http://assimp.sourceforge.net"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
IUSE="+boost samples static-libs +tools doc"
SLOT="0"

DEPEND="sys-libs/zlib[minizip]
	boost? ( dev-libs/boost )
	samples? (
		x11-libs/libX11
		virtual/opengl
		media-libs/freeglut
	)
	doc? ( app-doc/doxygen )"

DOCS=(CREDITS CHANGES README Readme.md)
PATCHES=(
	"${FILESDIR}"/${PN}-cmake.patch
	"${FILESDIR}"/${PN}-bundled-libs.patch
)

src_prepare() {
	cmake-utils_src_prepare
	edos2unix $( find "${S}" -name "CMake*" -type f)

	# remove bundled libs
	rm -r "${S}/contrib/zlib" || die
	rm -r "${S}/contrib/unzip" || die
	rm -r "${S}/contrib/cppunit-1.12.1" || die
}

src_configure() {
	# NOTE: Assimp's CMakeLists.txt files are really screwed-up as most of the
	#       options are prefixed with ASSIMP_ and others not. Unfortunately
	#       cmake-* eclasses don't provide a way to handle non-standard
	#       declarations.
	mycmakeargs=(
		-DASSIMP_LIB_INSTALL_DIR="${EPREFIX}${PREFIX}/$( get_libdir )"
		-DASSIMP_INCLUDE_INSTALL_DIR="${EPREFIX}${PREFIX}/include"
		-DASSIMP_BIN_INSTALL_DIR="${EPREFIX}${PREFIX}/bin"
		$(_use_me_now ASSIMP_BUILD_ samples ASSIMP_SAMPLES)
		$(_use_me_now ASSIMP_BUILD_ tools ASSIMP_TOOLS)
		$(cmake-utils_use_build !static-libs SHARED_LIB)
		$(_use_me_now ASSIMP_ENABLE_ !boost BOOST_WORKAROUND)
	)
	cmake-multilib_src_configure
}

src_install() {
	cmake-multilib_src_install
	if use doc; then
		pushd doc
		doxygen || die
		dohtml -r AssimpDoc_Html/* || die
		popd
	fi
}