# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{4,5,6} )
inherit distutils-r1

DESCRIPTION="A version control system built on top of Git"
HOMEPAGE="https://gitless.com"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/sh[${PYTHON_USEDEP}]
	dev-python/clint[${PYTHON_USEDEP}]
	dev-python/pygit2[${PYTHON_USEDEP}]
	dev-vcs/git"
