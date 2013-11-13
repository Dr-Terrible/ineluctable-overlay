# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
# Needed for a sane .so versionning on fbsd, please dont drop
AUTOTOOLS_AUTORECONF=1

inherit eutils autotools-utils

MY_P=onig-${PV}

DESCRIPTION="a regular expression library for different character encodings"
HOMEPAGE="http://www.geocities.jp/kosako3/oniguruma"
SRC_URI="http://www.geocities.jp/kosako3/oniguruma/archive/${MY_P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="combination-explosion-check crnl-as-line-terminator static-libs"

PATCHES=( "${FILESDIR}"/${PN}-5.9.3-makefile.patch )
DOCS=( AUTHORS HISTORY README{,.ja} doc/{API,FAQ,RE}{,.ja} )

S=${WORKDIR}/${MY_P}

src_configure() {
	local myeconfargs=(
		$(use_enable combination-explosion-check)
		$(use_enable crnl-as-line-terminator)
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	use static-libs || prune_libtool_files
}
