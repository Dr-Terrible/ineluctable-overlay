# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1
inherit autotools-multilib

DESCRIPTION="Google's C++ mocking framework"
HOMEPAGE="http://code.google.com/p/googlemock/"
SRC_URI="http://googlemock.googlecode.com/files/${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="static-libs test"

RDEPEND="=dev-cpp/gtest-${PV}*[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	app-arch/unzip"

DOCS=( CHANGES CONTRIBUTORS README )

src_prepare() {
	sed -i -r \
		-e '/^install-(data|exec)-local:/s|^.*$|&\ndisabled-&|' \
		Makefile.am || die

	autotools-multilib_src_prepare
}

src_configure() {
	multilib_parallel_foreach_abi gmock_src_configure
}

src_install() {
	autotools-multilib_src_install
	multilib_for_best_abi gmock-config_install
}

gmock_src_configure() {
	ECONF_SOURCE="${BUILD_DIR}"
	local myeconfargs=(
		$(use_enable static-libs static)
	)
	autotools-utils_src_configure
}

gmock-config_install() {
	dobin "${BUILD_DIR}/scripts/gmock-config"
}