# Copyright 1999-2021 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="Functional programming tools for the shell"
HOMEPAGE="https://pypi.python.org/pypi/${PN}"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE="test"

RESTRICT+=" mirror"

BDEPEND="test? (
	dev-python/pytest[${PYTHON_USEDEP}]
	dev-python/nose[${PYTHON_USEDEP}]
)"

distutils_enable_tests pytest
