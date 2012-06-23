# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython 2.7-pypy-*"

inherit distutils

DESCRIPTION="A book compiler for programmers where code and prose are separate
(a Yapps fork)."
HOMEPAGE="http://pypi.python.org/pypi/${PN}"
SRC_URI="http://www.dexy.it/external-dependencies/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

DOCS="NOTES"
