# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

DESCRIPTION="This is an implementation of Django Object Permissions"
HOMEPAGE="http://code.osuosl.org/projects/django-object-permissions"
SRC_URI="http://dev.gentoo.org/~ago/distfiles/ganeti/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/django"

S="${WORKDIR}/${PN//-/_}-a825ec4"
