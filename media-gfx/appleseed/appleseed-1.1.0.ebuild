# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit python-any-r1 cmake-multilib

DESCRIPTION="Appleseed is a modern, physically-based production renderer."
HOMEPAGE="http://appleseedhq.net"
SRC_URI="https://github.com/${PN}hq/${PN}/archive/${PV}-beta.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="alembic cli qt tools python cpu_flags_x86_sse debug"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

DEPEND="dev-libs/boost:=[python?,threads]
	alembic? ( dev-python/alembic )
	media-libs/openexr
	media-libs/openimageio
	media-libs/libpng:0
	dev-libs/xerces-c
	sys-libs/zlib"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}-beta"

pkg_setup() {
	use python && python-any-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DUSE_EXTERNAL_ALEMBIC=ON
		-DUSE_EXTERNAL_EXR=ON
		-DUSE_EXTERNAL_OIIO=ON
		-DUSE_EXTERNAL_PNG=ON
		-DUSE_EXTERNAL_XERCES=ON
		-DUSE_EXTERNAL_ZLIB=ON
		-DUSE_STATIC_BOOST=OFF
		-DUSE_STATIC_OIIO=OFF
		-DUSE_STATIC_OSL=OFF
		-DCMAKE_BUILD_WITH_INSTALL_RPATH=FALSE
		-DWITH_OSL=OFF
		-DWITH_DISNEY_MATERIAL=OFF
		$(cmake-utils_use_with alembic)
		$(cmake-utils_use_with cli)
		$(cmake-utils_use_with qt STUDIO)
		$(cmake-utils_use_with tools)
		$(cmake-utils_use_use cpu_flags_x86_sse SSE)
	)
	cmake-multilib_src_configure
}