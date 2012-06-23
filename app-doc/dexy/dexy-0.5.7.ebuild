# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython 2.7-pypy-*"

inherit distutils

DESCRIPTION="Dexy is a tool for writing documents which relate to code."
HOMEPAGE="http://dexy.it"
SRC_URI="http://www.dexy.it/external-dependencies/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=">=dev-python/zapps-0.5
	dev-python/requests
	>=dev-python/python-modargs-1.4
	dev-python/pygments
	dev-python/pexpect
	dev-python/ordereddict
	dev-python/nose
	dev-python/Jinja2
	dev-python/idiopidae
	dev-python/mock"
DEPEND="${RDEPEND}"

DOCS="README"
