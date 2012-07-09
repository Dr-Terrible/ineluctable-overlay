# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
SUPPORT_PYTHON_ABIS=1
PYTHON_DEPEND=2
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

DESCRIPTION="Modular search for django"
HOMEPAGE="http://haystacksearch.org"
SRC_URI="https://github.com/toastdriven/${PN}/tarball/v${PV} -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/django
	>=dev-python/whoosh-0.3"

S="${WORKDIR}/toastdriven-${PN}-70e0985"
