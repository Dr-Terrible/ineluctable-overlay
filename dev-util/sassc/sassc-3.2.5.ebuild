# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
AUTOTOOLS_AUTORECONF=1
inherit autotools-utils

DESCRIPTION="SaasC is an implementer for LibSaas"
HOMEPAGE="http://github.com/sass/sassc"
SRC_URI="https://github.com/sass/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="=dev-libs/libsass-${PV}[static-libs]"

src_prepare() {
	# Fix makefiles
	rm Makefile || die
	sed -i \
		-e "s:-Wall -fPIC::" \
		-e "s:-Wall::" \
		Makefile.am || die

	# Fix versioning
	cat <<EOF > VERSION
${PV}
EOF

	# Fix autoconf
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		--disable-shared
		--enable-static
	)
	autotools-utils_src_configure
}
