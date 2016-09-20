# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="gitfs is a FUSE file system that fully integrates with git"
HOMEPAGE="https://www.presslabs.com/gitfs/"
SRC_URI="https://github.com/PressLabs/${PN}/archive/${PV}.tar.gz -> ${PF}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

RESTRICT+=" mirror"

PATCHES=(
	"${FILESDIR}"/${PN}-deps.patch
)

DEPEND="doc? ( dev-python/mkdocs[${PYTHON_USEDEP}] )"
RDEPEND="dev-python/atomiclong[${PYTHON_USEDEP}]
	>=dev-python/pygit2-0.24.0[${PYTHON_USEDEP}]
	>=dev-python/fusepy-2.0.2[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]"

src_install() {
	distutils-r1_src_install

	mkdocs build || die
	exit
}
