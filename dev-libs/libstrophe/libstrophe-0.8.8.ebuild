# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=1
inherit autotools-utils

DESCRIPTION="A simple, lightweight C library for writing XMPP clients"
HOMEPAGE="http://strophe.im/libstrophe/"
SRC_URI="https://github.com/strophe/libstrophe/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( MIT GPL-3 )"
SLOT="0"
KEYWORDS="amd64 x86 arm"
IUSE="doc static-libs test examples"

RDEPEND="dev-libs/libxml2:2
	dev-libs/openssl:*"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( dev-libs/check )
	doc? ( app-doc/doxygen )"

src_configure() {
	# NOTE: by default libstrophe uses expat unless libxml2 is esplicitely required;
	# this ebuils force use of libxml2 because expat is slow, has memory leaks and
	# is unmaintained upstream.
	local myeconfargs=(
		--with-libxml2
		$(use_enable static-libs static)
		$(use_enable test static)
	)
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile

	if use doc; then
		doxygen || die
	fi
}

src_install() {
	autotools-utils_src_install

	use doc && dohtml -r docs/html/*
	use examples && dodoc -r examples
}
