# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
AUTOTOOLS_AUTORECONF=1
inherit autotools-utils

DESCRIPTION="LibSaas is a C/C++ port of the Sass engine."
HOMEPAGE="http://libsass.org"
SRC_URI="https://github.com/sass/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

src_prepare() {
	sed -i \
		-e "s:-Wall -fPIC::" \
		-e "s:-Wall::" \
		Makefile.am || die
	sed -i \
		-e "s:-Wall -fPIC::" \
		-e "s:-Wall::" \
		Makefile || die
	autotools-utils_src_prepare
}

src_configure() {
	autotools-utils_src_configure LIBSASS_VERSION="${PV}"
}