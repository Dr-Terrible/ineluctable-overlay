# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit flag-o-matic

DESCRIPTION="Library to deal with DWARF Debugging Information Format"
HOMEPAGE="http://prevanders.net/dwarf.html"
SRC_URI="http://www.prevanders.net/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE=""

DOCS=(NEWS README CHANGES)

S=${WORKDIR}/dwarf-${PV}/${PN}

src_prepare() {
	append-cflags -fPIC || die
}

src_configure() {
	econf --enable-shared \
		--disable-nonshared || die
}

src_install() {
#	dolib.a libdwarf.a || die
	dolib.so libdwarf.so || die

	insinto /usr/include
	doins libdwarf.h || die
}
