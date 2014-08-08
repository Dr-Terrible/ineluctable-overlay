# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit distutils-r1 python-r1 versionator subversion

MY_PN="${PN//print/print-}"
REV="$( get_version_component_range 3 )"

ESVN_PROJECT="${MY_PN}"
ESVN_REPO_URI="http://${MY_PN}.googlecode.com/svn/trunk@${REV}"

DESCRIPTION="An open source vector graphics editor similar to CorelDRAW(tm)"
HOMEPAGE="http://code.google.com/p/print-design"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/python
	dev-python/pillow
	dev-python/wxpython[cairo]
	media-gfx/uniconvertor"