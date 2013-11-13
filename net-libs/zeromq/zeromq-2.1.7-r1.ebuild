# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# NOTES:
# 1- use flag 'pgm' (OpenPGM support) must be masked by profiles for ARM archs;

EAPI=5
WANT_AUTOCONF="2.5"
inherit autotools eutils

DESCRIPTION="ZeroMQ is a brokerless messaging kernel with extremely high performance."
HOMEPAGE="http://www.zeromq.org"
SRC_URI="http://download.zeromq.org/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="pgm test doc static-libs gcov"

COMMON_DEPEND="pgm? (
	>=net-libs/openpgm-5.1.116
	)"
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	doc? (
		app-text/asciidoc
		app-text/xmlto
	)
	sys-apps/util-linux"

src_prepare() {
	einfo "Removing bundled OpenPGM library"
	rm -r "${S}"/foreign/openpgm/libpgm* || die
	find "${S}" -name Makefile.in -delete || die
	eautoreconf
}

src_configure() {
	local myconf
	use pgm && myconf="--with-system-pgm "
	econf \
		${myconf} --without-pgm \
		--disable-dependency-tracking \
		$(use_enable static-libs static) \
		$(use_with doc documentation) \
		$(use_with gcov) \
		${EXTRA_ECONF}
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc NEWS README AUTHORS ChangeLog || die "dodoc failed."

	# remove useless .la files
	find "${D}" -name '*.la' -delete

	# remove useless .a (only for non static compilation)
	use static-libs || find "${D}" -name '*.a' -delete
}
