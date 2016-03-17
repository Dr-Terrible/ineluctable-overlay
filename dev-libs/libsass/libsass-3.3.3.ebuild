# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1  # Fix versioning
inherit autotools-utils

DESCRIPTION="LibSaas is a C/C++ port of the Sass engine."
HOMEPAGE="http://libsass.org"
SRC_URI="https://github.com/sass/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="static-libs test"

src_prepare() {
	# Fix makefiles
	rm Makefile || die
	sed -i \
		-e "s:-Wall::" \
		GNUmakefile.am \
		src/GNUmakefile.am \
		|| die

	# Fix versioning
	cat <<EOF > VERSION
${PV}
EOF

	# Fix autoconf
	autotools-utils_src_prepare
}
