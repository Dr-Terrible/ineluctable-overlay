# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit python-single-r1

DESCRIPTION="Gentoo's installer for web-based applications"
HOMEPAGE="https://github.com/svetlyak40wt/${PN}"
SRC_URI="https://github.com/svetlyak40wt/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="dev-python/docopt[${PYTHON_USEDEP}]
	dev-python/termcolor[${PYTHON_USEDEP}]"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare(){
	python_fix_shebang .
}

src_install() {
	default
	python_newexe bin/${PN//filer} ${PN}
	python_domodule bin/lib/dot
}
