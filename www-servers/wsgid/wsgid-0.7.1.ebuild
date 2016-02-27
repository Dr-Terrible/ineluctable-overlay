# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

DESCRIPTION="Wsgid is a generic WSGI handler for mongrel2 web server"
HOMEPAGE="http://wsgid.com"
SRC_URI="https://github.com/daltonmatos/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND=">=www-servers/mongrel-1.8.1:2
	dev-python/plugnplay
	dev-python/pyzmq
	dev-python/python-daemon"

src_install(){
	distutils-r1_src_install
	doman doc/wsgid.8.bz2
	newconfd "${FILESDIR}"/wsgid.confd wsgid || die
	newinitd "${FILESDIR}"/wsgid.initd wsgid || die
}