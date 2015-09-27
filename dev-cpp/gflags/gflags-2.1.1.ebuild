# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils cmake-multilib

DESCRIPTION="Google's C++ argument parsing library"
HOMEPAGE="http://code.google.com/p/gflags"
SRC_URI="https://github.com/schuhschuh/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="static-libs doc test"

DOCS=(AUTHORS.txt ChangeLog.txt NEWS.txt README.txt)
src_configure() {
	local mycmakeargs=(
#		-DBUILD_SHARED_LIBS=ON
		$(cmake-utils_use static-libs BUILD_STATIC_LIBS)
		$(cmake-utils_use test BUILD_TESTING)
	)
	cmake-multilib_src_configure
}

src_install() {
	cmake-multilib_src_install
	use doc && dohtml -r "${S}"/doc/*
}