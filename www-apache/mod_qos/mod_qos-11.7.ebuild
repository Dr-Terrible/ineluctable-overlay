# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
AUTOTOOLS_IN_SOURCE_BUILD=1
AUTOTOOLS_AUTORECONF=1
inherit apache-module autotools-utils

DESCRIPTION="A QOS module for the apache webserver"
HOMEPAGE="http://mod-qos.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN/_/-}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
#IUSE="doc ssl"
IUSE="doc"
RESTRICT="mirror"

CDEPEND=">=dev-libs/libpcre-8.30:3
	sys-libs/zlib:0
	media-libs/libpng:0
	dev-libs/openssl:0
	www-servers/apache[ssl]"
DEPEND="${CDEPEND}"
RDEPEND="${CDEPEND}"

APXS2_S="${S}/apache2"
APACHE2_MOD_CONF="10_${PN}"
APACHE2_MOD_DEFINE="QOS"
DOCFILES="${S}/doc/*.txt ${S}/README.TXT"

need_apache2

src_prepare() {
	cd "${S}/tools" || die
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		--disable-dependency-tracking
		--disable-use-static
		${EXTRA_ECONF}
	)
	ECONF_SOURCE="${S}/tools" \
		autotools-utils_src_configure
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
	emake -C "${S}/tools" install DESTDIR="${ED}" || die "make install failed"

	# installing html documentation
	use doc && dohtml -r -x *.txt "${S}/doc/"

	# remove useless .a / .la files
	find "${ED}" "(" -name '*.la' -o -name '*.a' ")" -delete || die
}
