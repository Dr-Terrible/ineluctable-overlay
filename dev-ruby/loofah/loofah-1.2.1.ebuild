# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
USE_RUBY="ruby18 ruby19"

#RUBY_FAKEGEM_VERSION="${PV//_/.}"
#RUBY_FAKEGEM_VERSION="${RUBY_FAKEGEM_VERSION//rc/rc.}"
RUBY_FAKEGEM_DOCDIR="rdoc"

inherit ruby-fakegem

DESCRIPTION="Loofah is a general library for manipulating and transforming
HTML/XML documents and fragments."
HOMEPAGE="https://github.com/flavorjones/loofah"
SRC_URI="https://github.com/flavorjones/${PN}/tarball/v${PV} -> ${P}.tgz"
RUBY_S="flavorjones-loofah-*"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="${DEPEND}
	dev-ruby/hoe
	dev-ruby/json
	virtual/ruby-minitest
	dev-ruby/rake
	dev-ruby/rr"
RDEPEND="${RDEPEND}
	dev-ruby/nokogiri"
