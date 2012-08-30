# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
USE_RUBY="ruby18 ruby19"

RUBY_FAKEGEM_DOCDIR="rdoc"

inherit ruby-fakegem

DESCRIPTION="Declarative SAX Parsing with Nokogiri"
HOMEPAGE="https://github.com/pauldix/sax-machine"
SRC_URI="https://github.com/pauldix/${PN}/tarball/v${PV} -> ${P}.tgz"
RUBY_S="pauldix-${PN}-*"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="${DEPEND}"
RDEPEND="${RDEPEND}
	dev-ruby/nokogiri"
