# Copyright 1999-2019 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools multilib-minimal

DESCRIPTION="ETL is a multi-platform class and template library"
HOMEPAGE="https://synfig.org"
SRC_URI="https://github.com/synfig/synfig/archive/v${PV}.tar.gz -> synfig-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug"

RESTRICT+=" mirror"

S="${WORKDIR}/synfig-${PV}/${PN}"

src_prepare() {
	default
	eautoreconf
	multilib_copy_sources
}

multilib_src_configure() {
	local warnings_level="none"
	use debug && warnings_level="hardcore"

	local myconf=(
		--disable-dependency-tracking
		--enable-warnings="${warnings_level}"
		$(use_enable debug)
	)
	econf "${myconf[@]}"
}
