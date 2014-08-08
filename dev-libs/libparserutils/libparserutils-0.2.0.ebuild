# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit flag-o-matic netsurf

DESCRIPTION="library for building efficient parsers, written in C"
HOMEPAGE="http://www.netsurf-browser.org/projects/libparserutils/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~m68k-mint"
IUSE="iconv test"

DEPEND="test? (	dev-lang/perl )"

DOCS=( README docs/Todo )

src_prepare() {
	# FIX: pkgconfig install path
	sed  -i -e "s:\$(LIBDIR)/pkgconfig:share/pkgconfig:" \
		Makefile || die
	netsurf_src_prepare
}
src_configure() {
	netsurf_src_configure
	append-cflags "-D$(usex iconv WITH WITHOUT)_ICONV_FILTER"
}
src_install() {
	# FIX: lib install path
	export LIBDIR="${EPREFIX}/$(get_libdir)"
	netsurf_src_install
}