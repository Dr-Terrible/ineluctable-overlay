# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit netsurf

DESCRIPTION="string internment library, written in C"
HOMEPAGE="http://www.netsurf-browser.org/projects/libwapcaplet/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~m68k-mint"
IUSE="test"

REQUIRED_USE="amd64? ( abi_x86_32? ( !test ) )"
DEPEND="test? ( dev-libs/check )"

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