# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
USE_RUBY="ruby18 ruby19"

RUBY_FAKEGEM_DOCDIR="rdoc"

inherit ruby-fakegem

DESCRIPTION="HTTPI provides a common interface for Ruby HTTP libraries."
HOMEPAGE="https://github.com/rubiii/httpi"
SRC_URI="https://github.com/rubiii/${PN}/tarball/v${PV} -> ${P}.tgz"
RUBY_S="rubiii-httpi-*"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="${DEPEND}
	dev-ruby/autotest-rails
	>=dev-ruby/mocha-0.9.9
	>=dev-ruby/rake-0.9.2.2
	>=dev-ruby/rspec-2.7
	>=dev-ruby/webmock-1.6.4
	>=dev-ruby/zentest-4.7.0"
RDEPEND="${RDEPEND}
	dev-ruby/rake"
