# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools multilib-minimal

DESCRIPTION="ETL is a multi-platform class and template library"
HOMEPAGE="https://synfig.org"
SRC_URI="https://github.com/synfig/synfig/releases/download/v${PV}/${P}.tar.gz -> ${PF}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug"

RESTRICT+=" mirror"

src_prepare() {
	einfo "Fixing FLAGS"
	sed -i -e 's/CXXFLAGS="`echo $CXXFLAGS | sed s:-g::` $debug_flags"//' \
		   -e 's/CFLAGS="`echo $CFLAGS | sed s:-g::` $debug_flags"//'     \
		m4/subs.m4

	eapply_user
	eautoreconf
}

multilib_src_configure() {
	local warnings_level="none"
	use debug && warnings_level="hardcore"

	local myconf=(
		--enable-warnings="${warnings_level}"
		$(use_enable debug)
	)

	ECONF_SOURCE=${S} econf "${myconf[@]}"
}

multilib_src_install_all() {
	prune_libtool_files --all
}
