# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit autotools

DESCRIPTION="ETL is a multi-platform class and template library"
HOMEPAGE="http://synfig.org"
SRC_URI="mirror://sourceforge/synfig/ETL/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_prepare() {
	sed -i -e 's/CXXFLAGS="`echo $CXXFLAGS | sed s:-g::` $debug_flags"//' \
		   -e 's/CFLAGS="`echo $CFLAGS | sed s:-g::` $debug_flags"//'     \
		m4/subs.m4

	eautoreconf
}