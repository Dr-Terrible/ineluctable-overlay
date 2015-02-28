# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit python-any-r1 cmake-multilib

DESCRIPTION="C++ JSON reader and writer"
HOMEPAGE="https://github.com/open-source-parsers/jsoncpp"
SRC_URI="https://github.com/open-source-parsers/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="doc test static-libs"

DEPEND="doc? (
	app-doc/doxygen
	${PYTHON_DEPS}
)"
RDEPEND=""

pkg_setup() {
	use doc && python-any-r1_pkg_setup
}

pkg_pretend() {
	# checks for gcc version
	if [[ $(gcc-major-version) -lt 4 ]] || \
		( [[ $(gcc-major-version) -eq 4 && $(gcc-minor-version) -lt 8 ]] ) \
		; then
			eerror "${PN} needs to be built with gcc-4.8 or later."
			eerror "Please use gcc-config to switch to gcc-4.8 or later version."
			die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DJSONCPP_WITH_POST_BUILD_UNITTEST=OFF
		-DJSONCPP_WITH_PKGCONFIG_SUPPORT=ON
		-DJSONCPP_WITH_CMAKE_PACKAGE=ON
		-DJSONCPP_LIB_BUILD_SHARED=ON
		$(cmake-utils_use static-libs JSONCPP_LIB_BUILD_STATIC)
		$(cmake-utils_use test JSONCPP_WITH_TESTS)
	)
	cmake-multilib_src_configure
}

src_install() {
	cmake-multilib_src_install
	rm "${D}"/usr/$(get_libdir)/cmake/jsoncpp/jsoncppConfig-gentoo.cmake || die
	if use doc; then
		${EPYTHON} doxybuild.py --doxygen=/usr/bin/doxygen || die
		dohtml dist/doxygen/jsoncpp*/*
	fi
}
