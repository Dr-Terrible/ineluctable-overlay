# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
SUPPORT_PYTHON_ABIS=1
PYTHON_DEPEND=2
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

DESCRIPTION="Fields pack for django framework."
HOMEPAGE="https://github.com/svetlyak40wt/django-fields"
SRC_URI="https://github.com/svetlyak40wt/${PN}/tarball/${PV} -> ${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/django
	dev-python/pycrypto"

S="${WORKDIR}/svetlyak40wt-${PN}-756a6c9"
