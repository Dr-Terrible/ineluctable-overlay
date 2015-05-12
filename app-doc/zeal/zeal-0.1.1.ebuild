# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit qmake-utils

DESCRIPTION="Offline documentation browser inspired by Dash"
HOMEPAGE="http://zealdocs.org"
SRC_URI="https://github.com/zealdocs/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm"
IUSE=""

DEPEND=""
RDEPEND="dev-qt/qtgui:5=
	dev-qt/qtwidgets:5=
	dev-qt/qtsql:5="

src_configure() {
	local myeqmakeargs=(
	)
	eqmake5 ${myeqmakeargs[@]} || die
}

src_install() {
	emake DESTDIR="${D}" INSTALL_ROOT="${ED}" install || die
}