# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit distutils-r1

DESCRIPTION="Library to open and read files in the epub version 2"
HOMEPAGE="https://pypi.python.org/pypi/${PN}"
SRC_URI="mirror://pypi/e/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm x86"

RESTRICT+=" mirror"
