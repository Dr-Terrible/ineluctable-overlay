# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools multilib-build

DESCRIPTION="SaasC is an implementer for LibSaas"
HOMEPAGE="http://github.com/sass/sassc"
SRC_URI="https://github.com/sass/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm x86"

DEPEND=">=dev-libs/libsass-3.4.0:0/0.0.9"

src_prepare() {
	# Fix makefiles
	rm Makefile || die
	sed -i \
		-e "s:-Wall::" \
		Makefile.am || die

	# Fix versioning
	cat <<EOF > VERSION
${PV}
EOF

	# Fix autoconf
	default
	eautoreconf
	multilib_copy_sources
}
