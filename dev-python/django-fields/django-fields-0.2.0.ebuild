# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

DESCRIPTION="Fields pack for django framework"
HOMEPAGE="https://github.com/svetlyak40wt/django-fields"
SRC_URI="https://github.com/svetlyak40wt/${PN}/tarball/${PV} -> ${P}.tar.gz"

LICENSE="HPND"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/django
	dev-python/pycrypto"

S="${WORKDIR}/svetlyak40wt-${PN}-756a6c9"
