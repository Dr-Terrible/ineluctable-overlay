# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1
PYTHON_COMPAT=( python{2_7,3_3,3_4} )
inherit python-single-r1 autotools-utils

DESCRIPTION="A file watching service"
HOMEPAGE="https://facebook.github.io/watchman"
SRC_URI="https://github.com/facebook/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86 arm"
IUSE="debug +pcre python ssp test"

RESTRICT="mirror"

CDEPEND="pcre? ( dev-libs/libpcre )"
DEPEND="${CDEPEND}"
RDEPEND="${CDEPEND}"

src_configure() {
	STATEDIR="${EROOT}run/${PN}"

	local myeconfargs=(
		--enable-statedir="${STATEDIR}"
		--without-ruby
		$(use_with python)
		$(use_with pcre)
		$(use_enable debug lenient)
		$(use_enable ssp stack-protector)
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	# Fix QA warnings about /run/$PN
	rm -r "${D}/run" || die
}