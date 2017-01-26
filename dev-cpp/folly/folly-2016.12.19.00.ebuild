# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1
inherit flag-o-matic autotools-utils versionator

DESCRIPTION="An open-source C++ library developed and used at Facebook"
HOMEPAGE="https://github.com/facebook/folly"
SRC_URI="https://github.com/facebook/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	test? ( http://googletest.googlecode.com/files/gtest-1.7.0.zip )"

LICENSE="Apache-2.0"
SLOT="0/57.0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs test libressl"

CDEPEND="dev-libs/double-conversion
	!elibc_uclibc? ( dev-libs/boost:=[threads,context] )
	app-arch/lz4:0
	app-arch/snappy:0
	app-arch/xz-utils:0
	dev-cpp/gflags:0
	dev-cpp/glog:0
	dev-libs/jemalloc:0
	dev-libs/libevent:0
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	sys-libs/zlib:0"
DEPEND="${CDEPEND}
	test? ( dev-cpp/gtest )"
RDEPEND="${CDEPEND}"

S="${WORKDIR}/${P}/${PN}"

pkg_pretend() {
	# A C++14 compliant compiler is required
	if ! version_is_at_least 5.1 $(gcc-version); then
		eerror "${PN} passes -std=c++14 to \${CXX} and requires a version"
		eerror "of gcc newer than 5.1.0"
	fi
}

src_prepare() {
	# FIX: gtest's source code must be moved inside the test/ directory
	if use test; then
		mv "${S}"/../../gtest-1.7.0 "${S}"/test/ || die
	fi

	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_enable static-libs static)
	)

	# FIX: dirty hack necessary for running the unit tests.
	#      I don't like it, but upstream refused a proper fix
	use test && append-ldflags -lcrypto -ldl

	autotools-utils_src_configure
}

src_test() {
	autotools-utils_src_test
}
