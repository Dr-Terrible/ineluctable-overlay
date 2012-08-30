# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
USE_RUBY="ruby18 ruby19"

RUBY_FAKEGEM_DOCDIR="rdoc"

inherit multilib ruby-fakegem

DESCRIPTION="Curb provides Ruby bindings for the libcurl(3), a fully-featured client-side URL transfer library."
HOMEPAGE="http://curb.rubyforge.org"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="${DEPEND}"
RDEPEND="${RDEPEND}
	net-misc/curl"

each_ruby_configure() {
	pwd
	${RUBY} -C ext extconf.rb || die
}

each_ruby_compile() {
	emake -C ext || die
	mv ext/curb_core$(get_modname) lib/ || die
}
