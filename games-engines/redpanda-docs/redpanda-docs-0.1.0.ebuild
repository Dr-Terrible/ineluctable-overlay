# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
CMAKE_IN_SOURCE_BUILD=1
PYTHON_COMPAT=( python2_7 )
inherit python-single-r1 cmake-utils

DESCRIPTION="HTML documentation for RedPanda"
HOMEPAGE="http://butts.com"
SRC_URI="${PN//\-docs}.tar.xz"

LICENSE="CC-BY-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="+manual api"

DEPEND=">=dev-python/sphinx-1.2.2"

RESTRICT+=" mirror fetch"

S="${WORKDIR}/red-panda"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use manual BUILD_MANUAL)
		$(cmake-utils_use api BUILD_APIDOC)
	)
	cmake-utils_src_configure
}

src_compile() {
	if use manual; then
		emake manual || die
	fi
	if use api; then
		emake apidoc || die
	fi
}