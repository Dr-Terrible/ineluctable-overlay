# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

SUPPORT_PYTHON_ABIS=1
PYTHON_DEPEND="2:2.7"
RESTRICT_PYTHON_ABIS="3.*"
#RESTRICT_PYTHON_ABIS="3.* *-jython 2.7-pypy-*"

inherit distutils

DESCRIPTION="A book compiler for programmers where code and prose are separate."
HOMEPAGE="http://pypi.python.org/pypi/${PN}"
SRC_URI="http://www.dexy.it/external-dependencies/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"
