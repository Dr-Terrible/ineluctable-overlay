# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit qt4-r2

DESCRIPTION="The Programmers Solid 3D CAD Modeller"
HOMEPAGE="http://www.openscad.org"
SRC_URI="https://${PN}.googlecode.com/files/${P}.src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="elibc_glibc"

CDEPEND="media-gfx/opencsg
	sci-mathematics/cgal[gmp,qt4]
	x11-libs/qt-core:4
	x11-libs/qt-gui:4
	x11-libs/qt-opengl:4
	media-libs/glew
	dev-cpp/eigen:2
	dev-libs/mpfr
	dev-libs/boost
	elibc_glibc? ( >=sys-libs/glibc-2.10 )"
DEPEND="${CDEPEND}
	sys-devel/bison
	sys-devel/flex"
RDEPEND="${CDEPEND}"

src_prepare() {
	# Use our CFLAGS (specifically don't force x86)
	sed -i "s/QMAKE_CXXFLAGS_RELEASE = .*//g" ${PN}.pro
	sed -i "s/\/usr\/local/\/usr/g" ${PN}.pro
}
