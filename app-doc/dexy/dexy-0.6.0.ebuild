# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit git-2 distutils-r1

EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
EGIT_COMMIT="ac33c5b0097e3f7a18fe98396a202d3a11dbc833"

DESCRIPTION="Dexy is a tool for writing documents which relate to code"
HOMEPAGE="http://dexy.it"
#SRC_URI="http://www.dexy.it/external-dependencies/${P}.tar.gz"

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
