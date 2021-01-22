# Copyright 1999-2021 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="A port of SmartyPants PHP to Python"
HOMEPAGE="https://github.com/leohemsted/${PN}.py"
SRC_URI="https://github.com/leohemsted/${PN}.py/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm x86"

S="${WORKDIR}/${PN}.py-${PV}"
