# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit distutils-r1

DESCRIPTION="gitfs is a FUSE file system that fully integrates with git"
HOMEPAGE="https://www.presslabs.com/gitfs/"
SRC_URI="https://github.com/PressLabs/${PN}/archive/${PV}.tar.gz -> ${PF}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT+=" mirror"

PATCHES=(
	"${FILESDIR}"/${P}-deps.patch
)

RDEPEND="dev-python/atomiclong[${PYTHON_USEDEP}]
	>=dev-python/pygit2-0.24.1[${PYTHON_USEDEP}]
	>=dev-python/fusepy-2.0.2[${PYTHON_USEDEP}]
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/raven-5.27.0[${PYTHON_USEDEP}]"
