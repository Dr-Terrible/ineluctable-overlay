# Copyright 1999-2020 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{6,7,8} )
inherit distutils-r1

DESCRIPTION="Python bindings for the LZMA compression library"
HOMEPAGE="https://www.joachim-bauch.de/projects/pylzma/
	https://pypi.org/project/pylzma/"
# pypi tarball does not include test data
SRC_URI="https://github.com/fancycode/pylzma/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

DOCS=(doc/USAGE.md README.md)

python_compile() {
	python_is_python3 || local -x CFLAGS="${CFLAGS} -fno-strict-aliasing"
	distutils-r1_python_compile
}

python_test() {
	"${PYTHON}" -m unittest discover -v || die "Tests fail with ${EPYTHON}"
}