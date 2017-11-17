# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=1
inherit autotools-utils

DESCRIPTION="Mustache templating for C++"
HOMEPAGE="https://github.com/mrtazz/plustache"
SRC_URI="https://github.com/mrtazz/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="test static-libs"

DEPEND="test? ( dev-cpp/gtest )"
RDEPEND="dev-libs/boost"

PATCHES=( "${FILESDIR}/${PN}-autotools.patch" )

src_prepare() {
	# remove bundled libs
	rm -r vendor/ || die
	autotools-utils_src_prepare
}

src_configure() {
	#ECONF_SOURCE="${BUILD_DIR}"
	local myeconfargs=(
		$(use_enable static-libs static)
	)
	autotools-utils_src_configure
}

src_test() {
	autotools-utils_src_test
	"${BUILD_DIR}"/test-program || die
}
