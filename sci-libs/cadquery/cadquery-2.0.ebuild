# Copyright 1999-2021 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="A parametric CAD scripting framework based on PythonOCC"
HOMEPAGE="https://cadquery.readthedocs.io"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test mirror"

PATCHES=( "${FILESDIR}/${P}"-no-tests.patch )

RDEPEND="dev-python/pythonocc[${PYTHON_USEDEP}]
	dev-python/pyparsing[${PYTHON_USEDEP}]"
