# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit distutils-r1 git-2

DESCRIPTION="Muddle is set of tools that aid building pluggable django apps"
HOMEPAGE="http://code.osuosl.org/projects/muddle"
#SRC_URI="http://dev.gentoo.org/~ago/distfiles/ganeti/${P}.tar.gz"
EGIT_REPO_URI="git://git.osuosl.org/gitolite/django/muddle"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/django"
