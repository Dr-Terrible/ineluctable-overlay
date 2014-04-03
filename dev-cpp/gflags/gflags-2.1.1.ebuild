# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit eutils cmake-multilib

DESCRIPTION="Google's C++ argument parsing library"
HOMEPAGE="http://code.google.com/p/gflags"
SRC_URI="https://github.com/schuhschuh/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="static-libs doc"

DOCS=(AUTHORS.txt ChangeLog.txt NEWS.txt README.txt)
src_configure() {
	local mycmakeargs=(
#		-DBUILD_SHARED_LIBS=ON
		 $(cmake-utils_use_with static-libs BUILD_STATIC_LIBS)
	)
	cmake-multilib_src_configure
}

src_install() {
	cmake-multilib_src_install
	use doc && dohtml -r "${S}"/doc/*
}