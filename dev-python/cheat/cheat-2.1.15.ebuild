# Copyright 1999-2019 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5,6} )
inherit distutils-r1

DESCRIPTION="Cheat allows you to create and view interactive cheatsheets on the command-line"
HOMEPAGE="https://github.com/chrisallenlane/cheat"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RESTRICT+=" mirror"

RDEPEND="dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/docopt[${PYTHON_USEDEP}]"
