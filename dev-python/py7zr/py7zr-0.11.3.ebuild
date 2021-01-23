# Copyright 1999-2021 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1
distutils_enable_tests pytest

DESCRIPTION="7zip implementation in python3 with various compression methods"
HOMEPAGE="https://pypi.python.org/pypi/${PN}"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 arm64 x86"
IUSE="test"

RESTRICT="mirror"

RDEPEND="dev-python/texttable[${PYTHON_USEDEP}]
	dev-python/pep517[${PYTHON_USEDEP}]
	dev-python/pycryptodome[${PYTHON_USEDEP}]"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		>=dev-python/pytest-2.8[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
		dev-python/pyannotate[${PYTHON_USEDEP}]
	)"
