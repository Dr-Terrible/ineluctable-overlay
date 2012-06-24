# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
SUPPORT_PYTHON_ABIS=1
PYTHON_DEPEND="2:2.6"
RESTRICT_PYTHON_ABIS="3.* *-jython 2.7-pypy-*"
inherit distutils

DESCRIPTION="Wsgid is a generic WSGI handler for mongrel2 web server."
HOMEPAGE="http://wsgid.com"
SRC_URI="http://wsgid.com/static/downloads/${PN}-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=">=www-servers/mongrel-1.7.5:2
	dev-python/plugnplay
	dev-python/pyzmq
	dev-python/python-daemon"

src_install(){
	distutils_src_install
	doman doc/wsgid.8.bz2
	newconfd "${FILESDIR}"/wsgid.confd wsgid || die
	newinitd "${FILESDIR}"/wsgid.initd wsgid || die
}
