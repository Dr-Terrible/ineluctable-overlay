# Copyright 1999-2021 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..8} )

inherit distutils-r1

DESCRIPTION="CadQuery GUI editor based on PyQT"
HOMEPAGE="https://github.com/CadQuery/${PN}"
SRC_URI="https://github.com/CadQuery/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test mirror"

RDEPEND="sci-libs/cadquery[${PYTHON_USEDEP}]
	dev-python/PyQt5[${PYTHON_USEDEP}]
	dev-python/spyder[${PYTHON_USEDEP}]
	dev-python/parso[${PYTHON_USEDEP}]
	dev-python/pyqtgraph[${PYTHON_USEDEP}]
	dev-python/logbook[${PYTHON_USEDEP}]
	dev-python/path-py[${PYTHON_USEDEP}]
	dev-python/qtconsole[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]"
