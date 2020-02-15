# Copyright 1999-2020 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{6,7,8} )
inherit distutils-r1

DESCRIPTION="A Generic plug-in system for python"
HOMEPAGE="https://pypi.python.org/pypi/${PN}"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DOCS="README.rst"