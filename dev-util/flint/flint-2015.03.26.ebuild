# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
AUTOTOOLS_AUTORECONF=1
#AUTOTOOLS_IN_SOURCE_BUILD=1
inherit autotools-utils

EGIT_COMMIT="275b1253743aae7e5318575fd931d5e3313b8d0f"

DESCRIPTION="An open-source lint program for C++ developed by, and used at Facebook"
HOMEPAGE="https://github.com/facebook/flint"
SRC_URI="https://github.com/facebook/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${PN}-${EGIT_COMMIT}.tar.gz"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

RESTRICT="mirror"

DEPEND="dev-cpp/folly
	|| (
		>=dev-lang/dmd-bin-2.008
		>=dev-lang/dmd-2.008.0:*
	)"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-makefile.patch
)