# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby21 ruby20"
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="README.md"
inherit ruby-fakegem

DESCRIPTION="A process monitoring framework in Ruby"
HOMEPAGE="http://godrb.com"
LICENSE="MIT"

KEYWORDS="~amd64 ~arm ~x86"
SLOT="0"
IUSE=""

all_ruby_install() {
	all_fakegem_install
	doinitd  "${FILESDIR}/${PN}.init.d"
	newconfd "${FILESDIR}/${PN}.conf.d" "${PN}"
}
