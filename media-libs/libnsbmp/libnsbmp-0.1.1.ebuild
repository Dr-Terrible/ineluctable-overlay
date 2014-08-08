# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit netsurf

DESCRIPTION="decoding library for BMP and ICO image file formats, written in C"
HOMEPAGE="http://www.netsurf-browser.org/projects/libnsbmp/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~m68k-mint"
IUSE=""

src_prepare() {
	# FIX: pkgconfig install path
	sed  -i -e "s:\$(LIBDIR)/pkgconfig:share/pkgconfig:" \
		Makefile || die
	netsurf_src_prepare
}
src_install() {
	# FIX: lib install path
	export LIBDIR="${EPREFIX}/$(get_libdir)"
	netsurf_src_install
}