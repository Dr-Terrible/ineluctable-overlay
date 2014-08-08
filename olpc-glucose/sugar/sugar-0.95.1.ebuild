# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit python-r1 autotools

DESCRIPTION="Artwork for Sugar look-and-feel"
HOMEPAGE="http://sugarlabs.org"
SRC_URI="http://download.sugarlabs.org/sources/sucrose/glucose/${PN}/${P}.tar.bz2"
LICENSE="LGPL-2.1"

SLOT="0"
KEYWORDS="x86 amd64"
IUSE="static-libs nls"

RDEPEND="~olpc-glucose/sugar-base-${PV}
	~olpc-glucose/sugar-toolkit-${PV}
	~olpc-glucose/sugar-artwork-${PV}
	gnome-base/gconf
	dev-python/gconf-python
	dev-python/dbus-python"

src_prepare() {
	eautoreconf
}
src_configure() {
	econf \
		--with-gconf-schema-file-dir="${D}"/etc/gconf/schemas \
		--disable-dependency-tracking \
		$(use_enable static-libs static) \
		$(use_enable nls) \
		${EXTRA_ECONF}
}

src_install() {
	default_src_install
	DOCS=( AUTHORS COPYING NEWS README )

	# remove useless .la files
	find "${D}" -name '*.la' -delete

	# remove useless .a (only for non static compilation)
	use static-libs || find "${D}" -name '*.a' -delete
}
