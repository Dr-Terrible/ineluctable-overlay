# Copyright 1999-2021 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} pypy3 )
inherit distutils-r1

DESCRIPTION="A linter for prose"
HOMEPAGE="https://proselint.com https://github.com/amperser/proselint"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

# NOTE: tests require proselint to be already installed
RESTRICT="test"

DEPEND=">=dev-python/future-0.16.0[${PYTHON_USEDEP}]
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]"

python_prepare_all() {
	sed -i \
		-e "s:find_packages():find_packages(exclude=['tests']):g" \
		setup.py || die
	distutils-r1_python_prepare_all
}
