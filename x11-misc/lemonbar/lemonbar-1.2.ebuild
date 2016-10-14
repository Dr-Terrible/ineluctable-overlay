# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Minimalist bar based on xcb, support UTF-8"
HOMEPAGE="https://github.com/lemonboy/bar"
SRC_URI="https://github.com/lemonboy/bar/archive/v${PV}.tar.gz -> ${PF}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE=""

S="${WORKDIR}/bar-${PV}"

RDEPEND="x11-libs/libxcb"
DEPEND="dev-lang/perl"

DOCS=()

src_prepare() {
	sed -i -e 's/-Os//' Makefile || die "Sed failed"
	default
}
