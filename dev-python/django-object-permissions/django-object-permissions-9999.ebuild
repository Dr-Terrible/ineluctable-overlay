# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
SUPPORT_PYTHON_ABIS=1
PYTHON_DEPEND=2
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils git-2

DESCRIPTION="This is an implementation of Django Object Permissions"
HOMEPAGE="http://code.osuosl.org/projects/django-object-permissions"
EGIT_REPO_URI="git://git.osuosl.org/gitolite/django/django_object_permissions"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/django"
