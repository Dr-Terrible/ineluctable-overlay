# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A modern and lightweight status bar for X window managers"
HOMEPAGE="https://github.com/geommer/${PN}"
SRC_URI="https://github.com/geommer/${PN}/archive/${PV}.tar.gz -> ${PF}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="x11-libs/pango
	x11-libs/cairo[xcb]
	x11-libs/gdk-pixbuf
	dev-libs/libconfig
	x11-libs/xcb-util-wm"

src_prepare() {
	sed -i -e 's/-Os//' Makefile || die "Sed failed"
	default
}
