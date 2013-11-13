# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7} )
inherit distutils-r1

DESCRIPTION="Dexy is a tool for writing documents which relate to code."
HOMEPAGE="http://dexy.it"
SRC_URI="http://www.dexy.it/external-dependencies/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND=">=dev-python/zapps-0.5
	dev-python/requests
	>=dev-python/python-modargs-1.4
	dev-python/pygments
	dev-python/pexpect
	dev-python/ordereddict
	dev-python/nose
	dev-python/jinja
	dev-python/idiopidae
	dev-python/mock"
DEPEND="${RDEPEND}"

DOCS="README"
