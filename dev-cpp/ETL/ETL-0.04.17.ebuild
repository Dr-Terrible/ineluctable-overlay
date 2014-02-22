# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit autotools

DESCRIPTION="ETL is a multi-platform class and template library"
HOMEPAGE="http://synfig.org"
SRC_URI="http://sourceforge.net/projects/synfig/files/releases/0.64.1/source/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

src_prepare() {
	sed -i -e 's/CXXFLAGS="`echo $CXXFLAGS | sed s:-g::` $debug_flags"//' \
		   -e 's/CFLAGS="`echo $CFLAGS | sed s:-g::` $debug_flags"//'     \
		m4/subs.m4

	eautoreconf
}

src_configure() {
	local warnings_level="none"
	use debug && warnings_level="hardcore"
	econf \
		--enable-warnings="${warnings_level}" \
		$(enable_debug debug)
}