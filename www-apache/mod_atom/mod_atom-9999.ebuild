# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
AT_NOELIBTOOLIZE="yes"
inherit autotools apache-module subversion

DESCRIPTION="An Apache2 module providing an Atom Protocol implementation"
HOMEPAGE="http://http://code.google.com/p/mod-atom/"
ESVN_REPO_URI="http://mod-atom.googlecode.com/svn/trunk/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE="static-libs test"

DEPEND=""
RDEPEND="app-text/htmltidy"

#APACHE2_MOD_CONF="16_${PN}"
APACHE2_MOD_DEFINE="ATOMPUB"

DOCFILES="README"

need_apache2

src_prepare() {
	epatch "${FILESDIR}/${PN}-configure.patch"
	epatch "${FILESDIR}/${PN}-configure-macros.patch"
	epatch "${FILESDIR}/${PN}-configure-macros-mod-atom.patch"
	eautoreconf
}

src_configure() {
	econf \
		--disable-dependency-tracking \
		$(use_enable static-libs static) \
		$(use_enable test apachetest)
}
