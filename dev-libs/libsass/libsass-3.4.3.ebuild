# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools multilib-minimal

DESCRIPTION="LibSaas is a C/C++ port of the Sass engine."
HOMEPAGE="http://libsass.org"
SRC_URI="https://github.com/sass/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE="doc static-libs test"

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
	default
	eautoreconf
	multilib_copy_sources
}

multilib_src_install_all() {
	if use doc; then
		dodoc -r docs/*
	fi
}
