# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7} )
inherit distutils-r1

DESCRIPTION="A Dexy's plugin for runnning a local web server for previewing your  docs and snippets."
HOMEPAGE="http://dexy.github.io/cashew/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN//-/_}/${PN//-/_}-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/${PN//-/_}-${PV}"

RDEPEND="dev-python/webpy"
DEPEND="${RDEPEND}"