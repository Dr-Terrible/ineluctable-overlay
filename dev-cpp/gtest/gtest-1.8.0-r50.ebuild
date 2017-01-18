# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

# Python is required for tests and some build tasks.
PYTHON_COMPAT=( python{2_7,3_4,3_5} )
inherit python-any-r1 cmake-utils

DESCRIPTION="Google C++ Testing Framework"
HOMEPAGE="https://github.com/google/googletest"
SRC_URI="https://github.com/google/googletest/archive/release-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE="static-libs test"

S="${WORKDIR}/googletest-release-${PV}"

DEPEND="${PYTHON_DEPS}"

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	# Fix multilib-strict error
	sed -i \
		-e "s:DESTINATION lib:DESTINATION $(get_libdir):" \
		googletest/CMakeLists.txt \
		|| die
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-Wno-dev
		-DBUILD_GTEST=ON
		-DBUILD_GMOCK=OFF
		-Dgtest_disable_pthreads=OFF
		-Dgtest_build_samples=OFF
		-Dgtest_hide_internal_symbols=$(usex !static-libs)
		-DBUILD_SHARED_LIBS="$(usex !static-libs)"
		-Dgtest_build_tests="$(usex test)"
	)
	cmake-utils_src_configure
}
