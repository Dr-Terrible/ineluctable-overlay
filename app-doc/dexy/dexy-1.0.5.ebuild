# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

DESCRIPTION="Dexy is a tool for writing documents which relate to code"
HOMEPAGE="http://dexy.it"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/beautifulsoup:4
	>=dev-python/cashew-0.2.7
	dev-python/chardet
	dev-python/jinja
	dev-python/pexpect
	dev-python/ply
	dev-python/pygments
	>=dev-python/python-modargs-1.7
	>=dev-python/requests-0.10.6
	dev-python/markdown
	dev-python/docutils
	dev-python/dexy-viewer"
DEPEND="${RDEPEND}"

DOCS="README"

src_prepare() {
	# FIX: see http://comments.gmane.org/gmane.linux.gentoo.python/378
	rm -r tests || die
	distutils-r1_src_prepare
}