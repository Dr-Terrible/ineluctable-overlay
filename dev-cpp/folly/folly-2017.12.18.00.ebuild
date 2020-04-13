# Copyright 1999-2020 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit flag-o-matic autotools multilib-minimal

DESCRIPTION="An open-source C++ library developed and used at Facebook"
HOMEPAGE="https://github.com/facebook/folly"
SRC_URI="https://github.com/facebook/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	test? ( http://googletest.googlecode.com/files/gtest-1.7.0.zip )"

LICENSE="Apache-2.0"
SLOT="0/57.0"
KEYWORDS="amd64 x86"
IUSE="static-libs test libressl jemalloc"

CDEPEND="dev-libs/double-conversion
	!elibc_uclibc? ( dev-libs/boost:=[threads,context] )
	app-arch/lz4:0
	app-arch/snappy:0
	app-arch/xz-utils:0
	dev-cpp/gflags:0
	dev-cpp/glog:0
	jemalloc? ( dev-libs/jemalloc:0 )
	dev-libs/libevent:0
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	sys-libs/zlib:0"
DEPEND="${CDEPEND}
	test? ( dev-cpp/gtest )"
RDEPEND="${CDEPEND}"

S="${WORKDIR}/${P}/${PN}"

src_prepare() {
	default

	# FIX: gtest's source code must be moved inside the test/ directory
	if use test; then
		mv "${S}"/../../gtest-1.7.0 "${S}"/test/ || die
	fi

	eautoreconf

	# only sane way to deal with various version-related scripts, env variables etc.
	multilib_copy_sources
}

multilib_src_configure() {
	# FIX: dirty hack necessary for running the unit tests.
	#      I don't like it, but upstream refused a proper fix
	use test && append-ldflags -lcrypto -ldl

	econf \
		$(use_enable static-libs static) \
		$(use_with jemalloc) \
		--enable-shared
}
