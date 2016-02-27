# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit scons-utils

MY_PN="${PN//systemtap/stap}"
EGIT_COMMIT="5b4259f6228955e74a9a0d9030563916328928e0"

DESCRIPTION="Dynamic Tracing with DTrace and SystemTap"
HOMEPAGE="http://myaut.github.io/dtrace-stap-book"
SRC_URI="https://github.com/myaut/${MY_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

S="${WORKDIR}/${MY_PN}-${EGIT_COMMIT}"

DEPEND="media-gfx/inkscape
	dev-python/lesscpy"

RESTRICT="binchecks strip test mirror"

src_compile() {
	escons
}
src_install() {
	dohtml -r build/*
}