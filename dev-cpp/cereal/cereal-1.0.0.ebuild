# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-utils

DESCRIPTION="Cereal is a header-only C++11 serialization library"
HOMEPAGE="http://uscilab.github.io/cereal"
SRC_URI="https://github.com/USCiLab/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

# a gcc version high enough to support C++11/14 is required
DEPEND="test? (
		dev-libs/boost
		dev-util/valgrind
	)
	doc? ( app-doc/doxygen )
	>=sys-devel/gcc-4.8.0"

src_prepare() {
	sed -i \
		"s/-Wall -Werror -g -Wextra -Wshadow -pedantic//g" CMakeLists.txt || die
	sed -i -e \
		"s/@CMAKE_CURRENT_SOURCE_DIR@/./g" doc/doxygen.in || die
}

src_configure() {
	use test || return
	cmake-utils_src_configure
}
src_compile() {
	use test || return
	cmake-utils_src_compile
}

src_install() {
	insinto /usr/include
	doins -r include/cereal

	if use doc; then
		einfo "Generating API documentation with Doxygen ..."
		doxygen -u doc/doxygen.in || die
		doxygen doc/doxygen.in || die "doxygen failed"
		dohtml -r doc/html/*
	fi
}