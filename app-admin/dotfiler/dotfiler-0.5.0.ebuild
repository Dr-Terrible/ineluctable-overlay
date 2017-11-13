# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )
inherit python-single-r1

ECOMMIT="cb678f6e553dcde5b544babfe75c5d39c1de8850"

DESCRIPTION="Shell agnostic git based dotfiles package manager"
HOMEPAGE="https://github.com/svetlyak40wt/${PN}"
SRC_URI="https://github.com/svetlyak40wt/${PN}/archive/${ECOMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="dev-python/docopt[${PYTHON_USEDEP}]
	dev-python/termcolor[${PYTHON_USEDEP}]"

S="${WORKDIR}/${PN}-${ECOMMIT}"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare(){
	default
	python_fix_shebang .
}

src_install() {
	default
	python_newexe bin/${PN//filer} ${PN}
	python_domodule bin/lib/dot
}
