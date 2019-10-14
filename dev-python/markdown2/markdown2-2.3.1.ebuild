# Copyright 1999-2019 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy )

inherit distutils-r1

DESCRIPTION="Python Markdown language reimplementation"
SRC_URI="mirror://pypi/m/markdown2/${P}.zip"
HOMEPAGE="https://github.com/trentm/python-markdown2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-python/pygments[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

python_prepare_all() {
	# [issue52, knownfailure]
	rm -f test/tm-cases/issue52* || die

	distutils-r1_python_prepare_all
}

python_test() {
	cd test || die
	"${PYTHON}" test.py || die "Tests fail with ${EPYTHON}"
}
