# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

DESCRIPTION="Red Hat crash utility. Used for analyzing kernel core dumps"
HOMEPAGE="http://people.redhat.com/anderson/"
SRC_URI="http://people.redhat.com/anderson/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE="extensions"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-5.1.1-install-fix.patch

	# TODO: gdb is bundled and should be removed
}

src_compile() {
	default

	if use extensions; then
		emake extensions || die
	fi
}

src_install() {
	default

	insinto /usr/include/crash
	doins "${S}"/defs.h
}