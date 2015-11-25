# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7)
inherit python-r1

DESCRIPTION="Cli interface for dropbox (python), part of nautilus-dropbox"
HOMEPAGE="http://www.dropbox.com"
SRC_URI="http://www.dropbox.com/download?dl=packages/${PN//-cli}.py -> ${P}.py"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT+=" mirror"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="net-misc/dropbox
	${PYTHON_DEPS}"

S=${WORKDIR}

src_unpack() {
	cp "${DISTDIR}"/${P}.py "${S}" || die
}

src_install() {
	python_foreach_impl python_newscript ${P}.py ${PN}
}
