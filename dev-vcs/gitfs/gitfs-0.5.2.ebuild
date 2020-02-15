# Copyright 1999-2020 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} pypy3 )

inherit distutils-r1

DESCRIPTION="gitfs is a FUSE file system that fully integrates with git"
HOMEPAGE="https://www.presslabs.com/gitfs/"
SRC_URI="https://github.com/PressLabs/${PN}/archive/${PV}.tar.gz -> ${PF}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT+=" mirror"

RDEPEND="$(python_gen_any_dep '
	dev-python/atomiclong[${PYTHON_USEDEP}]
	>=dev-python/pygit2-0.28.2[${PYTHON_USEDEP}]
	>=dev-python/fusepy-3.0.1[${PYTHON_USEDEP}]
	>=dev-python/pycparser-2.19[${PYTHON_USEDEP}]
	>=dev-python/six-1.12.0[${PYTHON_USEDEP}]
	>=dev-python/raven-6.10.0[${PYTHON_USEDEP}]
')"

python_prepare_all() {
	# Loosen requirements
	sed -e 's|==|>=|' \
		-i requirements.txt || die

	distutils-r1_python_prepare_all
}