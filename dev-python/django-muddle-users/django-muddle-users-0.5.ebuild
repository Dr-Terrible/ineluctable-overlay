# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
SUPPORT_PYTHON_ABIS=1
PYTHON_DEPEND=2
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

DESCRIPTION="Muddle Users is an django app that provides management interface
for Users and Groups"
HOMEPAGE="http://code.osuosl.org/projects/muddle-users"
SRC_URI="http://dev.gentoo.org/~ago/distfiles/ganeti/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/django
	dev-python/django-object-permissions
	dev-python/django-object-log
	dev-python/muddle"

S="${WORKDIR}/${PN//-/_}-f71d4fa"
