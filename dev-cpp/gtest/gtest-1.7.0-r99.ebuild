# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1
# Python is required for tests and some build tasks.
PYTHON_COMPAT=( python2_7 )

inherit eutils python-any-r1 autotools-multilib

DESCRIPTION="Google C++ Testing Framework"
HOMEPAGE="http://code.google.com/p/googletest/"
SRC_URI="http://googletest.googlecode.com/files/${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="examples static-libs test"

DEPEND="app-arch/unzip
	${PYTHON_DEPS}"
RDEPEND=""

DOCS=( CHANGES CONTRIBUTORS README )

PATCHES=(
	"${FILESDIR}/configure-fix-pthread-linking.patch" #371647
)

src_prepare() {
	sed -i -e "s|/tmp|${T}|g" test/gtest-filepath_test.cc || die
	sed -i -r \
		-e '/^install-(data|exec)-local:/s|^.*$|&\ndisabled-&|' \
		Makefile.am || die

	autotools-multilib_src_prepare
}

src_configure() {
	multilib_parallel_foreach_abi gtest_src_configure
}

src_install() {
	autotools-multilib_src_install
	multilib_for_best_abi gtest-config_install

	if use examples ; then
		insinto /usr/share/doc/${PF}/examples
		doins samples/*.{cc,h}
	fi
}

gtest_src_configure() {
	ECONF_SOURCE="${BUILD_DIR}"
	autotools-utils_src_configure
}

gtest-config_install() {
	dobin "${BUILD_DIR}/scripts/gtest-config"
}