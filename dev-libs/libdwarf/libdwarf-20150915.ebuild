# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1
inherit autotools-utils

DESCRIPTION="Library to deal with DWARF Debugging Information Format"
HOMEPAGE="http://prevanders.net/dwarf.html"
SRC_URI="http://www.prevanders.net/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE="static-libs doc"

S=${WORKDIR}/dwarf-${PV}/${PN}

RESTRICT+=" mirror"

src_configure() {
	local myeconfargs=(
		--enable-shared
		$(use static-libs || echo "--disable-nonshared")
	)
	autotools-utils_src_configure
}

src_install() {
	# Installing libraries
	dolib.so ${PN}.so
	use static-libs && dolib.a ${PN}.a

	# Installing headers
	doheader ${PN}.h

	# Installing docs
	einstalldocs
	use doc && dodoc *.pdf
}
