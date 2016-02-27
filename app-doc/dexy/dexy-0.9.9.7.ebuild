# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

DESCRIPTION="Dexy is a tool for writing documents which relate to code"
HOMEPAGE="http://dexy.it"
#SRC_URI="http://www.dexy.it/external-dependencies/${P}.tar.gz"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND="=dev-python/zapps-0.5.1
	dev-python/requests
	>=dev-python/python-modargs-1.4
	dev-python/pygments
	dev-python/pexpect
	dev-python/ordereddict
	dev-python/nose
	dev-python/jinja
	=dev-python/idiopidae-0.5.4
	dev-python/mock"
DEPEND="${RDEPEND}"

DOCS="README"
