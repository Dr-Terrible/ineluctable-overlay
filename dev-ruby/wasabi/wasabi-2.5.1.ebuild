# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
USE_RUBY="ruby18 ruby19"

inherit ruby-fakegem

DESCRIPTION="A simple WSDL parser"
HOMEPAGE="https://github.com/rubiii/wasabi"
SRC_URI="https://github.com/rubiii/${PN}/tarball/v${PV} -> ${P}.tgz"
RUBY_S="rubiii-${PN}-*"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="${DEPEND}
	dev-ruby/rake
	dev-ruby/rspec"
RDEPEND="${RDEPEND}
	dev-ruby/httpi
	dev-ruby/nokogiri"
