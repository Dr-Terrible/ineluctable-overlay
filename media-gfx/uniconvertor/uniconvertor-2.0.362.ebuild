# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit distutils-r1 versionator subversion

REV="$( get_version_component_range 3 )"
ESVN_PROJECT="${PN}"
ESVN_REPO_URI="http://${PN}.googlecode.com/svn/trunk@${REV}"

DESCRIPTION="UniConvertor is a universal vector graphics translator"
HOMEPAGE="https://code.google.com/p/uniconvertor/"

LICENSE="HPND"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND="media-gfx/potrace"