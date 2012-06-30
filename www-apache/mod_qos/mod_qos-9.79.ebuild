# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit apache-module autotools

DESCRIPTION="A QOS module for the apache webserver"
HOMEPAGE="http://mod-qos.sourceforge.net"
SRC_URI="mirror://sourceforge/mod-qos/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="doc ssl"

COMMON_DEPEND="<=dev-libs/libpcre-8.12
	sys-libs/zlib
	media-libs/libpng
	ssl? (
		dev-libs/openssl
		www-servers/apache[ssl]
	)"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

APXS2_S="${S}/apache2"
APACHE2_MOD_CONF="10_${PN}"
APACHE2_MOD_DEFINE="QOS"
DOCFILES="${S}/doc/*.txt ${S}/README.TXT"

need_apache2

src_prepare() {
	cd "${S}/tools" || die
	eautoreconf
}

src_configure() {
	cd "${S}/tools" || die
	econf \
		--disable-dependency-tracking \
		--disable-use-static \
		$(use ssl || echo "--disable-ssl") \
		${EXTRA_ECONF}
}

src_compile() {
	apache-module_src_compile
	emake -C "${S}/tools" || die "make failed"
}

src_install() {
	einfo "Installing Apache module ..."
	cd "${S}/tools" || die
	apache-module_src_install

	einfo "Installing module utilities ..."
	emake -C "${S}/tools" install DESTDIR="${D}" || die "make install failed"

	# installing html documentation
	use doc && dohtml -r -x *.txt "${S}/doc/"
}
