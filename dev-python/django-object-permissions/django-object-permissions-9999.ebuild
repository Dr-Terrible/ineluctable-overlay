# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit distutils-r1 git-2

DESCRIPTION="This is an implementation of Django Object Permissions"
HOMEPAGE="http://code.osuosl.org/projects/django-object-permissions"
EGIT_REPO_URI="git://git.osuosl.org/gitolite/django/django_object_permissions"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/django"
