# Copyright 1999-2021 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
PYTHON_REQ_USE=sqlite
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="A simple, standards-based, cli todo (aka: task) manager"
HOMEPAGE="https://github.com/pimutils/todoman"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/atomicwrites[${PYTHON_USEDEP}]
	>=dev-python/click-7[${PYTHON_USEDEP}]
	dev-python/click-log[${PYTHON_USEDEP}]
	dev-python/configobj[${PYTHON_USEDEP}]
	dev-python/humanize[${PYTHON_USEDEP}]
	dev-python/icalendar[${PYTHON_USEDEP}]
	dev-python/parsedatetime[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	dev-python/tabulate[${PYTHON_USEDEP}]
	dev-python/urwid[${PYTHON_USEDEP}]"
DEPEND="
	test? (
		dev-python/freezegun[${PYTHON_USEDEP}]
		dev-python/hypothesis[${PYTHON_USEDEP}]
	)"

RESTRICT="mirror test"

DOCS=( AUTHORS.rst CHANGELOG.rst README.rst todoman.conf.sample )

distutils_enable_tests pytest

src_test() {
	# https://github.com/pimutils/todoman/issues/320
	export TZ=UTC
	distutils-r1_src_test
}

src_install() {
	distutils-r1_src_install
	insinto /usr/share/bash-completion/completions
	doins contrib/completion/bash/_todo
	insinto /usr/share/zsh/site-functions
	doins contrib/completion/zsh/_todo
}
