# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit qt4-r2

DESCRIPTION="The Constructive Solid Geometry rendering library"
HOMEPAGE="http://www.opencsg.org/"
SRC_URI="http://www.opencsg.org/OpenCSG-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND="media-libs/glew x11-libs/qt-core:4"
DEPEND="${CDEPEND} sys-devel/gcc"
RDEPEND="${CDEPEND}"

S="${WORKDIR}/OpenCSG-${PV}"

#src_unpack() {
#	unpack ${A}
#
#	/bin/rm -Rf "${S}"/glew
#}

src_prepare() {
	# We actually want to install somthing
	cat << EOF >> src/src.pro
include.path=/usr/include
include.files=../include/*
target.path=$(get_libdir)
INSTALLS += target include
EOF

}

src_configure() {
	 eqmake4 "${S}"/src/src.pro
}
