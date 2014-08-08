# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

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
