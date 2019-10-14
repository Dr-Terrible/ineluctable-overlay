# Copyright 1999-2019 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils ltprune multilib-minimal

MY_PV="${PV/_beta/-beta}"

DESCRIPTION="A small C library for building user interfaces with C, XML and CSS<Paste>"
HOMEPAGE="https://lcui.org https://github.com/lc-soft/LCUI"
SRC_URI="https://github.com/lc-soft/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="amd64 arm x86"
LICENSE="MIT"
SLOT="0"
IUSE="+png +jpeg +X +truetype debug video builder static-libs"

RESTRICT="mirror"

S="${WORKDIR}/LCUI-${MY_PV}"

REQUIRED_USE="video? ( X )"

RDEPEND="builder? ( dev-libs/libxml2:2[${MULTILIB_USEDEP}] )
	X? ( x11-libs/libX11:0[${MULTILIB_USEDEP}] )
	truetype? ( media-libs/freetype:2[X?,${MULTILIB_USEDEP}] )
	jpeg? ( media-libs/libjpeg-turbo:0[${MULTILIB_USEDEP}] )
	png? ( media-libs/libpng:0[${MULTILIB_USEDEP}] )"

src_prepare() {
	default
	eautoreconf
	multilib_copy_sources
}

multilib_src_configure() {
	econf \
		--disable-dependency-tracking \
		--with-pthread \
		$(use_with X x) \
		$(use_with png) \
		$(use_with jpeg) \
		$(use_enable static-libs static) \
		$(use_enable truetype font-engine) \
		$(use_enable video video-output) \
		$(use_enable builder lcui-builder) \
		$(use_enable debug)
}
