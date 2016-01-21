# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="toolbelt of useful classes and functions to be used with python-requests"
HOMEPAGE="http://toolbelt.readthedocs.org/"
SRC_URI="mirror://pypi/r/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE=""

RESTRICT+=" mirror"

DOCS=( AUTHORS.rst HISTORY.rst README.rst )
