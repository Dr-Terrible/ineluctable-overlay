# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
AUTOTOOLS_AUTORECONF=1
inherit autotools-multilib

ECOMMIT="ac0cfb03001b33066c28a1568ad45d9387934e3e"

DESCRIPTION="ETL is a multi-platform class and template library"
HOMEPAGE="http://synfig.org"
SRC_URI="https://github.com/synfig/synfig/archive/${ECOMMIT}.tar.gz -> ${PF}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

S="${WORKDIR}/synfig-${ECOMMIT}/${PN}"
RESTRICT+=" mirror"

src_prepare() {
	einfo "Fixing FLAGS"
	sed -i -e 's/CXXFLAGS="`echo $CXXFLAGS | sed s:-g::` $debug_flags"//' \
		   -e 's/CFLAGS="`echo $CFLAGS | sed s:-g::` $debug_flags"//'     \
		m4/subs.m4
	autotools-multilib_src_prepare
}

src_configure() {
	local warnings_level="none"
	use debug && warnings_level="hardcore"

	local myeconfargs=(
		--enable-warnings="${warnings_level}"
		$(use_enable debug)
	)
	autotools-multilib_src_configure
}
