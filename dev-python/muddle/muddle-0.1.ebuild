# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
SUPPORT_PYTHON_ABIS=1
PYTHON_DEPEND=2
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

DESCRIPTION="Muddle is set of tools that aid building pluggable django apps."
HOMEPAGE="http://code.osuosl.org/projects/muddle"
SRC_URI="http://dev.gentoo.org/~ago/distfiles/ganeti/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/django"

S="${WORKDIR}/${PN//-/_}-af7a807"
