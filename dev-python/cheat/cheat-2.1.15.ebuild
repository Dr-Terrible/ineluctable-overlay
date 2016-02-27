# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )
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