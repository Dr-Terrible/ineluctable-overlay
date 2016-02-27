# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

DESCRIPTION="Muddled layout for Ganeti Web Manager"
HOMEPAGE="http://git.osuosl.org/?p=gitolite/ganeti/ganeti_webmgr_layout.git;a=summary"
SRC_URI="http://dev.gentoo.org/~ago/distfiles/ganeti/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/django"

S="${WORKDIR}/${PN//-/_}-ade6b12"
